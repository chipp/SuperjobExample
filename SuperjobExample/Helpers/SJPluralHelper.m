//
// Created by Vladimir Burdukov on 23.08.15.
// Copyright (c) 2015 Superjob.ru. All rights reserved.
//

#import "SJPluralHelper.h"

@implementation SJPluralHelper

+ (NSString *)pluralForm:(NSInteger)count withOne:(NSString *)one two:(NSString *)two many:(NSString *)many {
    NSString *result = nil;

    count %= 100;
    if ((count > 10) && (count < 20)) count = 10;
    int c = count % 10;
    if (c == 1) {
        result = one;
    } else if (c > 1 && c <= 4) {
        result = two;
    }

    if (!result) {
        result = many;
    }

    return result;
}

@end