//
// Created by Vladimir Burdukov on 23.08.15.
// Copyright (c) 2015 Superjob.ru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJPluralHelper : NSObject

+ (NSString *)pluralForm:(NSInteger)count withOne:(NSString *)one two:(NSString *)two many:(NSString *)many;

@end