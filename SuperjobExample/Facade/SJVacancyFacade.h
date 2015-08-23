//
// Created by Vladimir Burdukov on 13.07.15.
// Copyright (c) 2015 Superjob.ru. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

extern NSString *const SJVacancyFacadeErrorDomain;

typedef NS_ENUM(NSUInteger, SJVacancyFacadeErrorCode) {
    SJVacancyFacadeErrorCodeNone,
    SJVacancyFacadeErrorCodeUndefined,
    SJVacancyFacadeErrorCodeNoInternetConnection,
};

@interface SJVacancyFacade : NSObject

- (RACSignal *)vacanciesForPage:(NSUInteger)page;

@end