//
// Created by Vladimir Burdukov on 23.08.15.
// Copyright (c) 2015 Superjob.ru. All rights reserved.
//

#import "SJVacancyModel.h"
#import "SJCityModel.h"

@implementation SJVacancyModel

#pragma mark - <MTLJSONSerializing>

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
            @"key" : @"id",
            @"title" : @"profession",
            @"city" : @"town",
            @"salary" : @"payment_from"
    };
}

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"

+ (NSValueTransformer *)cityJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[SJCityModel class]];
}

#pragma clang diagnostic pop

@end