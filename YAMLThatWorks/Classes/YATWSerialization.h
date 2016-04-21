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
    YATWSerializationOptionsScalarAutomaticConversion = 1 << 0,
    YATWSerializationOptionsScalarAllowSameKeys = 1 << 1,
    
};

extern NSString* const YATWSerializationErrorDomain;

@interface YATWSerialization : NSObject
+ (id)YAMLObjectWithData:(NSData *)data options:(YATWSerializationOptions)options error:(NSError * _Nullable *)error;
@end
