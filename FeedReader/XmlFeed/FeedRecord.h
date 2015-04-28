//
//  FeedRecord.h
//  FeedReader
//
//  Created by Satinder on 24/04/15.
//  Copyright (c) 2015 Salil Wadnerkar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedRecord : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSMutableArray *feeds;

@end
