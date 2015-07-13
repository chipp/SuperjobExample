//
// Created by Vladimir Burdukov on 16/06/15.
// Copyright (c) 2015 SuperJob. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
@interface NSError (SJError)

- (NSError *)linkedError;
+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code linkedError:(NSError *)linkedError;
+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code userInfo:(NSDictionary *)dict linkedError:(NSError *)linkedError;

- (NSHTTPURLResponse *)urlResponse;
- (id)responseObject;
+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code urlResponse:(NSHTTPURLResponse *)urlResponse;
+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code userInfo:(NSDictionary *)dict urlResponse:(NSHTTPURLResponse *)urlResponse;
+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code userInfo:(NSDictionary *)dict urlResponse:(NSHTTPURLResponse *)urlResponse responseObject:(id)responseObject;
+ (instancetype)errorByExtendingError:(NSError *)error urlResponse:(NSHTTPURLResponse *)urlResponse responseObject:(id)responseObject;

@end
#pragma clang diagnostic pop