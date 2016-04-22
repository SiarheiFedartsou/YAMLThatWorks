//
//  NSString+YATW.h
//  Pods
//
//  Created by Sergey Fedortsov on 22.4.16.
//
//

#import <Foundation/Foundation.h>

@interface NSString(YATW)
- (NSString*) yatw_stringBySkippingCharactersInSet:(NSCharacterSet*)characterSet;
@end
