//
// Created by Vladimir Burdukov on 23.08.15.
// Copyright (c) 2015 Superjob.ru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Objection/Objection.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SJVacancyViewModel.h"
#import "SJVacancyViewSection.h"
#import "SJVacancyViewItem.h"
#import "SJVacancyFacade.h"
#import "SJVacancyModel.h"
#import "SJPluralHelper.h"

@interface SJVacancyViewSection (Private)
@property (nonatomic, strong) NSArray *items;
@end

@interface SJVacancyViewModel ()

@property (nonatomic, strong) SJVacancyViewSection *section;
@property (nonatomic, assign) BOOL loading;
@property (nonatomic, strong) SJVacancyFacade *vacancyFacade;
@property (nonatomic, assign) NSUInteger page;

@property (nonatomic, copy, readwrite) NSString *title;
@end

@implementation SJVacancyViewModel
objection_requires(@"vacancyFacade")

- (void)loadData {
    if (self.loading) {
        return;
    }

    NSArray *items = [self p_parseObjects:nil placeholder:YES];
    self.section = [SJVacancyViewSection new];
    [self p_addItems:items toSection:self.section];
    id <SJVacancyViewModelDelegate> o = self.delegate;
    if ([o respondsToSelector:@selector(reloadData)]) {
        [o reloadData];
    }

    self.page = 0;
    [self p_loadPage:0];
}

- (void)loadMoreData {
    if (self.loading) {
        return;
    }

    self.page++;
    [self p_loadPage:self.page];
}

#pragma mark - Helpers

- (void)p_loadPage:(NSUInteger)page {
    self.loading = YES;
    @weakify(self)
    [[[[self.vacancyFacade vacanciesForPage:page] finally:^{
        @strongify(self)
        self.loading = NO;
    }] deliverOnMainThread] subscribeNext:^(RACTuple *response) {
        @strongify(self)
        RACTupleUnpack(NSArray *objects, NSNumber *total, NSNumber *hasMoreItems) = response;
        NSString *plural = [SJPluralHelper pluralForm:total.integerValue withOne:@"вакансия" two:@"вакансии" many:@"вакансий"];
        self.title = [NSString stringWithFormat:@"%@ %@", total, plural];
        NSArray *items = [self p_parseObjects:objects placeholder:hasMoreItems.boolValue];
        [self p_addItems:items toSection:self.section];
        id <SJVacancyViewModelDelegate> o = self.delegate;
        if ([o respondsToSelector:@selector(reloadData)]) {
            [o reloadData];
        }
    }          error:^(NSError *error) {
        @strongify(self)
        NSString *errorMessage = [SJVacancyViewModel p_errorMessageForError:error];
        id <SJVacancyViewModelDelegate> o = self.delegate;
        if ([o respondsToSelector:@selector(showError:)]) {
            [o showError:errorMessage];
        }
    }];
}

- (NSArray *)p_parseObjects:(NSArray *)objects placeholder:(BOOL)shouldAddPlaceholder {
    NSMutableArray *items = @[].mutableCopy;

    for (SJVacancyModel *vacancy in objects) {
        SJVacancyViewItem *item = [SJVacancyViewItem itemFromVacancy:vacancy];
        [items addObject:item];
    }

    if (shouldAddPlaceholder) {
        [items addObject:[SJVacancyViewItem placeholder]];
    }

    return items.copy;
}

- (void)p_addItems:(NSArray *)items toSection:(SJVacancyViewSection *)section {
    [section removeItemsPassingTest:^BOOL(SJVacancyViewItem *item) {
        return item.type == SJVacancyViewItemTypePlaceholder;
    }];
    [section addItems:items];
}

+ (NSString *)p_errorMessageForError:(NSError *)error {
    NSString *message;
    if ([error.domain isEqualToString:SJVacancyFacadeErrorDomain]) {
        switch ((SJVacancyFacadeErrorCode) error.code) {
            case SJVacancyFacadeErrorCodeUndefined:
                message = @"Что-то пошло не так";
                break;
            case SJVacancyFacadeErrorCodeNoInternetConnection:
                message = @"Проверьте соединение с Интернетом";
                break;
            case SJVacancyFacadeErrorCodeNone:
                break;
        }
    }
    return message;
}

#pragma mark - Data Source

- (NSUInteger)sectionsCount {
    return 1;
}

- (SJVacancyViewSection *)sectionAtIndex:(NSInteger)index {
    return (index == 0) ? self.section : nil;
}

- (SJVacancyViewItem *)itemAtIndexPath:(NSIndexPath *)indexPath {
    return [[self sectionAtIndex:(NSUInteger) indexPath.section] itemAtIndex:(NSUInteger) indexPath.row];
}

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath {
    SJVacancyModel *vacancy = [self itemAtIndexPath:indexPath].vacancy;
    id <SJVacancyViewModelDelegate> o = self.delegate;
    if ([o respondsToSelector:@selector(showVacancy:)]) {
        [o showVacancy:vacancy];
    }
}

@end