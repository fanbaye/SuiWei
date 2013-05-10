//
//  WeiboCell.m
//  WeiboTest
//
//  Created by lucas on 5/4/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import "WeiboCell.h"

@implementation WeiboCell

@synthesize labelAuthor = _labelAuthor;
@synthesize labelContent = _labelContent;
@synthesize labelPostSource = _labelPostSource;
@synthesize labelPostTime = _labelPostTime;
@synthesize statusImage = _statusImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIImageView *topLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fenge.png"]];
        topLine.frame = CGRectMake(0, 0, 320, 3);
        [self.contentView addSubview:topLine];
        [topLine release];
        
        _labelAuthor = [[UILabel alloc ] initWithFrame:CGRectMake(10, 10, 122, 21)];
        _labelPostTime = [[UILabel alloc ] initWithFrame:CGRectMake(155, 10, 155, 21)];
        _labelContent = [[UILabel alloc ] initWithFrame:CGRectMake(10, 30, 300, 0)];
        _statusImage = [[UIImageView alloc ] initWithFrame:CGRectMake(10, 90, 300, 120)];
        _labelPostSource = [[UILabel alloc ] initWithFrame:CGRectMake(10, 175, 300, 21)];
        
        _labelAuthor.font = [UIFont systemFontOfSize:14];
        _labelPostTime.font = [UIFont systemFontOfSize:12];
        _labelContent.font = [UIFont systemFontOfSize:16];
        _labelPostSource.font = [UIFont systemFontOfSize:12];
        
        _labelAuthor.backgroundColor = [UIColor clearColor];
        _labelPostTime.backgroundColor = [UIColor clearColor];
        _labelContent.backgroundColor = [UIColor clearColor];
        _labelPostSource.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:_labelAuthor];
        [self.contentView addSubview:_labelPostTime];
        [self.contentView addSubview:_labelContent];
        [self.contentView addSubview:_statusImage];
        [self.contentView addSubview:_labelPostSource];
        
        [_labelAuthor release];
        [_labelPostTime release];
        [_labelContent release];
        [_statusImage release];
        [_labelPostSource release];
        
        _statusImage.contentMode = UIViewContentModeLeft;
        _labelPostSource.textAlignment = NSTextAlignmentRight;
        _labelPostTime.textAlignment = NSTextAlignmentRight;
        _labelPostTime.textColor = [UIColor grayColor];
        _labelPostSource.textColor = [UIColor grayColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
