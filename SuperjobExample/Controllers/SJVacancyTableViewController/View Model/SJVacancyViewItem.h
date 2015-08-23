//
// Created by Vladimir Burdukov on 23.08.15.
// Copyright (c) 2015 Superjob.ru. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SJVacancyModel;

typedef NS_ENUM(NSUInteger, SJVacancyViewItemType) {
    SJVacancyViewItemTypeVacancy,
    SJVacancyViewItemTypePlaceholder,
};

@interface SJVacancyViewItem : NSObject

@property (nonatomic, assign, readonly) SJVacancyViewItemType type;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *subtitle;
@property (nonatomic, strong, readonly) SJVacancyModel *vacancy;

+ (instancetype)itemFromVacancy:(SJVacancyModel *)vacancy;
+ (instancetype)placeholder;

@end