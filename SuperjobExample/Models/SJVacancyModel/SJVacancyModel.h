//
// Created by Vladimir Burdukov on 23.08.15.
// Copyright (c) 2015 Superjob.ru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@class SJCityModel;

@interface SJVacancyModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *key;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) SJCityModel *city;
@property (nonatomic, assign) NSUInteger salary;

@end