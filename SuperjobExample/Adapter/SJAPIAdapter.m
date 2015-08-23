//
// Created by Vladimir Burdukov on 13.07.15.
// Copyright (c) 2015 Superjob.ru. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Objection/Objection.h>
#import "SJAPIAdapter.h"
#import "API.h"
#import "SJSettingsStorage.h"
#import "NSError+SJError.h"

NSString *const SJAPIAdapterErrorDomain = @"ru.superjob.example.APIAdapter";

@interface SJAPIAdapter ()
@property (nonatomic, strong) API *api;
@property (nonatomic, strong) SJSettingsStorage *settings;
@end

@implementation SJAPIAdapter
objection_register_singleton(SJAPIAdapter)

objection_requires(@"settings", @"api", @"credentials")

- (RACSignal *)vacanciesWithParams:(NSDictionary *)params {
    return [[[[self.api getPath:@"vacancies" withParams:params] reduceEach:^id(id result, id response) {
        return result;
    }] map:^id(NSDictionary *value) {
        return [SJAPIAdapter p_parseListResponse:value];
    }] catch:^RACSignal *(NSError *error) {
        return [SJAPIAdapter p_handleError:error];
    }];
}

#pragma mark - Private

+ (RACTuple *)p_parseListResponse:(NSDictionary *)response {
    NSArray *objects = response[@"objects"];
    NSNumber *total = response[@"total"];
    NSNumber *hasMoreItems = response[@"more"];
    return RACTuplePack(objects, total, hasMoreItems);
}

+ (RACSignal *)p_handleError:(NSError *)error {
    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        NSError *adapterError;
        switch (error.code) {
            case NSURLErrorNotConnectedToInternet:
                adapterError = [self p_noInternetConnectionError];
            default:
                break;
        }
        return [RACSignal error:adapterError];
    } else {
        return [RACSignal error:[self p_undefinedErrorWithUnderlyingError:error]];
    }
}

+ (NSError *)p_noInternetConnectionError {
    return [self p_localDomainErrorWithCode:SJAPIAdapterErrorCodeNoInternetConnection underlyingError:nil];
}

+ (NSError *)p_localDomainErrorWithCode:(SJAPIAdapterErrorCode)code underlyingError:(NSError *)error {
    return [NSError errorWithDomain:SJAPIAdapterErrorDomain code:code userInfo:nil underlyingError:error];
}

+ (NSError *)p_undefinedErrorWithUnderlyingError:(NSError *)error {
    return [self p_localDomainErrorWithCode:SJAPIAdapterErrorCodeUndefined underlyingError:error];
}

@end