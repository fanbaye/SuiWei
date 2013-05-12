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
@synthesize labelRetweetContent = _labelRetweetContent;
@synthesize retweetImageView = _retweetImageView;

- (void)dealloc
{
    self.labelAuthor = nil;
    self.labelContent = nil;
    self.labelPostSource = nil;
    self.labelPostTime = nil;
    self.statusImage = nil;
    self.labelRetweetContent = nil;
    self.retweetImageView = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIImageView *topLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fenge.png"]];
        topLine.frame = CGRectMake(0, 0, 320, 3);
        [self.contentView addSubview:topLine];
        [topLine release];
        
        self.labelAuthor = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 122, 21)];
        self.labelPostTime = [[UILabel alloc] initWithFrame:CGRectMake(155, 10, 155, 21)];
        self.labelContent = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 300, 0)];
        self.statusImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 90, 300, 120)];
        self.labelPostSource = [[UILabel alloc] initWithFrame:CGRectMake(10, 175, 300, 21)];
        self.labelRetweetContent = [[UILabel alloc] initWithFrame:CGRectMake(40, 90, 270, 21)];
        self.retweetImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 150, 300, 120)];
        
        _labelAuthor.font = [UIFont systemFontOfSize:14];
        _labelPostTime.font = [UIFont systemFontOfSize:12];
        _labelContent.font = [UIFont systemFontOfSize:16];
        _labelPostSource.font = [UIFont systemFontOfSize:12];
        _labelRetweetContent.font = [UIFont systemFontOfSize:16];
        
        _labelAuthor.backgroundColor = [UIColor clearColor];
        _labelPostTime.backgroundColor = [UIColor clearColor];
        _labelContent.backgroundColor = [UIColor clearColor];
        _labelPostSource.backgroundColor = [UIColor clearColor];
        _statusImage.backgroundColor = [UIColor clearColor];
        _labelRetweetContent.backgroundColor = [UIColor clearColor];
        _retweetImageView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:_labelAuthor]; 
        [self.contentView addSubview:_labelPostTime];
        [self.contentView addSubview:_labelContent];
        [self.contentView addSubview:_statusImage];
        [self.contentView addSubview:_labelPostSource];
        [self.contentView addSubview:_labelRetweetContent];
        [self.contentView addSubview:_retweetImageView];
        
        [_labelAuthor release];
        [_labelPostTime release];
        [_labelContent release];
        [_statusImage release];
        [_labelPostSource release];
        [_labelRetweetContent release];
        [_retweetImageView release];
        
        _statusImage.contentMode = UIViewContentModeLeft;
        
        _labelPostTime.textAlignment = NSTextAlignmentRight;
        _labelPostTime.textColor = [UIColor grayColor];
        
        _labelPostSource.textAlignment = NSTextAlignmentRight;
        _labelPostSource.textColor = [UIColor grayColor];
        
        _labelContent.lineBreakMode = NSLineBreakByWordWrapping;
        _labelContent.numberOfLines = 0;
        
        _labelRetweetContent.lineBreakMode = NSLineBreakByWordWrapping;
        _labelRetweetContent.numberOfLines = 0;
        
        _retweetImageView.contentMode = UIViewContentModeLeft;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
