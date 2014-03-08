//
//  DROCADXMLParser.m
//  Drift
//
//  Created by Christoph Albert on 3/8/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DROCADXMLParser.h"
#import "TBXML+NSDictionary.h"
#import "DRModel.h"

@interface DRXMLCoursePoint : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, assign) NSInteger index;

@end

@implementation DRXMLCoursePoint

//

@end

@implementation DROCADXMLParser

+(void)parseXMLData:(NSData *)data {
    NSError *error;
    NSDictionary *dict = [TBXML dictionaryWithXMLData:data error:&error];

    if (error) {
        NSLog(@"%@ %@", [error localizedDescription], [error userInfo]);
    } else {
//        DLog(@"%@",dict.description);
        //Extract all control points
        NSMutableDictionary *controlPoints = [NSMutableDictionary dictionary];

        NSArray *controlArray = [[dict objectForKey:@"CourseData"] objectForKey:@"Control"];
        for (NSDictionary *controlDict in controlArray) {
            NSDictionary *posDict = [controlDict objectForKey:@"MapPosition"];
            NSString *code = [controlDict objectForKey:@"ControlCode"];

            [controlPoints setObject:posDict forKey:code];
        }

        NSArray *startControlArray = [[dict objectForKey:@"CourseData"] objectForKey:@"StartPoint"];
        for (NSDictionary *controlDict in startControlArray) {
            NSDictionary *posDict = [controlDict objectForKey:@"MapPosition"];
            NSString *code = [controlDict objectForKey:@"StartPointCode"];

            [controlPoints setObject:posDict forKey:code];
        }

        //Extract courses
        NSArray *coursesArray = [[dict objectForKey:@"CourseData"] objectForKey:@"Course"];
        for (NSDictionary *courseDict in coursesArray) {
            NSMutableArray *coursePoints = [NSMutableArray array];
            DRXMLCoursePoint *p1 = [DRXMLCoursePoint new];
            p1.code = [[courseDict objectForKey:@"CourseVariation"] objectForKey:@"StartPointCode"];
            p1.index = 0;
            [coursePoints addObject:p1];

            NSArray *courseControl = [[courseDict objectForKey:@"CourseVariation"] objectForKey:@"CourseControl"];
            for (NSDictionary *controlDict in courseControl) {
                DRXMLCoursePoint *p2 = [DRXMLCoursePoint new];
                p2.code = [controlDict objectForKey:@"ControlCode"];
                p2.index = [[controlDict objectForKey:@"Sequence"] integerValue];
                [coursePoints addObject:p2];
            }

            //Create path from sorted points
            if ([coursePoints count] > 1 && NO) {
                NSArray *sortedPoints = [coursePoints sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]]];

                NSMutableArray *locations = [NSMutableArray array];
                for (DRXMLCoursePoint *point in sortedPoints) {
                    CLLocation *loc = [[CLLocation alloc] initWithLatitude:0 longitude:0];
                    [locations addObject:loc];
                }

                NSManagedObjectContext *context = [NSManagedObjectContext MR_context];
                DRPath *path = [DRPath MR_createInContext:context];
                path.locations = locations;
                [context MR_saveToPersistentStoreAndWait];
            }
        }
    }
}

@end
