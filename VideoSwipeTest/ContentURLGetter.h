//
//  ContentURLGetter.h
//  VideoSwipeTest
//
//  Created by Mark Johnson on 10/11/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Video;

@interface ContentURLGetter : NSObject <UIWebViewDelegate>
{
    UIWebView *_webView;
    NSMutableArray *_videoQueue;
    double _lastGetBegan;
    double _lastGetEnded;
    NSMutableDictionary *_seenPaths;
}

@property (nonatomic, retain) Video * currentVideo;

+ (ContentURLGetter*)singleton;
- (void)processVideo:(Video *)video;
- (UIWebView *)getView;

@end
