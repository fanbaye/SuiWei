//
//  WeiboCell.m
//  WeiboTest
//
//  Created by lucas on 5/4/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import "WeiboCell.h"

@implementation WeiboCell

@synthesize authorImageView = _authorImageView;
@synthesize labelAuthor = _labelAuthor;
@synthesize labelContent = _labelContent;
@synthesize labelComments = _labelComments;
@synthesize labelReports = _labelReports;
@synthesize labelPostSource = _labelPostSource;
@synthesize labelPostTime = _labelPostTime;
@synthesize statusImage = _statusImage;
@synthesize labelRetweetContent = _labelRetweetContent;
@synthesize retweetImageView = _retweetImageView;
@synthesize leftLine = _leftLine;

- (void)dealloc
{
    self.authorImageView = nil;
    self.leftLine = nil;
    self.labelReports = nil;
    self.labelComments = nil;
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
        
        UIImageView *comments = [[UIImageView alloc] initWithFrame:CGRectMake(253, 29, 11, 11)];
        [comments setImage:[UIImage imageNamed:@"comments"]];
        [self.contentView addSubview:comments];
        [comments release];
        
        UIImageView *reports = [[UIImageView alloc] initWithFrame:CGRectMake(288, 29, 11, 11)];
        [reports setImage:[UIImage imageNamed:@"reports"]];
        [self.contentView addSubview:reports];
        [reports release];
        
        
        self.authorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 6, 35, 35)];
        self.labelAuthor = [[UILabel alloc] initWithFrame:CGRectMake(54, 27, 106, 14)];
        self.labelPostTime = [[UILabel alloc] initWithFrame:CGRectMake(167, 29, 53, 11)];
        self.labelComments = [[UILabel alloc] initWithFrame:CGRectMake(266, 29, 22, 11)];
        self.labelReports = [[UILabel alloc] initWithFrame:CGRectMake(301, 29, 22, 11)];
        
        self.labelContent = [[UILabel alloc] initWithFrame:CGRectMake(13, 52, 294, 0)];
        
        self.statusImage = [[UIImageView alloc] initWithFrame:CGRectMake(13, 0, 294, 133)];

        self.leftLine = [[UIView alloc] initWithFrame:CGRectMake(15, 0, 10, 0)];
        self.labelRetweetContent = [[UILabel alloc] initWithFrame:CGRectMake(34, 0, 273, 0)];
        self.retweetImageView = [[UIImageView alloc] initWithFrame:CGRectMake(34, 0, 273, 133)];
        
        self.labelPostSource = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 294, 11)];
        
        _labelAuthor.font = [UIFont systemFontOfSize:14];
        _labelPostTime.font = [UIFont systemFontOfSize:12];
        _labelContent.font = [UIFont systemFontOfSize:16];
        _labelPostSource.font = [UIFont systemFontOfSize:12];
        _labelRetweetContent.font = [UIFont systemFontOfSize:15];
        _labelReports.font = [UIFont systemFontOfSize:10];
        _labelComments.font = [UIFont systemFontOfSize:10];
        
        _labelAuthor.backgroundColor = [UIColor clearColor];
        _labelPostTime.backgroundColor = [UIColor clearColor];
        _labelContent.backgroundColor = [UIColor clearColor];
        _labelPostSource.backgroundColor = [UIColor clearColor];
        _statusImage.backgroundColor = [UIColor clearColor];
        _labelRetweetContent.backgroundColor = [UIColor clearColor];
        _retweetImageView.backgroundColor = [UIColor clearColor];
        _labelComments.backgroundColor = [UIColor clearColor];
        _authorImageView.backgroundColor = [UIColor clearColor];
        _labelReports.backgroundColor = [UIColor clearColor];
        _leftLine.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1];
        
        [self.contentView addSubview:_labelAuthor]; 
        [self.contentView addSubview:_labelPostTime];
        [self.contentView addSubview:_labelContent];
        [self.contentView addSubview:_statusImage];
        [self.contentView addSubview:_labelPostSource];
        [self.contentView addSubview:_labelRetweetContent];
        [self.contentView addSubview:_retweetImageView];
        [self.contentView addSubview:_labelReports];
        [self.contentView addSubview:_labelComments];
        [self.contentView addSubview:_authorImageView];
        [self.contentView addSubview:_leftLine];
        
        [_labelAuthor release];
        [_labelPostTime release];
        [_labelContent release];
        [_statusImage release];
        [_labelPostSource release];
        [_labelRetweetContent release];
        [_retweetImageView release];
        [_authorImageView release];
        [_labelComments release];
        [_labelReports release];
        [_leftLine release];
        
        _authorImageView.layer.cornerRadius = 17;
        _authorImageView.layer.masksToBounds = YES;
        
        _labelComments.textColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
        
        _labelReports.textColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
        
        _statusImage.contentMode = UIViewContentModeLeft;
        
        _labelPostTime.textAlignment = NSTextAlignmentRight;
        _labelPostTime.textColor = [UIColor grayColor];
        
        _labelPostSource.textAlignment = NSTextAlignmentRight;
        _labelPostSource.textColor = [UIColor colorWithRed:206.0/255.0 green:206.0/255.0 blue:206.0/255.0 alpha:1];
        
        _labelContent.lineBreakMode = NSLineBreakByWordWrapping;
        _labelContent.numberOfLines = 0;
        
        _labelRetweetContent.lineBreakMode = NSLineBreakByWordWrapping;
        _labelRetweetContent.numberOfLines = 0;
        
        _retweetImageView.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
