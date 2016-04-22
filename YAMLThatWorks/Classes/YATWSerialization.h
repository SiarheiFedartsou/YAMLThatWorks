//
//  YATWSerialization.h
//  Pods
//
//  Created by Sergey Fedortsov on 21.4.16.
//
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, YATWSerializationOptions)
{
    YATWSerializationOptionsScalarDisableAutomaticConversion = 1 << 0,
};

extern NSString* _Nonnull const YATWSerializationErrorDomain;

@interface YATWSerialization : NSObject
+ (_Nullable id)YAMLObjectWithData:(NSData * _Nonnull)data options:(YATWSerializationOptions)options error:(NSError * _Nullable * _Nullable)error;
@end
