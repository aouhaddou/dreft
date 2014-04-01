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
#import "SIAlertView.h"

@implementation DRGPXParser

+(void)parseContentsOfURL:(NSURL *)url {
    if (url == nil) {
        return;
    }
    
    GPXRoot *root = [GPXParser parseGPXAtURL:url];

    if ([root.routes count] == 0) {
        SIAlertView *alert = [[SIAlertView alloc] initWithTitle:nil andMessage:NSLocalizedString(@"No routes found in GPX file.", nil)];
        [alert addButtonWithTitle:NSLocalizedString(@"Okay :(", nil) type:SIAlertViewButtonTypeDefault handler:nil];
        [alert show];
    } else if ([root.routes count] > 0) {
        NSString *message;
        if ([root.routes count] == 1) {
            message = NSLocalizedString(@"Do you want to import one route?", nil);
        } else {
            message = [NSString stringWithFormat:NSLocalizedString(@"Do you want to import %li routes?", nil),[root.routes count]];
        }

        SIAlertView *alert = [[SIAlertView alloc] initWithTitle:nil andMessage:message];
        [alert addButtonWithTitle:NSLocalizedString(@"Cancel", nil) type:SIAlertViewButtonTypeCancel handler:nil];
        [alert addButtonWithTitle:NSLocalizedString(@"Import", nil) type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
            [DRGPXParser importAndSaveRoutes:root.routes];
        }];
        [alert show];
    }
}

+(void)importAndSaveRoutes:(NSArray *)routes {
    for (GPXRoute *route in routes) {
        NSMutableArray *locations = [[NSMutableArray alloc] init];
        for (GPXRoutePoint *point in route.routepoints) {
            CLLocation *loc = [[CLLocation alloc] initWithLatitude:point.latitude longitude:point.longitude];
            if (loc != nil && CLLocationCoordinate2DIsValid(loc.coordinate)) {
                [locations addObject:loc];
            }
        }

        NSManagedObjectContext *context = [NSManagedObjectContext MR_context];
        DRPath *path = [DRPath MR_createInContext:context];
        path.locations = locations;
        [context MR_saveToPersistentStoreAndWait];
    }
}

@end
