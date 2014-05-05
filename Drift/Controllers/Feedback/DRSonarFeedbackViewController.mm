//
//  DRMusicFeebbackViewController.m
//  Drift
//
//  Created by Christoph Albert on 3/26/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRSonarFeedbackViewController.h"
#import "Novocaine.h"
#import "AudioFileReader.h"
#import "DRPathView.h"
#import "NSDate+Utilities.h"
#import "DRSonarView.h"

@interface DRSonarFeedbackViewController () {
    BOOL _animatingSonar;
}

@property (nonatomic, strong) Novocaine *audioManager;
@property (nonatomic, strong) AudioFileReader *fileReader;

@property (nonatomic, assign) CGFloat volume;
@property (nonatomic, assign) CGFloat pan;

@property (nonatomic, strong) DRPathView *pathView;
@property (nonatomic, strong) NSMutableArray *locationHistory;

@property (nonatomic, strong) DRSonarView *circle;

@end

@implementation DRSonarFeedbackViewController

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

    self.volume = 0;
    self.pan = 0.5;

    __weak DRSonarFeedbackViewController * wself = self;

    self.audioManager = [Novocaine audioManager];

    NSURL *inputFileURL = [[NSBundle mainBundle] URLForResource:@"Sonar1" withExtension:@"wav"];

    [self.audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
    {
        if (wself.volume > 0) {
            if (![wself.fileReader playing]) {
                wself.fileReader = nil;
                wself.fileReader = [[AudioFileReader alloc]
                                   initWithAudioFileURL:inputFileURL
                                   samplingRate:wself.audioManager.samplingRate
                                   numChannels:wself.audioManager.numOutputChannels];
                [wself.fileReader play];
            }

            [wself.fileReader retrieveFreshAudio:data numFrames:numFrames numChannels:numChannels];
            
            for (NSInteger i=0; i < numFrames; ++i)
            {
                for (NSInteger iChannel = 0; iChannel < numChannels; ++iChannel)
                {
                    NSInteger frameIndex = i*numChannels + iChannel;
                    if (iChannel == 0) {
                        //Left
                        CGFloat newMult = wself.volume*cos(wself.pan*M_PI/2);
                        data[frameIndex] = data[frameIndex] * newMult;
                    } else {
                        CGFloat newMult = wself.volume*sin(wself.pan*M_PI/2);
                        data[frameIndex] = data[frameIndex] * newMult;
                    }
                }
            }
        }
    }];

    [self.audioManager play];

    if (NO) { //Debug
        DRPathView *path = [[DRPathView alloc] initWithFrame:CGRectMake(kSideMargin, 150, self.view.width-2*kSideMargin, self.view.height - 150 - self.bottomButton.height - 3*kSideMargin)];
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
    } else {
        CGFloat width = 240;
        self.circle = [[DRSonarView alloc] initWithFrame:CGRectMake((self.view.width-width)/2, self.navigationBar.bottom + (self.bottomButton.top - self.navigationBar.bottom - 20 - width)/2, width, width)];
        self.circle.backgroundColor = self.view.backgroundColor;
        self.circle.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        self.circle.layer.cornerRadius = width/2;
        self.circle.layer.masksToBounds = YES;
        [self.view addSubview:self.circle];
    }
}

-(void)stopRun {
    [super stopRun];
    [self stopSonar];
}

-(void)cancelRun {
    [super cancelRun];
    [self stopSonar];
}

-(void)spinSonar {
    if (!_animatingSonar) {
        _animatingSonar = YES;

    }
    // this spin completes 360 degrees every 2 seconds
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear animations: ^{
        self.circle.transform = CGAffineTransformRotate(self.circle.transform, M_PI / 2);
    } completion: ^(BOOL finished) {
        if (finished) {
            if (_animatingSonar) {
                // if flag still set, keep spinning with constant speed
                [self spinSonar];
            }
        }
    }];
}

-(void)stopSonar {
    _animatingSonar = NO;
}

-(void)dealloc {
    [self.fileReader stop];
    [self.audioManager pause];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dataProcessor:(DRDataProcessor *)processor didCalculateDrift:(DRDrift *)result {
    if (!_animatingSonar) {
        [self spinSonar];
    }
    CGFloat volumeCurve = 2;  //1 = linear,
                                //>1 = more fine in close ranges, more dropoff in far ranges
                                //<1 = less fine in close ranges, controlled dropoff in far ranges
    self.volume = MAX(0.2, 1 - pow(fabs(result.distance/([[DRVariableManager sharedManager] zone1Thresh]*2)), volumeCurve));

    CGFloat panPos = 0.5; // 0 = left, 0.5 middle, 1 = right

    //Pan with distance
    if ((result.direction == DRDriftDirectionLeft || result.direction == DRDriftDirectionRight)) {

        // relative pan amount from 0 to 1
        CGFloat rel = fabs(result.distance/[[DRVariableManager sharedManager] zone1Thresh]);

        panPos = result.direction == DRDriftDirectionRight ? 0.5-rel/2 : 0.5+rel/2;
    } else {
        panPos = 0.5;
    }

    self.pan = panPos;

    //Pan with angle
//    if (result.angle != DRDriftNoAngle) {
//        if (result.direction == DRDriftDirectionLeft) {
//            if (result.angle >= 0) {
//                panPos = 1 - result.angle/180;
//            } else {
//                panPos = 1 + result.angle/180;
//            }
//        } else if (result.direction == DRDriftDirectionRight) {
//            if (result.angle >= 0) {
//                panPos = result.angle/180;
//            } else {
//                panPos = - result.angle/180;
//            }
//        }
//    }
//    //Soften transition from left to right
//    CGFloat panMult = MAX(0, MIN(1, result.distance/14));
//    panPos = panMult*panPos + (1-panMult)*0.5;

    panPos = MAX(0.1, MIN(0.9, panPos));
    self.pan = panPos;

    [self addLocationToHistory:result.location];
    self.pathView.primaryLocations = self.locationHistory;
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

-(void)dataProcessor:(DRDataProcessor *)processor didFailWithError:(NSError *)error {
    self.volume = 0;
    [self stopSonar];
}

@end
