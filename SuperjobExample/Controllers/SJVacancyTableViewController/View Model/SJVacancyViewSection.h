//
// Created by Vladimir Burdukov on 23.08.15.
// Copyright (c) 2015 Superjob.ru. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SJVacancyViewItem;

typedef BOOL (^SJVacancyViewSectionFilterItemsBlock)(id obj);

@interface SJVacancyViewSection : NSObject

- (NSUInteger)itemsCount;
- (SJVacancyViewItem *)itemAtIndex:(NSUInteger)index;
- (void)removeItemsPassingTest:(SJVacancyViewSectionFilterItemsBlock)predicate;

- (void)addItems:(NSArray *)items;
@end