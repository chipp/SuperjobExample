//
// Created by Vladimir Burdukov on 30/06/15.
// Copyright (c) 2015 Superjob. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"

@class RACSignal;

typedef NS_ENUM(NSUInteger, APIRequestMethod) {
    APIRequestMethodNone,
    APIRequestMethodGET,
    APIRequestMethodPOST,
    APIRequestMethodPUT,
    APIRequestMethodDELETE
};

@interface API : NSObject

#pragma mark - Path generators

+ (NSString *)pathWithComponents:(NSArray *)components;

#pragma mark - Requests

- (RACSignal *)getPath:(NSString *)path withParams:(NSDictionary *)params;
- (RACSignal *)deletePath:(NSString *)path withParams:(NSDictionary *)params;
- (RACSignal *)postPath:(NSString *)path withParams:(NSDictionary *)params;
- (RACSignal *)putPath:(NSString *)path withParams:(NSDictionary *)params;

@end

#pragma clang diagnostic pop