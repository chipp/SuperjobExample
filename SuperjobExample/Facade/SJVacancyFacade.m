//
// Created by Vladimir Burdukov on 13.07.15.
// Copyright (c) 2015 Superjob.ru. All rights reserved.
//

#import <Objection/Objection.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SJVacancyFacade.h"
#import "SJAPIAdapter.h"
#import "SJVacancyModel.h"
#import "NSError+SJError.h"

NSString *const SJVacancyFacadeErrorDomain = @"ru.superjob.example.VacancyFacade";

@interface SJVacancyFacade ()
@property (nonatomic, strong) SJAPIAdapter *apiAdapter;
@end

@implementation SJVacancyFacade
objection_register_singleton(SJVacancyFacade)
objection_requires(@"apiAdapter")

- (RACSignal *)vacanciesForPage:(NSUInteger)page {
    return [[[self.apiAdapter vacanciesWithParams:@{
            @"page" : @(page)
    }] flattenMap:^RACStream *(RACTuple *value) {
        return [SJVacancyFacade p_parseVacanciesResponse:value];
    }] catch:^RACSignal *(NSError *error) {
        return [SJVacancyFacade p_handeError:error];
    }];
}

#pragma mark - Private

+ (RACSignal *)p_parseVacanciesResponse:(RACTuple *)tuple {
    RACTupleUnpack(NSArray *objects, NSArray *total, NSArray *hasMoreItems) = tuple;
    NSError *error;
    NSArray *models = [MTLJSONAdapter modelsOfClass:[SJVacancyModel class] fromJSONArray:objects error:&error];

    if (error) {
        return [RACSignal error:error];
    } else {
        return [RACSignal return:RACTuplePack(models, total, hasMoreItems)];
    }
}

+ (RACSignal *)p_handeError:(NSError *)error {
    if ([error.domain isEqualToString:SJAPIAdapterErrorDomain]) {
        NSError *facadeError;
        switch ((SJAPIAdapterErrorCode) error.code) {
            case SJAPIAdapterErrorCodeUndefined:
                facadeError = [self p_undefinedErrorWithUnderlyingError:error];
                break;
            case SJAPIAdapterErrorCodeNoInternetConnection:
                facadeError = [self p_noInternetConnectionError];
                break;
            case SJAPIAdapterErrorCodeNone:
                break;
        }
        return [RACSignal error:facadeError];
    } else {
        return [RACSignal error:[self p_undefinedErrorWithUnderlyingError:error]];
    }
}

+ (NSError *)p_localDomainErrorWithCode:(SJVacancyFacadeErrorCode)code underlyingError:(NSError *)error {
    return [NSError errorWithDomain:SJVacancyFacadeErrorDomain code:code underlyingError:error];
}

+ (NSError *)p_undefinedErrorWithUnderlyingError:(NSError *)error {
    return [self p_localDomainErrorWithCode:SJVacancyFacadeErrorCodeUndefined underlyingError:error];
}

+ (NSError *)p_noInternetConnectionError {
    return [self p_localDomainErrorWithCode:SJVacancyFacadeErrorCodeNoInternetConnection underlyingError:nil];
}

@end