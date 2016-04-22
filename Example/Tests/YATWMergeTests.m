//
//  YATWMergeTests.m
//  YAMLThatWorks
//
//  Created by Sergey Fedortsov on 22.4.16.
//  Copyright © 2016 Siarhei Fiedartsou. All rights reserved.
//

@import XCTest;
@import YAMLThatWorks;

#import "YATWTestCase.h"

@interface YATWMergeTests : YATWTestCase

@end

@implementation YATWMergeTests

- (void) testMerge
{
    NSData* data = [self dataFromYAMLFile:@"merge"];
    
    NSError* error = nil;
    NSArray* result = [YATWSerialization YAMLObjectWithData:data options:YATWSerializationOptionsScalarAutomaticConversion error:&error];
    {
        NSDictionary* expected = @{@"x": @1, @"y": @2, @"r": @10, @"label": @"center/big"};
        XCTAssertEqualObjects(result[4], expected);
        XCTAssertEqualObjects(result[5], expected);
        XCTAssertEqualObjects(result[6], expected);
    }
    {
        NSDictionary* expected = @{@"x": @1, @"y": @2, @"r": @1, @"label": @"center/big"};
        XCTAssertEqualObjects(result[7], expected);
    }
    XCTAssertNil(error);
}

@end
