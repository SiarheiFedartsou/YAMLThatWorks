//
//  YATWSerialization.m
//  Pods
//
//  Created by Sergey Fedortsov on 21.4.16.
//
//

#import "YATWSerialization.h"

#include <yaml-cpp/yaml.h>
#include <iostream>

#import "YATWUtils.h"
#import "NSString+YATW.h"

using namespace yaml_that_works;

NSString* const YATWSerializationErrorDomain = @"YATWSerializationErrorDomain";

struct membuf : std::streambuf
{
    membuf(char* begin, char* end) {
        this->setg(begin, begin, end);
    }
};

@implementation YATWSerialization

+ (NSNumberFormatter*) numberFormatter
{
    static NSNumberFormatter* formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSNumberFormatter alloc] init];
    });
    return formatter;
}

+ (NSDateFormatter*) iso8601Formatter
{
    static NSDateFormatter* formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        [formatter setLocale:enUSPOSIXLocale];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    });
    return formatter;
}


+ (NSDictionary<NSString*, NSNumber*>*) boolValues
{
    static NSDictionary<NSString*, NSNumber*>* bools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bools = @{
                  @"y": @YES, @"Y": @YES, @"yes": @YES, @"Yes": @YES, @"YES": @YES,
                  @"n": @NO, @"N": @NO, @"no": @NO, @"No": @NO, @"NO": @NO,
                  @"true": @YES, @"True": @YES, @"TRUE": @YES,
                  @"false": @NO, @"False": @NO, @"FALSE": @NO,
                  @"on": @YES, @"On": @YES, @"ON": @YES,
                  @"off": @NO, @"Off": @NO, @"OFF": @NO
                  };
    });
    return bools;
}

+ (id) objectForTimestampScalar:(NSString*)scalar
{
    return [[self iso8601Formatter] dateFromString:scalar];
}

+ (id) objectForFloatScalar:(NSString*)scalar
{
    NSCharacterSet* charactersToSkip = [NSCharacterSet characterSetWithCharactersInString:@"_"];
    NSString* toScan = [scalar yatw_stringBySkippingCharactersInSet:charactersToSkip];
    NSScanner* scanner = [NSScanner scannerWithString:toScan];
    double value = 0.0f;
    if ([scanner scanDouble:&value]) {
        return @(value);
    } else {
        // should we use null here? maybe it will be better to return an error?
        return [NSNull null];
    }
}

+ (id) objectForIntScalar:(NSString*)scalar
{
    NSCharacterSet* charactersToSkip = [NSCharacterSet characterSetWithCharactersInString:@"_"];
    NSString* toScan = [scalar yatw_stringBySkippingCharactersInSet:charactersToSkip];
    NSScanner* scanner = [NSScanner scannerWithString:toScan];
    BOOL hexadecimal = [toScan hasPrefix:@"0x"] || [toScan hasPrefix:@"0X"];
    if (hexadecimal) {
        unsigned int value = 0;
        if ([scanner scanHexInt:&value]) {
            return @(value);
        } else {
            // should we use null here? maybe it will be better to return an error?
            return [NSNull null];
        }
    } else {
        NSInteger value = 0;
        if ([scanner scanInteger:&value]) {
            return @(value);
        } else {
            // should we use null here? maybe it will be better to return an error?
            return [NSNull null];
        }
    }
    
}

+ (id) objectForScalar:(const YAML::Node&)scalarNode options:(YATWSerializationOptions)options
{
    NSString* scalar = @(scalarNode.Scalar().c_str());
    
    if (IsBinary(scalarNode)) {
        NSData* binary = [[NSData alloc] initWithBase64EncodedString:scalar options:0];
        return binary;
    } else if (IsBool(scalarNode)) {
        return self.boolValues[scalar] ?: @YES;
    } else if (IsInt(scalarNode)) {
        return [self objectForIntScalar:scalar];
    } else if (IsFloat(scalarNode)) {
        return [self objectForFloatScalar:scalar];
    } else if (IsTimestamp(scalarNode)) {
        return [self objectForTimestampScalar:scalar];
    } else {
        if (options & YATWSerializationOptionsScalarDisableAutomaticConversion) {
            return scalar;
        } else {
            if (self.boolValues[scalar]) {
                return self.boolValues[scalar];
            }
            return [[self numberFormatter] numberFromString:scalar] ?: scalar;
        }
    }
}

+ (id) objectForNode:(const YAML::Node&)node options:(YATWSerializationOptions)options
{
    if (node.IsMap()) {
        if (IsSet(node)) {
            NSMutableSet* result = [[NSMutableSet alloc] initWithCapacity:node.size()];
            for (const auto& subnode : node) {
                id value = [self objectForNode:subnode.first options:options];
                [result addObject:value];
            }
            return [NSSet setWithSet:result];
        } else {
            NSMutableDictionary* result = [[NSMutableDictionary alloc] initWithCapacity:node.size()];
            for (const auto& subnode : node) {
                id key = [self objectForNode:subnode.first options:options];
                id value = [self objectForNode:subnode.second options:options];
                result[key] = value;
            }
            
            return [NSDictionary dictionaryWithDictionary:result];
        }
        
       
    } else if (node.IsNull()) {
        return [NSNull null];
    } else if (node.IsScalar()) {
        return [self objectForScalar:node options:options];
    } else if (node.IsSequence()) {
        NSMutableArray* result = [[NSMutableArray alloc] initWithCapacity:node.size()];
        for (const auto& subnode : node) {
            [result addObject:[self objectForNode:subnode options:options]];
        }
        return [NSArray arrayWithArray:result];
    }
    return nil;
}

+ (id)YAMLObjectWithData:(NSData *)data options:(YATWSerializationOptions)options error:(NSError * _Nullable *)error;
{
    NSMutableData* mutableData = [data mutableCopy];
    
    try {
        membuf sbuf((char*)[mutableData mutableBytes], (char*)[mutableData mutableBytes] + [mutableData length]);
        std::istream instream(&sbuf);
        
        YAML::Node root = YAML::Load(instream);
        
        return [self objectForNode:root options:options];
    } catch (const std::runtime_error& runtimeError) {
        if (error) {
            *error = [NSError errorWithDomain:YATWSerializationErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey: @(runtimeError.what())}];
        }
    } catch (...) {
        
    }
    
    return nil;
    
    
    
}

@end
