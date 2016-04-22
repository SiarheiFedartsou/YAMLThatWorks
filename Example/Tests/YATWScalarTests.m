//
//  YATWScalarTests.m
//  YAMLThatWorks
//
//  Created by Sergey Fedortsov on 22.4.16.
//  Copyright © 2016 Siarhei Fiedartsou. All rights reserved.
//

@import XCTest;

@import YAMLThatWorks;

#import "YATWTestCase.h"


@interface YATWScalarTests : YATWTestCase

@end

@implementation YATWScalarTests

- (void) testBool
{
    NSData* data = [self dataFromYAMLFile:@"bool"];
    {
        NSError* error = nil;
        NSDictionary* result = [YATWSerialization YAMLObjectWithData:data options:0 error:&error];
        for (NSUInteger idx = 1; idx <= 11; ++idx) {
            NSString* key = [NSString stringWithFormat:@"boolean_yes_%lu", (unsigned long)idx];
            XCTAssertEqualObjects(result[key], @YES);
        }
        for (NSUInteger idx = 1; idx <= 11; ++idx) {
            NSString* key = [NSString stringWithFormat:@"boolean_no_%lu", (unsigned long)idx];
            XCTAssertEqualObjects(result[key], @NO);
        }
    }
    
}

- (void) testFloat
{
    NSData* data = [self dataFromYAMLFile:@"float"];
    {
        NSError* error = nil;
        NSDictionary* result = [YATWSerialization YAMLObjectWithData:data options:0 error:&error];
        XCTAssertEqualWithAccuracy([result[@"canonical"] doubleValue], 685230.15, DBL_EPSILON);
        XCTAssertEqualWithAccuracy([result[@"exponential"] doubleValue], 685230.15, DBL_EPSILON);
        XCTAssertEqualWithAccuracy([result[@"fixed"] doubleValue], 685230.15, DBL_EPSILON);
        
        // are not currently supported
//        XCTAssertTrue(isnan([result[@"not a number"] doubleValue]));
//        XCTAssertTrue(isinf([result[@"negative infinity"] doubleValue]));
//        XCTAssertEqual(signbit([result[@"negative infinity"] doubleValue]), 1);
        XCTAssertNil(error);
    }
}


- (void) testInt
{
    NSData* data = [self dataFromYAMLFile:@"int"];
    {
        NSError* error = nil;
        NSDictionary* result = [YATWSerialization YAMLObjectWithData:data options:0 error:&error];
        XCTAssertEqual([result[@"canonical"] intValue], 685230);
        XCTAssertEqual([result[@"decimal"] intValue], 685230);
        XCTAssertEqual([result[@"negative"] intValue], -685230);
        XCTAssertEqual([result[@"hexadecimal"] intValue], 685230);
        // are not currently supported
//        XCTAssertEqual([result[@"octal"] intValue], 685230);
//        XCTAssertEqual([result[@"binary"] intValue], 685230);
        XCTAssertNil(error);
    }
}

- (void) testTimestamp
{
    NSData* data = [self dataFromYAMLFile:@"timestamp"];
    {
        NSError* error = nil;
        NSDictionary* result = [YATWSerialization YAMLObjectWithData:data options:0 error:&error];
        XCTAssertEqualWithAccuracy([result[@"canonical"] timeIntervalSinceNow], [[NSDate dateWithTimeIntervalSinceReferenceDate:0] timeIntervalSinceNow], 0.2);
        // are not currently supported
//        XCTAssertEqualObjects(result[@"valid iso8601"], [NSDate dateWithTimeIntervalSinceNow:0]);
//        XCTAssertEqualObjects(result[@"space separated"], [NSDate dateWithTimeIntervalSinceNow:0]);
//        XCTAssertEqualObjects(result[@"no time zone (Z)"], [NSDate dateWithTimeIntervalSinceNow:0]);
//        XCTAssertEqualObjects(result[@"date (00:00:00Z)"], [NSDate dateWithTimeIntervalSinceNow:0]);
        
        XCTAssertNil(error);
    }
}

@end
