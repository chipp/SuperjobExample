//
// Created by Vladimir Burdukov on 13.07.15.
// Copyright (c) 2015 Superjob.ru. All rights reserved.
//

#import <Objection/Objection.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SJVacancyFacade.h"
#import "SJAPIAdapter.h"

@interface SJVacancyFacade ()
@property (nonatomic, strong) SJAPIAdapter *apiAdapter;
@end

@implementation SJVacancyFacade
objection_register_singleton(SJVacancyFacade)
objection_requires(@"apiAdapter")

@end