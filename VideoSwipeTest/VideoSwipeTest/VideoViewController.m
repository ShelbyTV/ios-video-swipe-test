//
//  VideoViewController.m
//  VideoSwipeTest
//
//  Created by Mark Johnson on 10/15/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "VideoViewController.h"
#import <AVFoundation/AVPlayer.h>
#import "Video.h"
#import "ContentURLGetter.h"
#import <AVFoundation/AVPlayerLayer.h>
#import <AVFoundation/AVAudioSession.h>


@interface VideoViewController ()

@property (nonatomic, retain) Video *video;
@property (nonatomic, retain) AVPlayer *avPlayer;
@property (nonatomic, retain) AVPlayerLayer *avPlayerLayer;
@property (nonatomic, assign) bool autoStartPlaying;

@end

@implementation VideoViewController

@synthesize video;
@synthesize avPlayer;
@synthesize avPlayerLayer;
@synthesize autoStartPlaying;

- (id)initWithYouTubeVideo:(NSString *)youTubeID withAutoStart:(bool)autoStart
{
    self = [super init];
    if (self) {
        // Custom initialization
        
        video = [[Video alloc] init];
        video.provider = @"youtube";
        video.providerId = youTubeID;

        if (autoStart) {
            NSLog(@"SETTING autoStartPlaying to TRUE");
        }
        autoStartPlaying = autoStart;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(contentURLAvailable:)
                                                     name:@"ContentURLAvailable"
                                                   object:nil];
        
        [[ContentURLGetter singleton] processVideo:video];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"Inside VideoViewController::viewDidLoad");
    self.view.backgroundColor = [UIColor blackColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return TRUE;
}

- (void)contentURLAvailable:(NSNotification *)notification
{
    if (video == [notification.userInfo objectForKey:@"video"]) {
        NSLog(@"ADDING AVPLAYERLAYER");
        avPlayer = [[AVPlayer alloc] initWithURL:[[notification.userInfo objectForKey:@"video"] contentURL]];
        avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
        [avPlayerLayer setFrame:self.view.bounds];
        [self.view.layer addSublayer:avPlayerLayer];
        if (autoStartPlaying) {
            NSLog(@"AUTOSTARTING");
            [avPlayer play];
        }
    }
}

- (void)startPlaying
{
    NSError *activationError = nil;
    NSError *setCategoryError = nil;
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryPlayback
     error: &setCategoryError];
    [[AVAudioSession sharedInstance] setActive: YES error: &activationError];
    [avPlayer play];
}

- (void)stopPlaying
{
    [avPlayer pause];
}

@end
