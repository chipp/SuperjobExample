//
//  SJVacancyTableViewCell.m
//  SuperjobExample
//
//  Created by Vladimir Burdukov on 23.08.15.
//  Copyright (c) 2015 Superjob.ru. All rights reserved.
//

#import "SJVacancyTableViewCell.h"
#import "SJVacancyViewItem.h"

@interface SJVacancyTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;

@end

@implementation SJVacancyTableViewCell

- (void)configureWithItem:(SJVacancyViewItem *)item {
    self.titleLabel.text = item.title;
    self.subtitleLabel.text = item.subtitle;
}

- (void)updatePreferredWidthWithTableWidth:(CGFloat)width {
    CGFloat preferredWidth = width - 30.f;
    self.titleLabel.preferredMaxLayoutWidth = preferredWidth;
    self.subtitleLabel.preferredMaxLayoutWidth = preferredWidth;
}

@end
