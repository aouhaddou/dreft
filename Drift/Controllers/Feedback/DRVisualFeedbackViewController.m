//
//  DRVisualFeedbackViewController.m
//  Drift
//
//  Created by Christoph Albert on 3/4/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRVisualFeedbackViewController.h"
#import "DRPathView.h"
#import "NSDate+Utilities.h"
#import "NSArray+DRExtensions.h"
#import "CLLocation+DRExtensions.h"
#import "DRDistanceFormatter.h"

const BOOL debug = NO;

@interface DRVisualFeedbackViewController ()

@property (nonatomic, strong) UILabel *driftLabel;
@property (nonatomic, strong) UILabel *directionLabel;
@property (nonatomic, strong) NSMutableArray *locationHistory;
@property (nonatomic, strong) DRPathView *pathView;
@property (nonatomic, strong) MKMapView *map;
@property (nonatomic, strong) DRDistanceFormatter *distanceFormatter;

@end

@implementation DRVisualFeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UILabel *driftLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSideMargin, self.navigationBar.bottom+kSideMargin, self.view.width-2*kSideMargin, 66)];
    driftLabel.textAlignment = NSTextAlignmentCenter;
    driftLabel.textColor = [DRTheme base4];
    driftLabel.backgroundColor = self.view.backgroundColor;
    driftLabel.adjustsFontSizeToFitWidth = YES;
    driftLabel.minimumScaleFactor = 0.25;
    driftLabel.font = [DRTheme semiboldFontWithSize:56.f];
    driftLabel.text = NSLocalizedString(@"–", nil);
    driftLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:driftLabel];
    self.driftLabel = driftLabel;

    UILabel *directionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSideMargin, self.driftLabel.bottom, self.view.width-2*kSideMargin, 44)];
    directionLabel.textAlignment = NSTextAlignmentCenter;
    directionLabel.textColor = [DRTheme base4];
    directionLabel.backgroundColor = self.view.backgroundColor;
    directionLabel.adjustsFontSizeToFitWidth = YES;
    directionLabel.minimumScaleFactor = 0.25;
    directionLabel.font = [DRTheme semiboldFontWithSize:36.f];
    directionLabel.text = nil;
    directionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:directionLabel];
    self.directionLabel = directionLabel;

    DRPathView *path = [[DRPathView alloc] initWithFrame:CGRectMake(kSideMargin, directionLabel.bottom+20, self.view.width-2*kSideMargin, self.view.height - directionLabel.bottom- self.bottomButton.height - 3*kSideMargin)];
    path.backgroundColor = self.view.backgroundColor;
    path.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:path];
    path.marksEndOfPrimaryLine = YES;
    path.secondaryLocations = self.processor.locations;
    path.primaryLineColor = [DRTheme base4];
    path.secondaryLineColor = [DRTheme transparentBase4];
    path.lineWidth = 6;
    path.verticalAlignment = NSArrayRelativePointsVerticalAlignmentCenter;
    path.horizontalAlignment = NSArrayRelativePointsHorizontalAlignmentCenter;
    self.pathView = path;

    if (debug) {
        MKMapView *map = [[MKMapView alloc] initWithFrame:self.pathView.frame];
        map.delegate = self;
        map.showsUserLocation = NO;
        [self.view addSubview:map];
        self.map = map;
    }
}

-(DRDistanceFormatter *)distanceFormatter {
    if (_distanceFormatter == nil) {
        DRDistanceFormatter *distance = [[DRDistanceFormatter alloc] init];
        distance.abbreviate = YES;
        _distanceFormatter = distance;
    }
    return _distanceFormatter;
}

-(void)dataProcessor:(DRDataProcessor *)processor didCalculateDrift:(DRDrift *)result {
    [super dataProcessor:processor didCalculateDrift:result];
    self.driftLabel.text = self.feedbackType == DRFeedbackTypeQualitative ? [self qualitativeStringForDrift:result] : [self quantitativeStringForDrift:result];

    if (result.direction == DRDriftDirectionRight) {
        self.directionLabel.text = [NSLocalizedString(@"right", nil) uppercaseString];
    } else if (result.direction == DRDriftDirectionLeft) {
        self.directionLabel.text = [NSLocalizedString(@"left", nil) uppercaseString];
    } else {
        self.directionLabel.text = nil;
    }

    [self addLocationToHistory:result.location];
    self.pathView.primaryLocations = self.locationHistory;

    if (debug) {
        [self drawPathsOnMapViewWithLocation:result.location leg:result.leg];
    }
}

-(void)dataProcessor:(DRDataProcessor *)processor didFailWithError:(NSError *)error {
    [super dataProcessor:processor didFailWithError:error];
    self.driftLabel.text = NSLocalizedString(@"–", nil);
}

-(void)addLocationToHistory:(CLLocation *)location {
    if (self.locationHistory == nil) {
        self.locationHistory = [[NSMutableArray alloc] init];
    }
    CLLocation *last = [self.locationHistory lastObject];

    if (last == nil || [last.timestamp isEarlierThanDate:location.timestamp]) {
        [self.locationHistory addObject:location];
    }
}

#pragma mark map for debugging

-(void)drawPathsOnMapViewWithLocation:(CLLocation *)location leg:(NSInteger)leg {
    NSUInteger count = self.processor.locations.count;
    CLLocationCoordinate2D path[count];
    for (NSInteger i = 0; i<count; i++) {
        path[i] = [self.processor.locations[i] coordinate];
    }
    MKPolyline *pathLine = [MKPolyline polylineWithCoordinates:path count:count];

    CLLocation *perpLocation = [location dr_perpendicularLocationWithLocation:self.processor.locations[leg] location:self.processor.locations[leg+1]];
    CLLocationCoordinate2D perpCoords[2];
    perpCoords[0] = location.coordinate;
    perpCoords[1] = perpLocation.coordinate;
    MKPolyline *perpLine = [MKPolyline polylineWithCoordinates:perpCoords count:2];

    [self.map removeOverlays:self.map.overlays];
    [self.map addOverlay:pathLine];
    [self.map addOverlay:perpLine];

    MKCoordinateRegion region = MKCoordinateRegionForMapRect([perpLine boundingMapRect]);
    region.span = MKCoordinateSpanMake(region.span.latitudeDelta+0.003, region.span.longitudeDelta+0.003);
    [self.map setRegion:region animated:YES];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [DRTheme confirmColor];
    polylineView.lineWidth = 4.0;

    return polylineView;
}

#pragma mark feedback string

-(NSString *)quantitativeStringForDrift:(DRDrift *)drift {
    NSString *distance = [self.distanceFormatter stringFromDistance:drift.distance];
    return distance;
}

-(NSString *)qualitativeStringForDrift:(DRDrift *)drift {
    if (drift.distance < [[DRVariableManager sharedManager] zone1Thresh]) {
        return NSLocalizedString(@"Zone 1", nil);
    } else if (drift.distance < [[DRVariableManager sharedManager] zone2Thresh]) {
        return NSLocalizedString(@"Zone 2", nil);
    } else {
        return NSLocalizedString(@"Zone 3", nil);
    }
}



@end
