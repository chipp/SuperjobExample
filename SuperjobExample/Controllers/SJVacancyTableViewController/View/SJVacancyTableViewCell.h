//
//  SJVacancyTableViewCell.h
//  SuperjobExample
//
//  Created by Vladimir Burdukov on 23.08.15.
//  Copyright (c) 2015 Superjob.ru. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SJVacancyViewItem;

@interface SJVacancyTableViewCell : UITableViewCell

- (void)configureWithItem:(SJVacancyViewItem *)item;
- (void)updatePreferredWidthWithTableWidth:(CGFloat)width;

@end
