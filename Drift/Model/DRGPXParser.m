//
//  DROCADXMLParser.m
//  Drift
//
//  Created by Christoph Albert on 3/8/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRGPXParser.h"
#import "TBXML+NSDictionary.h"
#import "DRModel.h"
#import "GPX.h"

@implementation DRGPXParser

+(void)parseContentsOfURL:(NSURL *)url {
    if (url == nil) {
        return;
    }
    
    GPXRoot *root = [GPXParser parseGPXAtURL:url];

    for (GPXRoute *route in root.routes) {
        NSMutableArray *locations = [[NSMutableArray alloc] init];
        for (GPXRoutePoint *point in route.routepoints) {
            CLLocation *loc = [[CLLocation alloc] initWithLatitude:point.latitude longitude:point.longitude];
            if (loc != nil && CLLocationCoordinate2DIsValid(loc.coordinate)) {
                [locations addObject:loc];
            }
        }
        if ([locations count] > 0) {
            NSManagedObjectContext *context = [NSManagedObjectContext MR_context];
            DRPath *path = [DRPath MR_createInContext:context];
            path.locations = locations;
            [context MR_saveToPersistentStoreAndWait];
        }
    }
}

@end
