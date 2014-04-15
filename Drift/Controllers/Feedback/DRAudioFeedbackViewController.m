//
//  DRAcousticFeedbackViewController.m
//  Drift
//
//  Created by Christoph Albert on 3/5/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRAudioFeedbackViewController.h"
#import "DRDistanceFormatter.h"
#import "DRCountdownCircle.h"
#import "DRSpeaker.h"

@interface DRAudioFeedbackViewController ()

@property (nonatomic, strong) DRDistanceFormatter *distanceFormatterSound;
@property (nonatomic, strong) NSTimer *feedbackTimer;
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;
@property (nonatomic, strong) NSString *lastFeedbackString;
@property (nonatomic, strong) DRCountdownCircle *circle;
@property (nonatomic, strong) BRDrawing *speaker;

@end

@implementation DRAudioFeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CGFloat width = 130;
    self.circle = [[DRCountdownCircle alloc] initWithFrame:CGRectMake((self.view.width-width)/2, self.navigationBar.bottom + (self.bottomButton.top - self.navigationBar.bottom - 20 - width)/2, width, width)];
    self.circle.backgroundColor = self.view.backgroundColor;
    self.circle.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:self.circle];

    self.speaker = [DRSpeaker viewWithColor:[DRTheme transparentBase4]];
    self.speaker.centerX = self.circle.centerX-3;
    self.speaker.centerY = self.circle.centerY;
    self.speaker.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:self.speaker];
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
    self.speaker.color = [DRTheme base4];
}

-(void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    self.speaker.color = [DRTheme transparentBase4];
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

-(void)start {
    [super start];
    [self speakString:NSLocalizedString(@"Started run.", nil)];
    [self.circle start];
    self.feedbackTimer = [NSTimer scheduledTimerWithTimeInterval:[[DRVariableManager sharedManager] baseRateForAcousticFeedback] target:self selector:@selector(feedbackTimerFired) userInfo:nil repeats:YES];
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
    [self.circle start];
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

-(void)dataProcessor:(DRDataProcessor *)processor didCalculateDrift:(DRDrift *)result {
    [super dataProcessor:processor didCalculateDrift:result];
    self.lastFeedbackString = self.feedbackType == DRFeedbackTypeQualitative ? [self qualitativeStringForDrift:result] : [self quantitativeStringForDrift:result];
}

-(void)dataProcessor:(DRDataProcessor *)processor didFailWithError:(NSError *)error {
    [super dataProcessor:processor didFailWithError:error];
    [self speakString:NSLocalizedString(@"No location information.", nil)];
}

CGFloat const angleThresh = 55;

#pragma mark feedback string

-(NSString *)quantitativeStringForDrift:(DRDrift *)drift {
    NSString *stringDistance = [self.distanceFormatterSound stringFromDistance:floor(drift.distance)];
    if (drift.direction == DRDriftDirectionRight || drift.direction == DRDriftDirectionLeft) {
        NSString *direction = drift.direction == DRDriftDirectionLeft ? NSLocalizedString(@"left", nil) : NSLocalizedString(@"right", nil);
        if (drift.angle != DRDriftNoAngle && drift.angle > angleThresh) {
            return [NSString stringWithFormat:NSLocalizedString(@"You are %@ to the %@, drifting away fast.", nil),stringDistance, direction];
        } else if (drift.angle != DRDriftNoAngle && drift.angle < -angleThresh) {
            return [NSString stringWithFormat:NSLocalizedString(@"You are %@ to the %@, getting closer fast.", nil),stringDistance, direction];
        } else {
            return [NSString stringWithFormat:NSLocalizedString(@"You are %@ to the %@.", nil),stringDistance, direction];
        }
    } else {
        return [NSString stringWithFormat:NSLocalizedString(@"You are off by %@.", nil),stringDistance];
    }
}

-(NSString *)qualitativeStringForDrift:(DRDrift *)drift {
    NSString *zoneString;
    if (drift.distance < [[DRVariableManager sharedManager] zone1Thresh]) {
        zoneString = NSLocalizedString(@"zone 1", nil);
    } else if (drift.distance < [[DRVariableManager sharedManager] zone2Thresh]) {
        zoneString = NSLocalizedString(@"zone 2", nil);
    } else {
        zoneString = NSLocalizedString(@"zone 3", nil);
    }
    if (drift.direction == DRDriftDirectionRight || drift.direction == DRDriftDirectionLeft) {
        NSString *direction = drift.direction == DRDriftDirectionLeft ? NSLocalizedString(@"left", nil) : NSLocalizedString(@"right", nil);
        if (drift.angle != DRDriftNoAngle && drift.angle > angleThresh) {
            return [NSString stringWithFormat:NSLocalizedString(@"You are on the %@ in %@, drifting away fast.", nil),direction,zoneString];
        } else if (drift.angle != DRDriftNoAngle && drift.angle < -angleThresh) {
            return [NSString stringWithFormat:NSLocalizedString(@"You are on the %@ in %@, getting closer fast.", nil),direction,zoneString];
        } else {
            return [NSString stringWithFormat:NSLocalizedString(@"You are on the %@ in %@.", nil),direction,zoneString];
        }
    } else {
        return [NSString stringWithFormat:NSLocalizedString(@"You are in %@.", nil),zoneString];
    }
}

@end
