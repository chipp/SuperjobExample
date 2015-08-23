//
// Created by Vladimir Burdukov on 23.08.15.
// Copyright (c) 2015 Superjob.ru. All rights reserved.
//

#import "SJVacancyViewSection.h"
#import "SJVacancyViewItem.h"

@interface SJVacancyViewSection ()
@property (nonatomic, strong) NSArray *items;
@end

@implementation SJVacancyViewSection

- (NSUInteger)itemsCount {
    return self.items.count;
}

- (SJVacancyViewItem *)itemAtIndex:(NSUInteger)index {
    if (NSLocationInRange(index, NSMakeRange(0, self.itemsCount))) {
        return self.items[index];
    }
    return nil;
}

- (void)removeItemsPassingTest:(SJVacancyViewSectionFilterItemsBlock)predicate {
    NSAssert(predicate, @"predicate can't be nil");

    self.items = [self.items filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return !predicate(evaluatedObject);
    }]];
}

- (void)addItems:(NSArray *)items {
    if (!self.items) {
        self.items = @[];
    }
    self.items = [self.items arrayByAddingObjectsFromArray:items];
}

@end