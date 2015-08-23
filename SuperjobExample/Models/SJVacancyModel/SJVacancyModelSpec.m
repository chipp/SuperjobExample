#import "Specs.h"
#import "SJVacancyModel.h"
#import "SJCityModel.h"

SpecBegin(SJVacancyModel)
    describe(@"SJVacancyModel", ^{
        __block NSDictionary *json;
        __block SJVacancyModel *model;

        beforeEach(^{
            NSData *data = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"vacancy" ofType:@"json"]];
            json = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions) kNilOptions error:nil];
            NSError *error = nil;
            model = [MTLJSONAdapter modelOfClass:[SJVacancyModel class] fromJSONDictionary:json error:&error];
            expect(error).to.beNil();
        });

        afterEach(^{
            model = nil;
        });

        it(@"should parse key", ^{
            expect(model.key).to.equal(@28037638);
        });

        it(@"should parse title", ^{
            expect(model.title).to.equal(@"Специалист отдела практики и трудоустройства студентов");
        });

        it(@"should parse city", ^{
            expect(model.city).to.equal([SJCityModel modelWithDictionary:@{
                    @"key" : @4,
                    @"title" : @"Москва"
            } error:nil]);
        });

        it(@"should parse payment from", ^{
            expect(model.salary).to.equal(130000);
        });
    });
SpecEnd
