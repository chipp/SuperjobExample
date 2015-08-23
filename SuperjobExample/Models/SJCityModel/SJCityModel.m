//
// Created by Vladimir Burdukov on 23.08.15.
// Copyright (c) 2015 Superjob.ru. All rights reserved.
//

#import "SJCityModel.h"

@implementation SJCityModel

#pragma mark - <MTLJSONAdapter>

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
            @"key" : @"id",
            @"title" : @"title"
    };
}

@end