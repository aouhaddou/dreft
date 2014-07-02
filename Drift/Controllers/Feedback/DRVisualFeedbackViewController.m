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
#import "DRDriftView.h"
#import "DRDistanceFormatter.h"

const BOOL debug = NO;

@interface DRVisualFeedbackViewController ()

@property (nonatomic, strong) UILabel *driftLabel;
@property (nonatomic, strong) UILabel *directionLabel;
@property (nonatomic, strong) NSMutableArray *locationHistory;
@property (nonatomic, strong) DRPathView *pathView;
@property (nonatomic, strong) DRDistanceFormatter *distanceFormatter;
@property (nonatomic, strong) DRDriftView *driftView;

@property (nonatomic, strong) DRDistanceFormatter *distanceFormatterSound;
@property (nonatomic, strong) NSTimer *feedbackTimer;
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;
@property (nonatomic, strong) NSString *lastFeedbackString;

@end

@implementation DRVisualFeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
    UILabel *driftLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSideMargin, self.navigationBar.bottom, self.view.width-2*kSideMargin, 66)];
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

    CGFloat iphone4width = 210;
    CGFloat viewMargin = valueForScreen((self.view.width-iphone4width)/2, kSideMargin);
    DRDriftView *driftView = [[DRDriftView alloc] initWithFrame:CGRectMake(viewMargin, directionLabel.bottom+kSideMargin, valueForScreen(iphone4width, self.view.width-2*viewMargin), valueForScreen(iphone4width, self.view.width-2*viewMargin))];
    driftView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.driftView = driftView;
    [self.view insertSubview:driftView atIndex:0];

    if (debug) {
        self.driftView.hidden = YES;
        DRPathView *path = [[DRPathView alloc] initWithFrame:CGRectMake(kSideMargin, directionLabel.bottom+kSideMargin, self.view.width-2*kSideMargin, self.view.height - directionLabel.bottom- self.bottomButton.height - 3*kSideMargin)];
        path.backgroundColor = self.view.backgroundColor;
        path.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        path.marksEndOfPrimaryLine = YES;
        path.secondaryLocations = self.processor.locations;
        path.primaryLineColor = [DRTheme base4];
        path.secondaryLineColor = [DRTheme transparentBase4];
        path.lineWidth = 6;
        path.verticalAlignment = NSArrayRelativePointsVerticalAlignmentCenter;
        path.horizontalAlignment = NSArrayRelativePointsHorizontalAlignmentCenter;
        self.pathView = path;
        [self.view addSubview:path];
    }

    [self updateTitle];
}

-(DRDistanceFormatter *)distanceFormatter {
    if (_distanceFormatter == nil) {
        DRDistanceFormatter *distance = [[DRDistanceFormatter alloc] init];
        distance.abbreviate = YES;
        _distanceFormatter = distance;
    }
    return _distanceFormatter;
}

-(void)updateTitle {
    if (self.feedbackType == DRFeedbackTypeQualitative) {
        self.navigationBar.topItem.title = [NSLocalizedString(@"You are in", nil) uppercaseString];
    } else {
        self.navigationBar.topItem.title = [NSLocalizedString(@"You are", nil) uppercaseString];
    }
}

-(void)setFeedbackType:(DRFeedbackType)feedbackType {
    [super setFeedbackType:feedbackType];
    [self updateTitle];
}

-(void)dataProcessor:(DRDataProcessor *)processor didCalculateDrift:(DRDrift *)result {
    [super dataProcessor:processor didCalculateDrift:result];
    self.driftLabel.text = self.feedbackType == DRFeedbackTypeQualitative ? [self qualitativeVisualStringForDrift:result] : [self quantitativeVisualStringForDrift:result];

    NSString *directionString = nil;
    if (result.direction == DRDriftDirectionRight) {
        directionString = [NSLocalizedString(@"right", nil) uppercaseString];
    } else if (result.direction == DRDriftDirectionLeft) {
        directionString = [NSLocalizedString(@"left", nil) uppercaseString];
    }

    self.directionLabel.text = directionString;
    self.driftView.drift = result;

    if (debug) {
        [self addLocationToHistory:result.location];
        self.pathView.primaryLocations = self.locationHistory;
    }

    self.lastFeedbackString = self.feedbackType == DRFeedbackTypeQualitative ? [self qualitativeAudioStringForDrift:result] : [self quantitativeAudioStringForDrift:result];
}

