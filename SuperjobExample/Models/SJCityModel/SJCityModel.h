//
// Created by Vladimir Burdukov on 23.08.15.
// Copyright (c) 2015 Superjob.ru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/MTLModel.h>
#import <Mantle/MTLJSONAdapter.h>

@interface SJCityModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *key;
@property (nonatomic, copy) NSString *title;

@end