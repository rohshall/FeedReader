//
//  FRCell.m
//  FeedReader
//
//  Created by Salil Wadnerkar on 23/4/13.
//  Copyright (c) 2013 Salil Wadnerkar. All rights reserved.
//

#import "FRCell.h"

@implementation FRCell
@synthesize title, description;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
