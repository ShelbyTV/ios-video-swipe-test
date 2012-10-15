//
//  Video.h
//  VideoSwipeTest
//
//  Created by Mark Johnson on 10/11/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject

@property (nonatomic, retain) NSString *provider;
@property (nonatomic, retain) NSString *providerId;
@property (nonatomic, retain) NSURL *contentURL;

@end
