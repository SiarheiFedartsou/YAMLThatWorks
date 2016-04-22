//
//  NSString+YATW.m
//  Pods
//
//  Created by Sergey Fedortsov on 22.4.16.
//
//

#import "NSString+YATW.h"

@implementation NSString(YATW)

- (NSString*) yatw_stringBySkippingCharactersInSet:(NSCharacterSet*)characterSet
{
    return [[self componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
}

@end
