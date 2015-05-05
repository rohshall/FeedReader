//
//  DataManager.h
//  FeedReader
//
//  Created by Satinder on 27/04/15.
//  Copyright (c) 2015 Salil Wadnerkar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

+(id)sharedInstance;

-(BOOL)insertFeeds:(NSMutableArray *)feeds forGroupId:(NSString *)guid;

-(NSMutableArray *)readAllFeeds;
-(NSMutableArray *)readFeedsWithGuid:(NSString *)guid;

-(BOOL)deleteAllFeeds;
-(BOOL)deleteFeedsWithGuid:(NSString *)guid;
@end
