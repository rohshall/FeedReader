//
//  DataManager.m
//  FeedReader
//
//  Created by Satinder on 27/04/15.
//  Copyright (c) 2015 Salil Wadnerkar. All rights reserved.
//

#import "DataManager.h"
#import "FRAppDelegate.h"
#import "Feed.h"

static DataManager *sharedInstance = nil;
@implementation DataManager

-(id)init {
    if (sharedInstance == nil) {
        if (self = [super init]) {
            sharedInstance = self;
            
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

-(BOOL)insertFeeds:(NSMutableArray *)feeds {
    BOOL status = true;
    FRAppDelegate *appDelegate = (FRAppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSUInteger readCount = [self readAllFeeds].count;
    if (readCount > 0) {
        readCount++;
    }
    
    for (NSDictionary *dictionary in feeds) {
        Feed *feed = [NSEntityDescription insertNewObjectForEntityForName:@"Feed"
                                                   inManagedObjectContext:appDelegate.managedObjectContext];
        feed.identifier = [NSNumber numberWithInteger:readCount];
        feed.title = [dictionary objectForKey:@"title"];
        feed.auther = [dictionary objectForKey:@"author"];
        feed.feed_description = [dictionary objectForKey:@"description"];
        feed.link = [dictionary objectForKey:@"link"];
        feed.thumbnail = [dictionary objectForKey:@"thumbnail"];
        feed.guid = [dictionary objectForKey:@"guid"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
        feed.pubDate = [dateFormat dateFromString:[dictionary objectForKey:@"pubDate"]];
        
        NSError *error;
        if (![appDelegate.managedObjectContext save:&error]) {
            status = false;
            NSLog(@"Failed to save - error: %@", [error localizedDescription]);
        }
        readCount++;
    }
    return status;
}

-(NSMutableArray *)readAllFeeds {

    FRAppDelegate *appDelegate = (FRAppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Feed"
                                              inManagedObjectContext:appDelegate.managedObjectContext];
    
    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pubDate" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSMutableArray *feeds = (NSMutableArray *)[appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        
    }
    return feeds;
}

-(BOOL)deleteAllFeeds {
    BOOL sts = true;
    NSError *error = nil;
    FRAppDelegate *appDelegate = (FRAppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableArray *feeds = [self readAllFeeds];
    for (Feed *feed in feeds) {
        [appDelegate.managedObjectContext deleteObject:feed];
    }
    [appDelegate.managedObjectContext save:&error];
    if (error != nil) {
        sts = false;
        NSLog(@"Unable to delete managed object context:: %@", [error localizedDescription]);
    }
    return sts;
}
@end
