//
//  Feed.h
//  FeedReader
//
//  Created by Satinder on 27/04/15.
//  Copyright (c) 2015 Salil Wadnerkar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Feed : NSManagedObject

@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * pubDate;
@property (nonatomic, retain) NSString * auther;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * feed_description;
@property (nonatomic, retain) NSString * guid;
@property (nonatomic, retain) NSString * thumbnail;

@end
