//
//  FeedDownloader.m
//  FeedReader
//
//  Created by Satinder on 24/04/15.
//  Copyright (c) 2015 Salil Wadnerkar. All rights reserved.
//

#import "FeedDownloader.h"

@implementation FeedDownloader
@synthesize url = _url;
@synthesize delegate = _delegate;

-(id)initWithFeedURL:(NSString *)url delegate:(id<FeedDownloaderDelegate>)theDelegate
{
    if (self = [super init]) {
        _delegate = theDelegate;
        _url = url;
        isDownloading = true;
    }
    return self;
}

-(void)main {
    @autoreleasepool {
        if (self.isCancelled)
            return;
        
        KMXMLParser *parser = [[KMXMLParser alloc] initWithURL:_url delegate:nil];
        FeedRecord *record = [[FeedRecord alloc] init];
        record.url = _url;
        
        if (self.isCancelled) {
            record.feeds = nil;
            return;
        }
//        while (isDownloading) {
//            NSLog(@"run loop");
//        }
        if (parser) {
            record.feeds = [parser posts];
        }
        else {
            record.feeds = nil;
        }
        
        parser = nil;
        
        if (self.isCancelled)
            return;
        
        // 5: Cast the operation to NSObject, and notify the caller on the main thread.
        [(NSObject *)_delegate performSelectorOnMainThread:@selector(feedDownloaderDidFinish:)
                                                withObject:record
                                             waitUntilDone:NO];
    }
}

- (void)parserDidFailWithError:(NSError *)error {
    isDownloading = false;
}
- (void)parserCompletedSuccessfully {
    isDownloading = false;
}
- (void)parserDidBegin {

}
@end
