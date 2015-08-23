//
//  SJVacancyPlaceholderTableViewCell.m
//  SuperjobExample
//
//  Created by Vladimir Burdukov on 23.08.15.
//  Copyright (c) 2015 Superjob.ru. All rights reserved.
//

#import "SJVacancyPlaceholderTableViewCell.h"

@interface SJVacancyPlaceholderTableViewCell ()
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation SJVacancyPlaceholderTableViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.activityIndicator startAnimating];
}

@end
