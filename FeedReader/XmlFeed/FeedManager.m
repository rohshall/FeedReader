//
//  FeedManager.m
//  FeedReader
//
//  Created by Satinder on 24/04/15.
//  Copyright (c) 2015 Salil Wadnerkar. All rights reserved.
//

#import "FeedManager.h"
#import "FRAppDelegate.h"
#import "DataManager.h"

static FeedManager *sharedInstance = nil;

@implementation FeedManager
@synthesize downloadsInProgress = _downloadsInProgress;
@synthesize downloadQueue = _downloadQueue;

-(id)init {
    if (sharedInstance == nil) {
        if (self = [super init]) {
            sharedInstance = self;
            
            _downloadsInProgress = [[NSMutableDictionary alloc] init];
            
            _downloadQueue = [[NSOperationQueue alloc] init];
            _downloadQueue.name = @"Download Queue";
            _downloadQueue.maxConcurrentOperationCount = 1;
            
        }
    }
    return sharedInstance;
}

+(id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)getAllFeeds {
    NSArray *urlArray = [NSArray arrayWithObjects:@"http://topics.nytimes.com/top/reference/timestopics/subjects/s/sikhs_sect/index.html?rss=1", @"http://feeds.feedburner.com/sikhnetnews", @"http://sikhsiyasat.net/feed/", nil];
    int index = 0;
    for (int i = 0; i < 50; i++) {
        if (index > 2) {
            index = 1;
        }
        [self getFeedForUrl:[urlArray objectAtIndex:index]];
        index++;
    }
}

-(void)getFeedForUrl:(NSString *)url {
    if ([_downloadsInProgress objectForKey:url] == nil) {
        NSLog(@"Starting Downloading for %@", url);
        FeedDownloader *feedDownloader = [[FeedDownloader alloc] initWithFeedURL:url delegate:self];
        [_downloadsInProgress setObject:feedDownloader forKey:url];
        [_downloadQueue addOperation:feedDownloader];
    }
    else {
        //Already in progress
        //NSLog(@"Downloading already in-progress for %@", url);
    }
    
}


#pragma mark -
#pragma mark - FeedDownloader delegate


- (void)feedDownloaderDidFinish:(FeedRecord *)feedRecord {
    NSLog(@"Feed count: %d", [feedRecord.feeds count]);
    [_downloadsInProgress removeObjectForKey:feedRecord.url];
    
    BOOL sts = [[DataManager sharedInstance] insertFeeds:feedRecord.feeds];
    if (!sts) {
        NSLog(@"Error");
    }
    
    if ([_downloadsInProgress count] <= 0) {
        //Operations Completed.
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUI" object:self];
    }
}

@end
