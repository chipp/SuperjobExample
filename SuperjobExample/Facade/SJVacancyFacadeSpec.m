#import <ReactiveCocoa/ReactiveCocoa.h>
#import "Specs.h"
#import "SJVacancyFacade.h"
#import "SJAPIAdapter.h"
#import "SJVacancyModel.h"

@interface SJVacancyFacade (Spec)
@property (nonatomic, strong) SJAPIAdapter *apiAdapter;
@end

SpecBegin(SJVacancyFacade)
    describe(@"SJVacancyFacade", ^{
        __block SJVacancyFacade *facade;
        __block SJAPIAdapter *apiAdapter;

        beforeEach(^{
            apiAdapter = mock([SJAPIAdapter class]);
            facade = [SJVacancyFacade new];
            facade.apiAdapter = apiAdapter;
        });

        afterEach(^{
            apiAdapter = nil;
            facade = nil;
        });

        context(@"dependencies", ^{
            beforeEach(^{
                [given([apiAdapter vacanciesWithParams:anything()]) willReturn:[RACSignal empty]];
            });

            it(@"should request api adapter for vacancies", ^{
                [[facade vacanciesForPage:0] asynchronouslyWaitUntilCompleted:nil];
                [verify(apiAdapter) vacanciesWithParams:anything()];
            });

            it(@"should pass page as param", ^{
                [[facade vacanciesForPage:4] asynchronouslyWaitUntilCompleted:nil];
                [verify(apiAdapter) vacanciesWithParams:@{
                        @"page" : @4
                }];
            });
        });

        context(@"when request finished successfully", ^{
            beforeEach(^{
                NSData *data = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"vacancies.0" ofType:@"json"]];
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions) kNilOptions error:nil];
                RACSignal *signal = [RACSignal return:RACTuplePack(json[@"objects"], json[@"total"], json[@"more"])];
                [given([apiAdapter vacanciesWithParams:anything()]) willReturn:signal];
            });

            it(@"should parse response and provide models", ^{
                BOOL success = NO;
                NSError *error = nil;
                RACTuple *response = [[facade vacanciesForPage:0] asynchronousFirstOrDefault:nil success:&success error:&error];
                expect(response).to.beKindOf([RACTuple class]);
                RACTupleUnpack(NSArray *objects, NSNumber *total, NSNumber *hasMoreItems) = response;
                expect(objects).to.haveCountOf(10);

                for (id obj in objects) {
                    expect(obj).to.beKindOf([SJVacancyModel class]);
                }

                expect(total).to.equal(20);
                expect(hasMoreItems.boolValue).to.beTruthy();
            });
        });

        context(@"when request failed", ^{
            beforeEach(^{
                NSError *error = [NSError errorWithDomain:SJAPIAdapterErrorDomain code:SJAPIAdapterErrorCodeNoInternetConnection userInfo:nil];
                RACSignal *signal = [RACSignal error:error];
                [given([apiAdapter vacanciesWithParams:anything()]) willReturn:signal];
            });

            it(@"should failed too", ^{
                BOOL success = YES;
                NSError *error = nil;
                RACTuple *result = [[facade vacanciesForPage:0] asynchronousFirstOrDefault:nil success:&success error:&error];
                expect(result).to.beNil();
                expect(success).to.beFalsy();
                expect(error).notTo.beNil();
                expect(error.domain).to.equal(SJVacancyFacadeErrorDomain);
                expect(error.code).to.equal(SJVacancyFacadeErrorCodeNoInternetConnection);
            });
        });
    });
SpecEnd
