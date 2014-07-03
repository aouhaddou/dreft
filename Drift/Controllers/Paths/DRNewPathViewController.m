//
//  DRNewPathViewController.m
//  Drift
//
//  Created by Christoph Albert on 3/6/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRNewPathViewController.h"
#import "BRBackArrow.h"
#import "BRCheckmarkIcon.h"
#import "DRGPSParser.h"
#import "DRModel.h"
#import "DRCheckpointAnnotation.h"
#import "SIAlertView.h"

@interface DRPathCheckpointAnnotation : NSObject <MKAnnotation>
@end

@implementation DRPathCheckpointAnnotation
@synthesize coordinate = _coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;

-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    if (self) {
        _coordinate = coordinate;
    }
    return self;
}

@end

@interface DRNewPathViewController () {
    BOOL _longPressPinDropped;
    BOOL _shouldZoomToUserLocation;
}

@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, strong) CLPlacemark *placemark;

@property (nonatomic, strong) UIButton *infoButton;

@end

@implementation DRNewPathViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [DRTheme base3];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.navigationBar.showsShadow = YES;
    self.navigationBar.topItem.title = [NSLocalizedString(@"New Course", nil) uppercaseString];
    self.navigationBar.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[BRBackArrow imageWithColor:[DRTheme base4]] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationBar.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[BRCheckmarkIcon imageWithColor:[DRTheme base4]] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemPressed:)];
    self.navigationBar.topItem.rightBarButtonItem.enabled = NO;

    self.textField.placeholder = [NSLocalizedString(@"Enter Coordinates", nil) uppercaseString];
    self.textField.inputAccessoryView = self.keyboardToolBar;

    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.mapView addGestureRecognizer:longPressGesture];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapViewTapped:)];
    [self.mapView addGestureRecognizer:tapGesture];

    _shouldZoomToUserLocation = YES;

    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [infoButton addTarget:self action:@selector(infoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:infoButton];
    infoButton.tintColor = [DRTheme base2];
    self.infoButton = infoButton;
}

-(void)infoButtonTapped:(id)sender {
    [self.textField resignFirstResponder];
    SIAlertView *alert = [[SIAlertView alloc] initWithTitle:nil andMessage:NSLocalizedString(@"You can enter WGS84 coordinates as decimal latitude, longitude. Here is an example:\n\n59.361195, 18.059378\n\n", nil)];
    [alert addButtonWithTitle:NSLocalizedString(@"Got it!", nil) type:SIAlertViewButtonTypeDefault handler:nil];
    [alert show];
}

-(void)mapViewTapped:(UITapGestureRecognizer *)tap {
    _shouldZoomToUserLocation = NO;
    [self.textField resignFirstResponder];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.infoButton.centerY = self.textField.centerY;
    self.infoButton.x = self.view.width-self.infoButton.width-20;
    self.mapView.height = self.toolBar.top-self.mapView.top;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    int curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];

    [UIView beginAnimations:@"foo" context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    self.mapView.height = self.view.height-self.mapView.top-keyboardFrame.size.height;
    self.toolBar.alpha = 0;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    double duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    int curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];

    [UIView beginAnimations:@"foo" context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    self.mapView.height = self.toolBar.top-self.mapView.top;
    self.toolBar.alpha = 1;
    [UIView commitAnimations];
}

-(void)leftBarButtonItemPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarButtonItemPressed:(id)sender {
    if ([self.locations count] > 1) {
        NSManagedObjectContext *context = [NSManagedObjectContext MR_context];
        DRPath *path = [DRPath MR_createInContext:context];
        path.locations = self.locations;
        path.placemark = self.placemark;
        [context MR_saveToPersistentStoreAndWait];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reverseGeocodeLocation:(CLLocation *)location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        self.placemark = [placemarks firstObject];
    }];
}

-(IBAction)undoLastPoint:(id)sender {
    if ([self.locations count] > 0) {
        CLLocation *loc = [self.locations lastObject];
        [self removeLocationFromPath:loc];
        [self updateMapView];
    }
}

-(IBAction)closePath:(id)sender {
    if ([self.locations count] > 1) {
        CLLocation *first = [self.locations firstObject];
        CLLocation *last = [self.locations lastObject];
        CGFloat latDelta = fabs(first.coordinate.latitude-last.coordinate.latitude);
        CGFloat lonDelta = fabs(first.coordinate.longitude-last.coordinate.longitude);
        CGFloat delta = 0.000001;
        if (latDelta>delta && lonDelta>delta) {
            [self addLocationToPath:[[CLLocation alloc] initWithLatitude:first.coordinate.latitude longitude:first.coordinate.longitude]];
            [self updateMapView];
        }
    }
}

