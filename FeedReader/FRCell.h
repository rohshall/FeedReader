//
//  FRCell.h
//  FeedReader
//
//  Created by Salil Wadnerkar on 23/4/13.
//  Copyright (c) 2013 Salil Wadnerkar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@end
