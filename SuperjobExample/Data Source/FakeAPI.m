//
// Created by Vladimir Burdukov on 23.08.15.
// Copyright (c) 2015 Superjob.ru. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Objection/Objection.h>
#import "FakeAPI.h"
#import "API.h"

@implementation FakeAPI

- (RACSignal *)getPath:(__unused NSString *)path withParams:(NSDictionary *)params {
    return [[[RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        NSNumber *page = params[@"page"];
        NSString *fileName = [NSString stringWithFormat:@"vacancies.%@", page];
        NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"json"]];
        NSError *error = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions) kNilOptions error:&error];

        if (error) {
            [subscriber sendError:error];
        } else {
            [subscriber sendNext:RACTuplePack(result, nil)];
            [subscriber sendCompleted];
        }
        return nil;
    }] delay:1] subscribeOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground]];
}

@end