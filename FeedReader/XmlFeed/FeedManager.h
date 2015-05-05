//
//  FeedManager.h
//  FeedReader
//
//  Created by Satinder on 24/04/15.
//  Copyright (c) 2015 Salil Wadnerkar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedDownloader.h"

@interface FeedManager : NSObject <FeedDownloaderDelegate>

@property (nonatomic, strong) NSMutableDictionary *downloadsInProgress;
@property (nonatomic, strong) NSOperationQueue *downloadQueue;

+(id)sharedInstance;

-(void)getAllFeeds;
-(void)getFeedForUrl:(NSString *)url;

@end
