//
//  VideoViewController.h
//  VideoSwipeTest
//
//  Created by Mark Johnson on 10/15/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoViewController : UIViewController

- (id)initWithYouTubeVideo:(NSString *)youTubeID withAutoStart:(bool)autoStart;
- (void)startPlaying;
- (void)stopPlaying;

@end
