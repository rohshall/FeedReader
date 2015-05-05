//
//  FeedDownloader.h
//  FeedReader
//
//  Created by Satinder on 24/04/15.
//  Copyright (c) 2015 Salil Wadnerkar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMXMLParser.h"
#import "FeedRecord.h"

// 2: Declare a delegate so that you can notify the caller once the operation is finished.
@protocol FeedDownloaderDelegate;

@interface FeedDownloader : NSOperation <KMXMLParserDelegate>
{
    BOOL isDownloading;
}
@property (nonatomic, assign) id <FeedDownloaderDelegate> delegate;
@property (nonatomic, strong) NSString *url;

- (id)initWithFeedURL:(NSString *)url delegate:(id<FeedDownloaderDelegate>) theDelegate;

@end

@protocol FeedDownloaderDelegate <NSObject>

// 5: In your delegate method, pass the whole class as an object back to the caller so that the caller can access both indexPathInTableView and photoRecord. Because you need to cast the operation to NSObject and return it on the main thread, the delegate method canít have more than one argument.
- (void)feedDownloaderDidFinish:(FeedRecord *)feedRecord;
@end