-(void)dataProcessor:(DRDataProcessor *)processor didFailWithError:(NSError *)error {
    [super dataProcessor:processor didFailWithError:error];
    self.driftLabel.text = NSLocalizedString(@"–", nil);
    [self speakString:NSLocalizedString(@"No location information.", nil)];
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

#pragma mark audio

-(void)start {
    [super start];
    [self speakString:NSLocalizedString(@"Started run.", nil)];
    self.feedbackTimer = [NSTimer scheduledTimerWithTimeInterval:[[DRVariableManager sharedManager] audioFeedbackRate] target:self selector:@selector(feedbackTimerFired) userInfo:nil repeats:YES];
}

-(void)stopRun {
    [super stopRun];
    [self.feedbackTimer invalidate];
}

-(void)cancelRun {
    [super cancelRun];
    [self.feedbackTimer invalidate];
}

-(void)feedbackTimerFired {
    if (self.lastFeedbackString) {
        [self speakString:self.lastFeedbackString];
    } else {
        [self speakString:NSLocalizedString(@"No location information.", nil)];
    }
}

-(DRDistanceFormatter *)distanceFormatterSound {
    if (_distanceFormatterSound == nil) {
        DRDistanceFormatter *distance = [[DRDistanceFormatter alloc] init];
        distance.abbreviate = NO;
        distance.maximumFractionDigits = 0;
        _distanceFormatterSound = distance;
    }
    return _distanceFormatterSound;
}

-(void)speakString:(NSString *)string {
    if (self.synthesizer == nil) {
        self.synthesizer = [[AVSpeechSynthesizer alloc] init];
        self.synthesizer.delegate = self;
        [self configureAudioSession];
    }
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:string];
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
    utterance.rate = 0.13f;
    [self.synthesizer speakUtterance:utterance];
}

-(void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance {
    //
}

-(void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    //
}

- (void)configureAudioSession{
    NSError *error = NULL;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&error];
    if(error) {
        DLog(@"Error setting category of audio session: %@",error.description);
    }
    error = NULL;
    [[AVAudioSession sharedInstance] setActive:YES error: &error];
    if (error) {
        DLog(@"Error activating audio session: %@",error.description);
    }
}

#pragma mark feedback strings

-(NSString *)quantitativeVisualStringForDrift:(DRDrift *)drift {
    NSString *distance = [self.distanceFormatter stringFromDistance:drift.distance];
    return distance;
}

-(NSString *)qualitativeVisualStringForDrift:(DRDrift *)drift {
    if (drift.distance < [[DRVariableManager sharedManager] zone1Thresh]) {
        return NSLocalizedString(@"Zone 1", nil);
    } else if (drift.distance < [[DRVariableManager sharedManager] zone1Thresh]*2) {
        return NSLocalizedString(@"Zone 2", nil);
    } else {
        return NSLocalizedString(@"Zone 3", nil);
    }
}

-(NSString *)quantitativeAudioStringForDrift:(DRDrift *)drift {
    if (drift.distance >= [[DRVariableManager sharedManager] infoThresh]) {
        NSString *stringDistance = [self.distanceFormatterSound stringFromDistance:floor(drift.distance)];
        if (drift.direction == DRDriftDirectionRight || drift.direction == DRDriftDirectionLeft) {
            NSString *direction = drift.direction == DRDriftDirectionLeft ? NSLocalizedString(@"left", nil) : NSLocalizedString(@"right", nil);
            return [NSString stringWithFormat:NSLocalizedString(@"%@ %@.", nil),stringDistance, direction];
        } else {
            return [NSString stringWithFormat:NSLocalizedString(@"%@.", nil),stringDistance];
        }
    } else {
        return [NSString stringWithFormat:NSLocalizedString(@"On course.", nil)];
    }
}

-(NSString *)qualitativeAudioStringForDrift:(DRDrift *)drift {
    NSString *zoneString;
    if (drift.distance < [[DRVariableManager sharedManager] zone1Thresh]) {
        zoneString = NSLocalizedString(@"Zone 1", nil);
    } else if (drift.distance < [[DRVariableManager sharedManager] zone1Thresh]*2) {
        zoneString = NSLocalizedString(@"Zone 2", nil);
    } else {
        zoneString = NSLocalizedString(@"Zone 3", nil);
    }

    if (drift.distance >= [[DRVariableManager sharedManager] infoThresh] && (drift.direction == DRDriftDirectionRight || drift.direction == DRDriftDirectionLeft)) {
        NSString *direction = drift.direction == DRDriftDirectionLeft ? NSLocalizedString(@"left", nil) : NSLocalizedString(@"right", nil);
        return [NSString stringWithFormat:NSLocalizedString(@"%@, %@.", nil),zoneString,direction];
    } else {
        return [NSString stringWithFormat:NSLocalizedString(@"%@.", nil),zoneString];
    }
}

@end
