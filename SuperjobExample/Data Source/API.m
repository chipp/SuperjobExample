//
// Created by Vladimir Burdukov on 10/06/15.
// Copyright (c) 2015 SuperJob. All rights reserved.
//

#import "API.h"
#import <AFNetworking/AFNetworking.h>
#import <Objection/Objection.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SJSettingsStorage.h"

#import "NSError+SJError.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"

@interface API ()
@property (nonatomic, strong) AFHTTPSessionManager *httpManager;
@property (nonatomic, strong) SJSettingsStorage *settings;
@end

@implementation API
objection_register_singleton(API)
objection_requires(@"settings")

- (void)awakeFromObjection {
    [super awakeFromObjection];

    @weakify(self)
    [[RACObserve(self, settings.baseURL) ignore:nil] subscribeNext:^(NSURL *url) {
        @strongify(self)
        self.httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }];
}

#pragma mark - Path generators

+ (NSString *)pathWithComponents:(NSArray *)components {
    NSArray *componentsToJoin = [components arrayByAddingObject:@""];
    return [componentsToJoin componentsJoinedByString:@"/"];
}

#pragma mark - Requests

- (RACSignal *)getPath:(NSString *)path withParams:(NSDictionary *)params {
    return [self p_requestPath:path method:APIRequestMethodGET params:params];
}

- (RACSignal *)deletePath:(NSString *)path withParams:(NSDictionary *)params {
    return [self p_requestPath:path method:APIRequestMethodDELETE params:params];
}

- (RACSignal *)postPath:(NSString *)path withParams:(NSDictionary *)params {

    return [self p_requestPath:path method:APIRequestMethodPOST params:params];
}

- (RACSignal *)putPath:(NSString *)path withParams:(NSDictionary *)params {
    return [self p_requestPath:path method:APIRequestMethodPUT params:params];
}

#pragma clang diagnostic pop

#pragma mark - Private methods

- (RACSignal *)p_requestPath:(NSString *)path method:(APIRequestMethod)method params:(NSDictionary *)params {
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        @strongify(self)
        NSString *methodString;

        switch (method) {
            case APIRequestMethodNone:
                break;
            case APIRequestMethodGET:
                methodString = @"GET";
                break;
            case APIRequestMethodPOST:
                methodString = @"POST";
                break;
            case APIRequestMethodPUT:
                methodString = @"PUT";
                break;
            case APIRequestMethodDELETE:
                methodString = @"DELETE";
                break;
        }

        NSError *error = nil;
        NSString *fullPath = [[NSURL URLWithString:path relativeToURL:self.httpManager.baseURL] absoluteString];
        NSMutableURLRequest *request = [[self.httpManager requestSerializer] requestWithMethod:methodString URLString:fullPath parameters:params error:&error];

        if (error) {
            [subscriber sendError:error];
            return nil;
        }

        request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        [request setTimeoutInterval:15.f];
        [request setHTTPShouldHandleCookies:NO];

        NSURLSessionDataTask *dataTask = [self.httpManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *responseError) {
            if (responseError) {
                NSError *resultError = [NSError errorByExtendingError:responseError urlResponse:(NSHTTPURLResponse *) response responseObject:responseObject];
                [subscriber sendError:resultError];
            } else {
                [subscriber sendNext:RACTuplePack(responseObject, response)];
                [subscriber sendCompleted];
            }
        }];
        [dataTask resume];

        return [RACDisposable disposableWithBlock:^{
            [dataTask cancel];
        }];
    }];
}

@end
