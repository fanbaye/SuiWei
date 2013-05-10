//
//  WeiboCell.m
//  WeiboTest
//
//  Created by lucas on 5/4/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import "WeiboCell.h"

@implementation WeiboCell

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

- (void)dealloc {
    [_content release];
    [_author release];
    [_time release];
    [_source release];
    [_img release];
    [super dealloc];
}
@end
