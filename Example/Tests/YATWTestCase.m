//
//  YATWTestCase.m
//  YAMLThatWorks
//
//  Created by Sergey Fedortsov on 22.4.16.
//  Copyright © 2016 Siarhei Fiedartsou. All rights reserved.
//

#import "YATWTestCase.h"

@implementation YATWTestCase


- (NSData*) dataFromYAMLFile:(NSString*)fileName
{
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    NSString* path = [bundle pathForResource:fileName ofType:@"yml"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    return data;
}

@end
