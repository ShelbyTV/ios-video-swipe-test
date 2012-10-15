//
//  VideoSliderViewControllerViewController.m
//  VideoSwipeTest
//
//  Created by Mark Johnson on 10/11/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "VideoSliderViewController.h"

#import "VideoViewController.h"

@interface VideoSliderViewController ()

@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) UIScrollView *scrollView;
@property boolean_t videoPlaying;
@property (nonatomic, retain) NSMutableArray *youTubeVids;

@end

@implementation VideoSliderViewController

@synthesize viewControllers;
@synthesize scrollView;
@synthesize videoPlaying;
@synthesize youTubeVids;

static int currentVideo;

- initWithFrame:(CGRect)frame 
{
    self = [super init];
    if (self) {
        // static list of youtube videos
        youTubeVids = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:@"sKeslrZ-i6k", 
                                @"uIBgWI_BTyM",
                                @"AlPqL7IUT6M", 
                                @"4uwtqRBE4Kk",
                                 nil]];
 
        
        currentVideo = 0;
        
        self.viewControllers = [[NSMutableArray alloc] init];
        
        // view controllers are created lazily
        // in the meantime, load the array with placeholders which will be replaced on demand
        for (unsigned i = 0; i < [youTubeVids count]; i++)
        {
            [self.viewControllers addObject:[NSNull null]];
        }
        
        scrollView = [[UIScrollView alloc] init];
        
        // a page is the width of the scroll view
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(1024 * [youTubeVids count], 768);
        scrollView.frame = CGRectMake(0, 0, 1024, 768);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.delegate = self;
        scrollView.backgroundColor = [UIColor blackColor];
        
        // load the visible page
        // load the page on either side to avoid flashes when the user starts scrolling
        //
        [self loadScrollViewWithPage:0 withAutoStart:YES];
        [self loadScrollViewWithPage:1 withAutoStart:NO];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    NSLog(@"Inside VideoSliderViewController viewDidLoad");
    scrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:scrollView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || 
           (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)loadScrollViewWithPage:(int)page withAutoStart:(bool)autoStart
{
    if (page < 0)
        return;
    if (page >= [youTubeVids count])
        return;
    
    // replace the placeholder if necessary
    VideoViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[VideoViewController alloc] initWithYouTubeVideo:(NSString *)[youTubeVids objectAtIndex:page] withAutoStart:autoStart];
        [viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        NSLog(@"add the controller's view to the scroll view");
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [scrollView addSubview:controller.view];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{	    
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
 
    if (page != currentVideo) {
        [[viewControllers objectAtIndex:currentVideo] stopPlaying];
        [[viewControllers objectAtIndex:page] startPlaying];
        currentVideo = page;
    }

    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1 withAutoStart:NO];
    [self loadScrollViewWithPage:page withAutoStart:NO];
    [self loadScrollViewWithPage:page + 1 withAutoStart:NO];
}


@end
