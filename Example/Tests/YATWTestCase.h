//
//  YATWTestCase.h
//  YAMLThatWorks
//
//  Created by Sergey Fedortsov on 22.4.16.
//  Copyright © 2016 Siarhei Fiedartsou. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface YATWTestCase : XCTestCase
- (NSData*) dataFromYAMLFile:(NSString*)fileName;
@end
