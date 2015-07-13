//
// Created by Vladimir Burdukov on 30/06/15.
// Copyright (c) 2015 Superjob. All rights reserved.
//

#import <Objection/Objection.h>
#import "SJSettingsStorage.h"

#ifdef API_URL
static NSString *baseURLString = API_URL;
#else
static NSString *baseURLString = @"https://api.superjob.ru/2.0/";
#endif

@interface SJSettingsStorage ()

@property (nonatomic, copy, readwrite) NSString *appVersion;
@property (nonatomic, copy, readwrite) NSString *appBuild;

@end

@implementation SJSettingsStorage
objection_register_singleton(SJSettingsStorage)

- (void)awakeFromObjection {
    [super awakeFromObjection];

    self.baseURL = [NSURL URLWithString:baseURLString];
    self.appVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    self.appBuild = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
}

@end