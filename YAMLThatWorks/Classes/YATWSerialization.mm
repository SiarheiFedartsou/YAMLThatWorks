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

+ (id) objectForScalar:(NSString*)scalar options:(YATWSerializationOptions)options
{
    if (options & YATWSerializationOptionsScalarAutomaticConversion) {
        if ([scalar isEqualToString:@"true"]) {
            return @YES;
        } else if ([scalar isEqualToString:@"false"]) {
            return @NO;
        }
        return [[self numberFormatter] numberFromString:scalar] ?: scalar;
    } else {
        return scalar;
    }
}

+ (id) objectForNode:(const YAML::Node&)node options:(YATWSerializationOptions)options
{
    if (node.IsMap()) {
        NSMutableDictionary* result = [[NSMutableDictionary alloc] initWithCapacity:node.size()];
        for (const auto& subnode : node) {
            result[[self objectForNode:subnode.first options:options]] = [self objectForNode:subnode.second options:options];
        }
        
        // it is very rare(in my opinion) case when we have map with not unique keys
        if ((options & YATWSerializationOptionsScalarAllowSameKeys) && node.size() != [result count]) {
            NSMutableArray* result = [[NSMutableArray alloc] initWithCapacity:node.size()];
            for (const auto& subnode : node) {
                NSDictionary* value = [NSDictionary dictionaryWithObject:[self objectForNode:subnode.second options:options] forKey:[self objectForNode:subnode.first options:options]];
                [result addObject:value];
            }
            return [NSArray arrayWithArray:result];
        } else {
            
            return [NSDictionary dictionaryWithDictionary:result];
        }
       
    } else if (node.IsNull()) {
        return [NSNull null];
    } else if (node.IsScalar()) {
        NSString* scalar = @(node.Scalar().c_str());
        return [self objectForScalar:scalar options:options];
    } else if (node.IsSequence()) {
        NSMutableArray* result = [[NSMutableArray alloc] initWithCapacity:node.size()];
        for (const auto& subnode : node) {
            [result addObject:[self objectForNode:subnode options:options]];
        }
        return [NSArray arrayWithArray:result];
    }
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
