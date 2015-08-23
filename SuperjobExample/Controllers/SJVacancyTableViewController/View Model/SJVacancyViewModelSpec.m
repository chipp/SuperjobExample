#import "Specs.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/Mantle.h>
#import "SJVacancyViewModel.h"
#import "SJVacancyFacade.h"
#import "SJVacancyViewSection.h"
#import "SJVacancyViewItem.h"
#import "SJVacancyModel.h"

@interface SJVacancyViewModel (Spec)

@property (nonatomic, strong) SJVacancyFacade *vacancyFacade;

@end

SpecBegin(SJVacancyViewModel)
    describe(@"SJVacancyViewModel", ^{
        __block SJVacancyViewModel *viewModel;
        __block SJVacancyFacade *vacancyFacade;
        __block id <SJVacancyViewModelDelegate> delegate;

        beforeEach(^{
            vacancyFacade = mock([SJVacancyFacade class]);
            delegate = mockProtocol(@protocol(SJVacancyViewModelDelegate));
            viewModel = [SJVacancyViewModel new];
            viewModel.vacancyFacade = vacancyFacade;
            viewModel.delegate = delegate;
        });

        afterEach(^{
            vacancyFacade = nil;
            delegate = nil;
            viewModel = nil;
        });

        context(@"on load", ^{
            it(@"should add placeholder and reload table", ^{
                [viewModel loadData];
                expect(viewModel.sectionsCount).to.equal(1);
                SJVacancyViewSection *section = [viewModel sectionAtIndex:0];
                expect(section.itemsCount).to.equal(1);
                SJVacancyViewItem *item = [section itemAtIndex:0];
                expect(item.type).to.equal(SJVacancyViewItemTypePlaceholder);
                [verify(delegate) reloadData];
            });

            it(@"should request facade for vacancies", ^{
                [viewModel loadData];
                [verify(vacancyFacade) vacanciesForPage:0];
            });

            context(@"when request finished successfully", ^{
                __block RACTuple *response;
                beforeAll(^{
                    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"vacancies.0" ofType:@"json"]];
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions) kNilOptions error:nil];
                    NSArray *models = [MTLJSONAdapter modelsOfClass:[SJVacancyModel class] fromJSONArray:json[@"objects"] error:nil];
                    response = RACTuplePack(models, json[@"total"], json[@"more"]);
                });

                beforeEach(^{
                    RACSignal *signal = [RACSignal return:response];
                    [given([vacancyFacade vacanciesForPage:0]) willReturn:signal];
                });

                it(@"should parse models and reload table", ^{
                    [viewModel loadData];
                    [verifyCount(delegate, times(2)) reloadData];
                    expect(viewModel.sectionsCount).to.equal(1);
                    SJVacancyViewItem *item = [viewModel itemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    expect(item.type).to.equal(SJVacancyViewItemTypeVacancy);
                    expect(item.title).to.equal(@"Администратор процессинговой системы Way4");
                    expect(item.subtitle).to.equal(@"120 000 \u20BD, Москва");
                });

                context(@"when need to load more data", ^{
                    it(@"should request for next page", ^{
                        [viewModel loadData];
                        [viewModel loadMoreData];
                        [verify(vacancyFacade) vacanciesForPage:1];
                    });
                });
            });

            context(@"when request failed", ^{
                beforeEach(^{
                    NSError *error = [NSError errorWithDomain:SJVacancyFacadeErrorDomain code:SJVacancyFacadeErrorCodeNoInternetConnection userInfo:nil];
                    RACSignal *signal = [RACSignal error:error];
                    [given([vacancyFacade vacanciesForPage:0]) willReturn:signal];
                });

                it(@"should show error", ^{
                    [viewModel loadData];
                    [verify(delegate) showError:@"Проверьте соединение с Интернетом"];
                });
            });
        });
    });
SpecEnd
