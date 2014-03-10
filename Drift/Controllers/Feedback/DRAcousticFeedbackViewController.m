//
//  DRAcousticFeedbackViewController.m
//  Drift
//
//  Created by Christoph Albert on 3/5/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRAcousticFeedbackViewController.h"
#import "DRDistanceFormatter.h"
#import "DRCountdownCircle.h"
#import "DRSpeaker.h"

@interface DRAcousticFeedbackViewController ()

@property (nonatomic, strong) DRDistanceFormatter *distanceFormatterSound;
@property (nonatomic, strong) NSTimer *feedbackTimer;
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;
@property (nonatomic, strong) NSString *lastFeedbackString;
@property (nonatomic, strong) DRCountdownCircle *circle;
@property (nonatomic, strong) BRDrawing *speaker;

@end

@implementation DRAcousticFeedbackViewController

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
    [self speakString:NSLocalizedString(@"Started Run", nil)];
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
    self.lastFeedbackString = self.feedbackType == DRFeedbackTypeQualitative ? [self qualitativeStringForDistance:result.distance] : [self quantitativeStringForDistance:result.distance];
}

-(void)dataProcessor:(DRDataProcessor *)processor didFailWithError:(NSError *)error {
    [super dataProcessor:processor didFailWithError:error];
    [self speakString:NSLocalizedString(@"Could not process location", nil)];
}

#pragma mark feedback string

-(NSString *)quantitativeStringForDistance:(CLLocationDistance)distance {
    NSString *stringDistance = [self.distanceFormatterSound stringFromDistance:floor(distance)];

    return [NSString stringWithFormat:NSLocalizedString(@"You are off by %@", nil),stringDistance];
}

-(NSString *)qualitativeStringForDistance:(CLLocationDistance)distance {
    if (distance < [[DRVariableManager sharedManager] zone1Thresh]) {
        return NSLocalizedString(@"You are on course", nil);
    } else if (distance < [[DRVariableManager sharedManager] zone2Thresh]) {
        return NSLocalizedString(@"You are drifting a little", nil);
    } else {
        return NSLocalizedString(@"You are pretty far off", nil);
    }
}

@end
