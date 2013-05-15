//
//  CategoryCell.m
//  SuiWei
//
//  Created by lucas on 5/15/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell

@synthesize icon = _icon;
@synthesize category = _category;
@synthesize arrow = _arrow;

- (void)dealloc
{
    self.icon = nil;
    self.category = nil;
    self.arrow = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor colorWithRed:36.0/255.0 green:36.0/255.0 blue:36.0/255.0 alpha:1];
        
        UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        [topLine setImage:[UIImage imageNamed:@"categoryCellTopLine"]];
        [self.contentView addSubview:topLine];
        [topLine release];
        
        UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
        [bottomLine setImage:[UIImage imageNamed:@"categoryCellBottomLine"]];
        [self.contentView addSubview:bottomLine];
        [bottomLine release];
        
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(250, 14, 11, 15)];
        [arrow setImage:[UIImage imageNamed:@"categoryCellArrow"]];
        [self.contentView addSubview:arrow];
        [arrow release];
        
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(13, 12, 28, 20)];
        _icon.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_icon];
        [_icon release];
        
        self.category = [[UILabel alloc] initWithFrame:CGRectMake(50, 11, 100, 22)];
        _category.textColor = [UIColor grayColor];
        _category.font = [UIFont boldSystemFontOfSize:17];
        _category.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_category];
        [_category release];
        
        self.arrow = [[UIImageView alloc] initWithFrame:CGRectMake(250, 11, 15, 22)];
        _arrow.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_arrow];
        [_arrow release];
        
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
//    if (highlighted) {
//        _category.textColor = [UIColor redColor];
//    }else{
//        _category.textColor = [UIColor grayColor];
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
