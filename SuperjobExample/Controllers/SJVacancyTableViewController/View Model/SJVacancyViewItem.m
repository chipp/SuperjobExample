//
// Created by Vladimir Burdukov on 23.08.15.
// Copyright (c) 2015 Superjob.ru. All rights reserved.
//

#import "SJVacancyViewItem.h"
#import "SJVacancyModel.h"
#import "SJCityModel.h"

@interface SJVacancyViewItem ()

@property (nonatomic, assign, readwrite) SJVacancyViewItemType type;
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSString *subtitle;
@property (nonatomic, strong, readwrite) SJVacancyModel *vacancy;

@end

@implementation SJVacancyViewItem

+ (instancetype)placeholder {
    SJVacancyViewItem *item = [SJVacancyViewItem new];
    item.type = SJVacancyViewItemTypePlaceholder;
    return item;
}

+ (instancetype)itemFromVacancy:(SJVacancyModel *)vacancy {
    SJVacancyViewItem *item = [SJVacancyViewItem new];
    [item configureWithVacancy:vacancy];
    return item;
}

- (void)configureWithVacancy:(SJVacancyModel *)vacancy {
    self.type = SJVacancyViewItemTypeVacancy;
    self.title = vacancy.title;

    NSMutableArray *components = @[].mutableCopy;

    if (vacancy.salary > 0) {
        NSString *salary = [[SJVacancyViewItem currencyFormatter] stringFromNumber:@(vacancy.salary)];
        [components addObject:salary];
    }

    if (vacancy.city) {
        [components addObject:vacancy.city.title];
    }

    self.subtitle = [components componentsJoinedByString:@", "];
    self.vacancy = vacancy;
}

+ (NSNumberFormatter *)currencyFormatter {
    static NSNumberFormatter *instance;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = NSNumberFormatter.new;
        instance.numberStyle = NSNumberFormatterCurrencyStyle;
        instance.locale = [NSLocale localeWithLocaleIdentifier:@"ru_RU"];
        instance.currencyCode = @"rub";
        instance.maximumFractionDigits = 0;
    });

    return instance;
}

@end