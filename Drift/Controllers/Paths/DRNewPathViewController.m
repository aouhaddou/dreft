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

@interface DRNewPathViewController ()

@property (nonatomic, strong) NSMutableArray *locations;

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
    self.navigationBar.topItem.title = [NSLocalizedString(@"Add Course", nil) uppercaseString];
    self.navigationBar.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[BRBackArrow imageWithColor:[DRTheme base4]] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    self.navigationBar.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[BRCheckmarkIcon imageWithColor:[DRTheme base4]] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemPressed:)];

    self.textField.placeholder = [NSLocalizedString(@"Enter Coordinate", nil) uppercaseString];

    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.mapView addGestureRecognizer:longPressGesture];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.textField becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardDidShow:(NSNotification*)notification {
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.mapView.height = self.view.height-self.mapView.top-keyboardFrame.size.height;
}

- (void)keyboardDidHide:(NSNotification*)notification {
    self.mapView.height = self.view.height-self.mapView.top;
}

-(void)leftBarButtonItemPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarButtonItemPressed:(id)sender {
    //
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)addLocationToPath:(CLLocation *)location {
    if (location != nil && CLLocationCoordinate2DIsValid(location.coordinate)) {
        if (self.locations == nil) {
            self.locations = [NSMutableArray array];
        }
        [self.locations addObject:location];
    }
}

#pragma mark map view

-(void)handleLongPressGesture:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        //
    }
    else
    {
        CGPoint point = [sender locationInView:self.mapView];
        CLLocationCoordinate2D locCoord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        // Then all you have to do is create the annotation and add it to the map
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:locCoord.latitude longitude:locCoord.longitude];
        [self addLocationToPath:loc];
        [self updateMapView];
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
    if([mapView.annotations count] == 0)
        return;

    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;

    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;

    for(DRPathCheckpointAnnotation *annotation in mapView.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);

        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }

    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides

    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [DRTheme confirmColor];
    polylineView.lineWidth = 4.0;

    return polylineView;
}

@end
