//
// Created by Vladimir Burdukov on 30/06/15.
// Copyright (c) 2015 Superjob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJSettingsStorage : NSObject

@property (nonatomic, copy) NSURL *baseURL;
@property (nonatomic, copy, readonly) NSString *appKey;

@end