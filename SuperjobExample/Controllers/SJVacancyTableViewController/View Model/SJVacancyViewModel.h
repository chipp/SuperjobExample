//
// Created by Vladimir Burdukov on 23.08.15.
// Copyright (c) 2015 Superjob.ru. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SJVacancyViewSection;
@class SJVacancyViewItem;
@class SJVacancyModel;

@protocol SJVacancyViewModelDelegate <NSObject>

- (void)reloadData;
- (void)showError:(NSString *)error;
- (void)showVacancy:(SJVacancyModel *)vacancy;

@end

@interface SJVacancyViewModel : NSObject

@property (nonatomic, weak) id <SJVacancyViewModelDelegate> delegate;
@property (nonatomic, copy, readonly) NSString *title;

- (void)loadData;
- (void)loadMoreData;

- (NSUInteger)sectionsCount;
- (SJVacancyViewSection *)sectionAtIndex:(NSInteger)index;
- (SJVacancyViewItem *)itemAtIndexPath:(NSIndexPath *)indexPath;
- (void)selectItemAtIndexPath:(NSIndexPath *)path;

@end