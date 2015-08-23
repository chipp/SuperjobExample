#import "Specs.h"
#import "SJCityModel.h"

SpecBegin(SJCityModel)
    describe(@"SJCityModel", ^{
        NSDictionary *json = @{
                @"id" : @4,
                @"title" : @"Москва"
        };
        __block SJCityModel *model;

        beforeEach(^{
            NSError *error = nil;
            model = [MTLJSONAdapter modelOfClass:[SJCityModel class] fromJSONDictionary:json error:&error];
            expect(error).to.beNil();
        });

        afterEach(^{
            model = nil;
        });

        it(@"should parse key", ^{
            expect(model.key).to.equal(@4);
        });

        it(@"should parse title", ^{
            expect(model.title).to.equal(@"Москва");
        });
    });
SpecEnd
