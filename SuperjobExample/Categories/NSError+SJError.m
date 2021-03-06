//
// Created by Vladimir Burdukov on 16/06/15.
// Copyright (c) 2015 SuperJob. All rights reserved.
//

#import "NSError+SJError.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
static NSString *const kUnderlyingErrorKey = @"SJ_NSError_UnderlyingError";
static NSString *const kURLResponseKey = @"SJ_NSError_URLResponse";
static NSString *const kResponseObjectKey = @"SJ_NSError_ResponseObject";

@implementation NSError (SJError)

#pragma mark - Cross Layers error

- (NSError *)underlyingError {
    return self.userInfo[kUnderlyingErrorKey];
}

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code underlyingError:(NSError *)underlyingError {
    return [self errorWithDomain:domain code:code userInfo:nil underlyingError:underlyingError];
}

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code userInfo:(NSDictionary *)dict underlyingError:(NSError *)underlyingError {
    NSMutableDictionary *mutableUserInfo;
    if (dict) {
        mutableUserInfo = dict.mutableCopy;
    } else {
        mutableUserInfo = @{}.mutableCopy;
    }
    if (underlyingError) {
        mutableUserInfo[kUnderlyingErrorKey] = underlyingError;
    }

    return [NSError errorWithDomain:domain code:code userInfo:mutableUserInfo.copy];
}

#pragma mark - API errors

- (NSHTTPURLResponse *)urlResponse {
    return self.userInfo[kURLResponseKey];
}

- (id)responseObject {
    return self.userInfo[kResponseObjectKey];
}

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code urlResponse:(NSHTTPURLResponse *)urlResponse {
    return [self errorWithDomain:domain code:code userInfo:nil urlResponse:urlResponse];
}

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code userInfo:(NSDictionary *)dict urlResponse:(NSHTTPURLResponse *)urlResponse {
    return [self errorWithDomain:domain code:code userInfo:dict urlResponse:urlResponse responseObject:nil];
}

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code userInfo:(NSDictionary *)dict urlResponse:(NSHTTPURLResponse *)urlResponse responseObject:(id)responseObject {
    NSMutableDictionary *mutableUserInfo;
    if (dict) {
        mutableUserInfo = dict.mutableCopy;
    } else {
        mutableUserInfo = @{}.mutableCopy;
    }
    if (urlResponse) {
        mutableUserInfo[kURLResponseKey] = urlResponse;
    }
    if (responseObject) {
        mutableUserInfo[kResponseObjectKey] = responseObject;
    }

    return [NSError errorWithDomain:domain code:code userInfo:mutableUserInfo.copy];
}

+ (instancetype)errorByExtendingError:(NSError *)error urlResponse:(NSHTTPURLResponse *)urlResponse responseObject:(id)responseObject {
    if (error) {
        return [NSError errorWithDomain:error.domain code:error.code userInfo:error.userInfo urlResponse:urlResponse responseObject:responseObject];
    } else {
        return nil;
    }
}

@end

#pragma clang diagnostic pop
