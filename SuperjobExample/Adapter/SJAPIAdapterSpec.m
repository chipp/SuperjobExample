#import "Specs.h"
#import "SJAPIAdapter.h"
#import "API.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SJAPIAdapter (Spec)
@property (nonatomic, strong) API *api;
@end

SpecBegin(SJAPIAdapter)
    describe(@"SJAPIAdapter", ^{
        __block SJAPIAdapter *apiAdapter;
        __block API *api;

        beforeEach(^{
            api = mock([API class]);

            apiAdapter = [SJAPIAdapter new];
            apiAdapter.api = api;
        });

        afterEach(^{
            api = nil;
            apiAdapter = nil;
        });

        context(@"when requests for vacancies", ^{
            it(@"should perform get request", ^{
                [apiAdapter vacanciesWithParams:nil];
                [verify(api) getPath:@"vacancies" withParams:anything()];
            });

            it(@"should pass params to api as is", ^{
                [apiAdapter vacanciesWithParams:@{@"param" : @YES}];
                [verify(api) getPath:@"vacancies" withParams:@{@"param" : @YES}];
            });

            context(@"when request finished successfully", ^{
                beforeEach(^{
                    NSHTTPURLResponse *response = mock([NSHTTPURLResponse class]);
                    [given(response.statusCode) willReturnInt:200];
                    NSDictionary *result = @{@"objects": @[@1, @2, @3], @"total": @10, @"more": @YES};
                    [given([api getPath:anything() withParams:anything()]) willReturn:[RACSignal return:RACTuplePack(response, result)]];
                });

                it(@"should finish with valid result", ^{
                    BOOL success = NO;
                    NSError *error = nil;
                    RACTuple *result = [[apiAdapter vacanciesWithParams:nil] asynchronousFirstOrDefault:nil success:&success error:&error];
                });
            });
        });
    });
SpecEnd
