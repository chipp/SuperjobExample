//
//  SJVacancyTableViewController.m
//  SuperjobExample
//
//  Created by Vladimir Burdukov on 13.07.15.
//  Copyright (c) 2015 Superjob.ru. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Objection/Objection.h>
#import "SJVacancyTableViewController.h"
#import "SJVacancyViewModel.h"
#import "SJVacancyViewSection.h"
#import "SJVacancyTableViewCell.h"
#import "SJVacancyViewItem.h"

@interface SJVacancyTableViewController () <SJVacancyViewModelDelegate>
@property (nonatomic, strong) SJVacancyViewModel *viewModel;
@end

@implementation SJVacancyTableViewController
objection_requires(@"viewModel")

- (void)awakeFromNib {
    [super awakeFromNib];
    JSObjectionInjector *injector = [JSObjection createInjector];
    [JSObjection setDefaultInjector:injector];

    [[JSObjection defaultInjector] injectDependencies:self];
    self.viewModel.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    RAC(self, title) = RACObserve(self, viewModel.title);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel loadData];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.sectionsCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel sectionAtIndex:section].itemsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SJVacancyViewItem *item = [self.viewModel itemAtIndexPath:indexPath];
    NSString *identifier = [self reuseIdentifierForType:item.type];
    SJVacancyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];

    if ([cell respondsToSelector:@selector(configureWithItem:)]) {
        [cell configureWithItem:item];
    }
    if ([cell respondsToSelector:@selector(updatePreferredWidthWithTableWidth:)]) {
        [cell updatePreferredWidthWithTableWidth:CGRectGetWidth(self.tableView.frame)];
    }

    return cell;
}

- (NSString *)reuseIdentifierForType:(SJVacancyViewItemType)type {
    switch (type) {
        case SJVacancyViewItemTypeVacancy:
            return @"SJVacancyTableViewCell";
        case SJVacancyViewItemTypePlaceholder:
            return @"SJVacancyPlaceholderTableViewCell";
    }
    return nil;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    SJVacancyViewItem *item = [self.viewModel itemAtIndexPath:indexPath];
    switch (item.type) {
        case SJVacancyViewItemTypeVacancy:
            break;
        case SJVacancyViewItemTypePlaceholder:
            [self.viewModel loadMoreData];
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SJVacancyViewItem *item = [self.viewModel itemAtIndexPath:indexPath];
    switch (item.type) {
        case SJVacancyViewItemTypeVacancy: {
            static SJVacancyTableViewCell *cell;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                cell = [tableView dequeueReusableCellWithIdentifier:[self reuseIdentifierForType:item.type]];
            });
            [cell prepareForReuse];
            [cell configureWithItem:item];
            [cell updatePreferredWidthWithTableWidth:CGRectGetWidth(tableView.frame)];
            CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            return size.height + 1.f;
        }
        case SJVacancyViewItemTypePlaceholder:
            return 85.f;
    }

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85.f;
}

#pragma mark - <SJVacancyViewModelDelegate>

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)showError:(NSString *)error {

}


@end
