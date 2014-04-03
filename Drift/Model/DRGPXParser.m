//
//  DROCADXMLParser.m
//  Drift
//
//  Created by Christoph Albert on 3/8/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRGPXParser.h"
#import "DRModel.h"
#import "GPX.h"
#import "SIAlertView.h"

@implementation DRGPXParser

+(void)parseContentsOfURL:(NSURL *)url {
    if (url == nil) {
        return;
    }
    
    GPXRoot *root = [GPXParser parseGPXAtURL:url];

    NSInteger count = [root.routes count] + [root.tracks count];
    
    if (count == 0) {
        SIAlertView *alert = [[SIAlertView alloc] initWithTitle:nil andMessage:NSLocalizedString(@"No courses found in GPX file.", nil)];
        [alert addButtonWithTitle:NSLocalizedString(@"Okay :(", nil) type:SIAlertViewButtonTypeDefault handler:nil];
        [alert show];
    } else if (count > 0) {
        NSString *message;
        if (count == 1) {
            message = NSLocalizedString(@"Do you want to import one course?", nil);
        } else {
            message = [NSString stringWithFormat:NSLocalizedString(@"Do you want to import %li courses?", nil),count];
        }

        SIAlertView *alert = [[SIAlertView alloc] initWithTitle:nil andMessage:message];
        [alert addButtonWithTitle:NSLocalizedString(@"Cancel", nil) type:SIAlertViewButtonTypeCancel handler:nil];
        [alert addButtonWithTitle:NSLocalizedString(@"Import", nil) type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
            [DRGPXParser importAndSaveRoutes:root.routes];
            [DRGPXParser importAndSaveTracks:root.tracks];
        }];
        [alert show];
    }
}

+(void)importAndSaveRoutes:(NSArray *)routes {
    if (routes == nil || [routes count] == 0) {
        return;
    }

    for (GPXRoute *route in routes) {
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
            [self reverseGeocodePath:path];
            [context MR_saveToPersistentStoreAndWait];
        }
    }
}

+(void)importAndSaveTracks:(NSArray *)tracks {
    if (tracks == nil || [tracks count] == 0) {
        return;
    }

    for (GPXTrack *track in tracks) {
        NSMutableArray *locations = [[NSMutableArray alloc] init];
        for (GPXTrackSegment *segment in track.tracksegments) {
            for (GPXTrackPoint *point in segment.trackpoints) {
                CLLocation *loc = [[CLLocation alloc] initWithLatitude:point.latitude longitude:point.longitude];
                if (loc != nil && CLLocationCoordinate2DIsValid(loc.coordinate)) {
                    [locations addObject:loc];
                }
            }
        }
        if ([locations count] > 0) {
            NSManagedObjectContext *context = [NSManagedObjectContext MR_context];
            DRPath *path = [DRPath MR_createInContext:context];
            path.locations = locations;
            [self reverseGeocodePath:path];
            [context MR_saveToPersistentStoreAndWait];
        }
    }
}

+(void)reverseGeocodePath:(DRPath *)path {
    if ([path.locations count] > 0) {
        NSString *pathID = path.uniqueID;
        CLLocation *first = [path.locations firstObject];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:first completionHandler:^(NSArray *placemarks, NSError *error) {
            DRPath *path = [DRPath objectWithID:pathID];
            if (path) {
                path.placemark = [placemarks firstObject];
            }
        }];
    }
}

@end
