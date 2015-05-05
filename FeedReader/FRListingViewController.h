//
//  FRViewController.h
//  FeedReader
//
//  Created by Salil Wadnerkar on 23/4/13.
//  Copyright (c) 2013 Salil Wadnerkar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRListingViewController : UITableViewController

//@property (nonatomic, strong) UIAlertView *loadingView;
@property (nonatomic, strong) NSMutableArray *parseResults;
- (IBAction)refreshClicked:(id)sender;

@end
