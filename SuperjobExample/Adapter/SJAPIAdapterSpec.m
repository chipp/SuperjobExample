#import "Specs.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SJAPIAdapter.h"
#import "API.h"
#import "SJSettingsStorage.h"

@interface SJAPIAdapter (Spec)
@property (nonatomic, strong) API *api;
@property (nonatomic, strong) SJSettingsStorage *settings;
@end

SpecBegin(SJAPIAdapter)
    describe(@"SJAPIAdapter", ^{
        __block SJAPIAdapter *apiAdapter;
        __block API *api;
        __block SJSettingsStorage *settings;

        beforeEach(^{
            api = mock([API class]);
            settings = mock([SJSettingsStorage class]);
            [given([settings appKey]) willReturn:@"supertestkey"];

            apiAdapter = [SJAPIAdapter new];
            apiAdapter.api = api;
            apiAdapter.settings = settings;
        });

        afterEach(^{
            api = nil;
            apiAdapter = nil;
        });

        context(@"when requests for vacancies", ^{
            it(@"should perform get request", ^{
                [apiAdapter vacanciesWithParams:nil];
                [verify(api) getPath:@"supertestkey/vacancies/" withParams:anything()];
            });

            it(@"should pass params to api as is", ^{
                [apiAdapter vacanciesWithParams:@{@"param" : @YES}];
                [verify(api) getPath:@"supertestkey/vacancies/" withParams:@{@"param" : @YES}];
            });

            context(@"when request finished successfully", ^{
                beforeEach(^{
                    NSHTTPURLResponse *response = mock([NSHTTPURLResponse class]);
                    [given(response.statusCode) willReturnInt:200];
                    NSDictionary *result = @{@"objects": @[@1, @2, @3], @"total": @10, @"more": @YES};
                    [given([api getPath:anything() withParams:anything()]) willReturn:[RACSignal return:RACTuplePack(result, response)]];
                });

                it(@"should finish with valid result", ^{
                    BOOL success = NO;
                    NSError *error = nil;
                    RACTuple *result = [[apiAdapter vacanciesWithParams:nil] asynchronousFirstOrDefault:nil success:&success error:&error];
                    expect(result).to.beKindOf([RACTuple class]);
                    expect(success).to.beTruthy();
                    expect(error).to.beNil();
                    RACTupleUnpack(NSArray *objects, NSNumber *total, NSNumber *hasMoreItems) = result;
                    expect(objects).to.beKindOf([NSArray class]);
                    expect(objects).to.haveCountOf(3);
                    expect(total).to.equal(10);
                    expect(hasMoreItems.boolValue).to.beTruthy();
                });
            });

            context(@"when request failed", ^{
                beforeEach(^{
                    NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorNotConnectedToInternet userInfo:nil];
                    [given([api getPath:anything() withParams:anything()]) willReturn:[RACSignal error:error]];
                });

                it(@"should failed too", ^{
                    BOOL success = YES;
                    NSError *error = nil;
                    RACTuple *result = [[apiAdapter vacanciesWithParams:nil] asynchronousFirstOrDefault:nil success:&success error:&error];
                    expect(result).to.beNil();
                    expect(success).to.beFalsy();
                    expect(error).notTo.beNil();
                    expect(error.domain).to.equal(SJAPIAdapterErrorDomain);
                    expect(error.code).to.equal(SJAPIAdapterErrorCodeNoInternetConnection);
                });
            });
        });
    });
SpecEnd
