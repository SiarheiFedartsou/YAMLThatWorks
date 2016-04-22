//
//  YAMLThatWorksTests.m
//  YAMLThatWorksTests
//
//  Created by Siarhei Fiedartsou on 04/21/2016.
//  Copyright (c) 2016 Siarhei Fiedartsou. All rights reserved.
//

@import XCTest;

@import YAMLThatWorks;

#import "YATWTestCase.h"

@interface Tests : YATWTestCase

@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testSimple
{
    NSData* data = [self dataFromYAMLFile:@"simple"];
    {
        NSError* error = nil;
        NSDictionary* result = [YATWSerialization YAMLObjectWithData:data options:YATWSerializationOptionsScalarDisableAutomaticConversion error:&error];
        NSDictionary* expected = @{@"test1": @"2", @"test2": @"4"};
        XCTAssertEqualObjects(result, expected);
        XCTAssertNil(error);
    }
    
    {
        NSError* error = nil;
        NSDictionary* result = [YATWSerialization YAMLObjectWithData:data options:0 error:&error];
        NSDictionary* expected = @{@"test1": @2, @"test2": @4};
        XCTAssertEqualObjects(result, expected);
        XCTAssertNil(error);
    }
}

- (void)testNonScalarKeys
{
    
    NSData* data = [self dataFromYAMLFile:@"non-scalar-keys"];
    
    {
        NSError* error = nil;
        NSDictionary* result = [YATWSerialization YAMLObjectWithData:data options:YATWSerializationOptionsScalarDisableAutomaticConversion error:&error];
        NSDictionary* expected = @{@[@"1", @"2"]: @"10"};
        XCTAssertEqualObjects(result, expected);
        XCTAssertNil(error);
    }
    
    {
        NSError* error = nil;
        NSDictionary* result = [YATWSerialization YAMLObjectWithData:data options:0 error:&error];
        NSDictionary* expected = @{@[@1, @2]: @10};
        XCTAssertEqualObjects(result, expected);
        XCTAssertNil(error);
    }
}

- (void)testStringAndNumberScalars
{
    NSData* data = [self dataFromYAMLFile:@"string-and-number-scalars"];
    
    {
        NSError* error = nil;
        NSDictionary* result = [YATWSerialization YAMLObjectWithData:data options:YATWSerializationOptionsScalarDisableAutomaticConversion error:&error];
        NSDictionary* expected = @{@"test1": @"2", @"test2": @"test"};
        XCTAssertEqualObjects(result, expected);
        XCTAssertNil(error);
    }
    
    {
        NSError* error = nil;
        NSDictionary* result = [YATWSerialization YAMLObjectWithData:data options:0 error:&error];
        NSDictionary* expected = @{@"test1": @2, @"test2": @"test"};
        XCTAssertEqualObjects(result, expected);
        XCTAssertNil(error);
    }
}

- (void)testError
{
    {
        const char* blablabla = "[blablabla";
        NSData* data = [NSData dataWithBytes:blablabla length:sizeof(blablabla)];
        NSError* error = nil;
        id result = [YATWSerialization YAMLObjectWithData:data options:YATWSerializationOptionsScalarDisableAutomaticConversion error:&error];
        XCTAssertNotNil(error);
        XCTAssertNil(result);
    }
    {
        const char* blablabla = "[blablabla";
        NSData* data = [NSData dataWithBytes:blablabla length:sizeof(blablabla)];
        XCTAssertNoThrow([YATWSerialization YAMLObjectWithData:data options:YATWSerializationOptionsScalarDisableAutomaticConversion error:nil]);
        XCTAssertNil([YATWSerialization YAMLObjectWithData:data options:YATWSerializationOptionsScalarDisableAutomaticConversion error:nil]);
    }
    
}

- (void)testSameKeys
{
//    NSData* data = [self dataFromYAMLFile:@"same-keys"];
//    
//    {
//        NSError* error = nil;
//        NSDictionary* result = [YATWSerialization YAMLObjectWithData:data options:0 error:&error];
//        // we cannot check array equality here, because we cannot guarantee order of elements in this case
//        XCTAssertEqual([result count], 1);
//        XCTAssertNil(error);
//    }
//    
//    {
//        NSError* error = nil;
//        NSArray* result = [YATWSerialization YAMLObjectWithData:data options:0 error:&error];
//        // we cannot check array equality here, because we cannot guarantee order of elements in this case
//        XCTAssertEqual([result count], 2);
//        XCTAssertNil(error);
//    }
}

- (void)testSet
{
    NSData* data = [self dataFromYAMLFile:@"set"];
    
    {
        NSError* error = nil;
        NSSet* result = [YATWSerialization YAMLObjectWithData:data options:YATWSerializationOptionsScalarDisableAutomaticConversion error:&error];
        NSSet* expected = [NSSet setWithArray:@[@"Mark McGwire", @"Sammy Sosa", @"Ken Griff"]];
        XCTAssertEqualObjects(result, expected);
        XCTAssertNil(error);
    }
}

- (void)testPairs
{
    
    NSData* data = [self dataFromYAMLFile:@"pairs"];
    
    {
        NSError* error = nil;
        NSDictionary* result = [YATWSerialization YAMLObjectWithData:data options:YATWSerializationOptionsScalarDisableAutomaticConversion error:&error];
        NSDictionary* expected = @{@"Block tasks": @[
                                           @{@"meeting": @"with team."},
                                           @{@"meeting": @"with boss."},
                                           @{@"break": @"lunch."},
                                           @{@"meeting": @"with client."}
                                           ],
                                   @"Flow tasks": @[
                                           @{@"meeting": @"with team"},
                                           @{@"meeting": @"with boss"}
                                           ]};
        XCTAssertEqualObjects(result, expected);
        XCTAssertNil(error);
    }
}

- (void)testOmap
{
    
    NSData* data = [self dataFromYAMLFile:@"omap"];
    
    {
        NSError* error = nil;
        NSDictionary* result = [YATWSerialization YAMLObjectWithData:data options:YATWSerializationOptionsScalarDisableAutomaticConversion error:&error];
        NSDictionary* expected = @{@"Block tasks": @[
                                           @{@"meeting": @"with team."},
                                           @{@"meeting": @"with boss."},
                                           @{@"break": @"lunch."},
                                           @{@"meeting": @"with client."}
                                           ],
                                   @"Flow tasks": @[
                                           @{@"meeting": @"with team"},
                                           @{@"meeting": @"with boss"}
                                           ]};
        XCTAssertEqualObjects(result, expected);
        XCTAssertNil(error);
    }
}

- (void) testBinary
{    NSData* data = [self dataFromYAMLFile:@"binary"];
    
    {
        NSError* error = nil;
        NSDictionary* result = [YATWSerialization YAMLObjectWithData:data options:YATWSerializationOptionsScalarDisableAutomaticConversion error:&error];
        XCTAssertTrue([result[@"multiline"] isKindOfClass:[NSData class]]);
        XCTAssertTrue([result[@"greetings"] isKindOfClass:[NSData class]]);
        XCTAssertEqualObjects([[NSString alloc] initWithData:result[@"greetings"] encoding:NSUTF8StringEncoding], @"hello");
        XCTAssertNil(error);
    }
    
}



@end