-(void)addLocationToPath:(CLLocation *)location {
    if (location != nil && CLLocationCoordinate2DIsValid(location.coordinate)) {
        if (self.locations == nil) {
            self.locations = [NSMutableArray array];
        }
        if ([self.locations count] == 0) {
            [self reverseGeocodeLocation:location];
        }
        [self.locations addObject:location];
        if ([self.locations count] > 1) {
            self.navigationBar.topItem.rightBarButtonItem.enabled = YES;
        }
    }
}

-(void)removeLocationFromPath:(CLLocation *)loc {
    [self.locations removeObject:loc];
    if ([self.locations count] == 0) {
        self.placemark = nil;
    }
}

#pragma mark text field delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSString *candidate = [[textField text] stringByReplacingCharactersInRange:range withString:string];
    return [DRGPSParser validateCharacter:string];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    CLLocation *loc = [DRGPSParser locationFromString:textField.text];
    [self addLocationToPath:loc];
    [self updateMapView];
    [self zoomToFitMapAnnotations:self.mapView];
    return YES;
}

#pragma mark map view

-(void)handleLongPressGesture:(UILongPressGestureRecognizer *)sender {
    _shouldZoomToUserLocation = NO;

    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.textField resignFirstResponder];
        _longPressPinDropped = NO;
    } else {
        if (_longPressPinDropped == NO) {
            CGPoint point = [sender locationInView:self.mapView];
            CLLocationCoordinate2D locCoord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
            // Then all you have to do is create the annotation and add it to the map
            CLLocation *loc = [[CLLocation alloc] initWithLatitude:locCoord.latitude longitude:locCoord.longitude];
            [self addLocationToPath:loc];
            [self updateMapView];
            _longPressPinDropped = YES;
        }
    }
}

-(void)updateMapView {
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];

    NSUInteger count = self.locations.count;
    CLLocationCoordinate2D path[count];
    for (NSInteger i = 0; i<count; i++) {
        CLLocation *loc = self.locations[i];
        path[i] = [loc coordinate];

        DRPathCheckpointAnnotation *checkpoint = [[DRPathCheckpointAnnotation alloc] initWithCoordinate:loc.coordinate];
        [self.mapView addAnnotation:checkpoint];
    }

    MKPolyline *pathLine = [MKPolyline polylineWithCoordinates:path count:count];
    [self.mapView addOverlay:pathLine];
}

-(void)zoomToFitMapAnnotations:(MKMapView*)mapView
{
    _shouldZoomToUserLocation = NO;

    if([mapView.annotations count] == 0) {
        return;
    }

    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;

    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;

    for(DRPathCheckpointAnnotation *annotation in mapView.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);

        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }

    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [DRTheme confirmColor];
    polylineView.lineWidth = 4.0;

    return polylineView;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if (annotation != mapView.userLocation) {
        static NSString *defaultPinID = @"com.christophalbert.checkpointAnnotation";
        MKAnnotationView *pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if (pinView == nil )
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];

        pinView.canShowCallout = NO;
        pinView.enabled = NO;
        pinView.image = [DRCheckpointAnnotation imageWithColor:[DRTheme confirmColor]];
        return pinView;
    } else {
        return nil;
    }
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MKAnnotationView *userLocation = [mapView viewForAnnotation:mapView.userLocation];
    userLocation.enabled = NO;
    userLocation.hidden = YES;

    CLLocation *lastLoc = [self.locations lastObject];
    if (lastLoc) {
        for (MKAnnotationView *view in views) {
            if (view == userLocation) {
                continue;
            }

            MKMapPoint point =  MKMapPointForCoordinate(view.annotation.coordinate);
            if (!MKMapRectContainsPoint(self.mapView.visibleMapRect, point)) {
                continue;
            }

            if (view.annotation.coordinate.latitude == lastLoc.coordinate.latitude && view.annotation.coordinate.longitude == lastLoc.coordinate.longitude) {
                //Animate
                CGFloat scale = 4;
                view.transform = CGAffineTransformMakeScale(scale, scale);
                view.alpha = 0;
                [UIView animateWithDuration:0.4 animations:^{
                    view.transform = CGAffineTransformIdentity;
                    view.alpha = 1;
                }];
            }
        }
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation      {
    if (_shouldZoomToUserLocation) {
        MKCoordinateRegion region;
        region.center.latitude = userLocation.location.coordinate.latitude;
        region.center.longitude = userLocation.location.coordinate.longitude;
        region.span.latitudeDelta = 0.05;
        region.span.longitudeDelta = 0.05;
        region = [mapView regionThatFits:region];
        [mapView setRegion:region animated:NO];
    }
}

@end