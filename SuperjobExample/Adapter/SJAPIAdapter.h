//
// Created by Vladimir Burdukov on 13.07.15.
// Copyright (c) 2015 Superjob.ru. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const SJAPIAdapterErrorDomain;

typedef NS_ENUM(NSUInteger, SJAPIAdapterErrorCode) {
    SJAPIAdapterErrorCodeNone,
    SJAPIAdapterErrorCodeUndefined,
};

@interface SJAPIAdapter : NSObject

@end