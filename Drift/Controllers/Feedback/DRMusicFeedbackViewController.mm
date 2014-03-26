//
//  DRMusicFeebbackViewController.m
//  Drift
//
//  Created by Christoph Albert on 3/26/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRMusicFeedbackViewController.h"
#import "Novocaine.h"
#import "AudioFileReader.h"

@interface DRMusicFeedbackViewController ()

@property (nonatomic, strong) Novocaine *audioManager;
@property (nonatomic, strong) AudioFileReader *fileReader;

@property (nonatomic, assign) CGFloat volume;
@property (nonatomic, assign) CGFloat pan;

@end

@implementation DRMusicFeedbackViewController

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

    __weak DRMusicFeedbackViewController * wself = self;

    self.audioManager = [Novocaine audioManager];

    NSURL *inputFileURL = [[NSBundle mainBundle] URLForResource:@"Sonar" withExtension:@"wav"];

    self.fileReader = [[AudioFileReader alloc]
                       initWithAudioFileURL:inputFileURL
                       samplingRate:self.audioManager.samplingRate
                       numChannels:self.audioManager.numOutputChannels];

    //http://mymbs.mbs.net/~pfisher/FOV2-0010016C/FOV2-0010016E/FOV2-001001A3/tutorials/ezine4/beginners/graph1.gif

    [self.audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
    {
        if (wself.volume > 0) {
            if (wself.fileReader.currentTime > 2) {
                wself.fileReader.currentTime = 0;
            }
            [wself.fileReader play];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dataProcessor:(DRDataProcessor *)processor didCalculateDrift:(DRDrift *)result {
    CGFloat volumeCurve = 2;  //1 = linear,
                                //>1 = more fine in close ranges, more dropoff in far ranges
                                //<1 = less fine in close ranges, controlled dropoff in far ranges
    self.volume = MAX(0.2, 1 - pow(fabs(result.distance/[[DRVariableManager sharedManager] zone2Thresh]), volumeCurve));

    CGFloat panPos; // 0 = left, 0.5 middle, 1 = right

    if ((result.direction == DRDriftDirectionLeft || result.direction == DRDriftDirectionRight)) {

        // relative pan amount from 0 to 1
        CGFloat rel = fabs(result.distance/([[DRVariableManager sharedManager] zone2Thresh]/1.5));

        panPos = result.direction == DRDriftDirectionRight ? 0.5-rel/2 : 0.5+rel/2;
        panPos = MAX(0.1, MIN(0.9, panPos));
    } else {
        panPos = 0.5;
    }

    DLog(@"Drift: %f, Pan: %f, Volume: %f", result.distance, self.pan, self.volume);

    self.pan = panPos;
}

-(void)dataProcessor:(DRDataProcessor *)processor didFailWithError:(NSError *)error {
    self.volume = 0;
}

@end
