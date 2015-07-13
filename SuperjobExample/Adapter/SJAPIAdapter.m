//
// Created by Vladimir Burdukov on 13.07.15.
// Copyright (c) 2015 Superjob.ru. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Objection/Objection.h>
#import "SJAPIAdapter.h"
#import "API.h"
#import "SJSettingsStorage.h"

@interface SJAPIAdapter ()
@property (nonatomic, strong) API *api;
@property (nonatomic, strong) SJSettingsStorage *settings;
@end

@implementation SJAPIAdapter
objection_register_singleton(SJAPIAdapter)
objection_requires(@"settings", @"api", @"credentials")

@end