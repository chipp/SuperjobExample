//
// Created by Vladimir Burdukov on 23.08.15.
// Copyright (c) 2015 Superjob.ru. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@interface FakeAPI : NSObject

- (RACSignal *)getPath:(__unused NSString *)path withParams:(NSDictionary *)params;

@end