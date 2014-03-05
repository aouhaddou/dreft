//
//  DRAcousticFeedbackViewController.m
//  Drift
//
//  Created by Christoph Albert on 3/5/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRAcousticFeedbackViewController.h"
#import "DRDistanceFormatter.h"
@import AVFoundation;

@interface DRAcousticFeedbackViewController ()

@property (nonatomic, strong) DRDistanceFormatter *distanceFormatterSound;
@property (nonatomic, strong) NSTimer *feedbackTimer;
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;
@property (nonatomic, strong) NSString *lastFeedbackString;

@end

@implementation DRAcousticFeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)speakString:(NSString *)string {
    if (self.synthesizer == nil) {
        self.synthesizer = [[AVSpeechSynthesizer alloc] init];
        [self configureAudioSession];
    }
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:string];
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
    utterance.rate = 0.13f;
    [self.synthesizer speakUtterance:utterance];
}

- (void)configureAudioSession{
    NSError *error = NULL;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&error];
    if(error) {
        NSLog(@"Error setting category of audio session: %@",error.description);
    }
    error = NULL;
    [[AVAudioSession sharedInstance] setActive:YES error: &error];
    if (error) {
        NSLog(@"Error activating audio session: %@",error.description);
    }
}

-(void)start {
    [super start];
    [self speakString:NSLocalizedString(@"Started Run", nil)];
    self.feedbackTimer = [NSTimer scheduledTimerWithTimeInterval:[[[DRVariableManager sharedManager] baseRateForAcousticFeedback] floatValue] target:self selector:@selector(feedbackTimerFired) userInfo:nil repeats:YES];
}

-(void)stopButtonPressed:(id)sender {
    [super stopButtonPressed:sender];
    [self.feedbackTimer invalidate];
    [self speakString:NSLocalizedString(@"Finished Run", nil)];
}

-(void)feedbackTimerFired {
    if (self.lastFeedbackString) {
        [self speakString:self.lastFeedbackString];
    }
}

-(DRDistanceFormatter *)distanceFormatterSound {
    if (_distanceFormatterSound == nil) {
        DRDistanceFormatter *distance = [[DRDistanceFormatter alloc] init];
        distance.abbreviate = NO;
        _distanceFormatterSound = distance;
    }
    return _distanceFormatterSound;
}

-(void)dataProcessor:(DRDataProcessor *)processor didCalculateDrift:(DRDriftResult *)result {
    [super dataProcessor:processor didCalculateDrift:result];
    NSString *stringDistance = [self.distanceFormatterSound stringFromDistance:result.drift];

    self.lastFeedbackString = [NSString stringWithFormat:NSLocalizedString(@"You are off by %@", nil),stringDistance];
}

-(void)dataProcessor:(DRDataProcessor *)processor didFailWithError:(NSError *)error {
    [super dataProcessor:processor didFailWithError:error];
    [self speakString:NSLocalizedString(@"Could not process location", nil)];
}

@end
