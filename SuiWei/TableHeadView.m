//
//  TableHeadView.m
//  SuiWei
//
//  Created by lucas on 5/13/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import "TableHeadView.h"

@implementation TableHeadView

@synthesize userPhoto = _userPhoto;
@synthesize userNameLabel = _userNameLabel;
@synthesize userCityLabel = _userCityLabel;
@synthesize editButton = _editButton;
@synthesize userFriendsView = _userFriendsView;
@synthesize userFriendsCountLabel = _userFriendsCountLabel;
@synthesize userFollowersView = _userFollowersView;
@synthesize userFollowersCountLabel = _userFollowersCountLabel;
@synthesize userStatusesView = _userStatusesView;
@synthesize userStatusesCountLabel = _userStatusesCountLabel;

- (void)dealloc
{
    self.userPhoto = nil;
    self.userNameLabel = nil;
    self.userCityLabel = nil;
    self.userFriendsView = nil;
    self.userFriendsCountLabel = nil;
    self.userFollowersView = nil;
    self.userFollowersCountLabel = nil;
    self.userStatusesView = nil;
    self.userStatusesCountLabel = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:36.0/255.0 green:36.0/255.0 blue:36.0/255.0 alpha:1];
        // Initialization code
        
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _editButton.frame = CGRectMake(210, 15, 52, 44);
        [_editButton setImage:[UIImage imageNamed:@"editbutton"] forState:UIControlStateNormal];
        [self addSubview:_editButton];
        
        NSArray *array = [[NSArray alloc] initWithObjects:@"关注", @"粉丝", @"微博", nil];
        
        for (int i = 0; i < 3; i++) {
            UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(12+i*93, 102, 27, 14)];
            categoryLabel.font = [UIFont boldSystemFontOfSize:13];
            categoryLabel.textColor = [UIColor grayColor];
            categoryLabel.backgroundColor = [UIColor clearColor];
            categoryLabel.text = [array objectAtIndex:i];
            [self addSubview:categoryLabel];
            [categoryLabel release];
        }
        [array release];
        
        
        self.userPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(12, 11, 52, 52)];
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(72, 15, 133, 20)];
        self.userCityLabel = [[UILabel alloc] initWithFrame:CGRectMake(72, 43, 133, 11)];
        self.userFriendsView = [[UIView alloc] initWithFrame:CGRectMake(-1, 72, 97, 54)];
        self.userFriendsCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 83, 42, 13)];
        
        self.userFollowersView = [[UIView alloc] initWithFrame:CGRectMake(95, 72, 97, 54)];
        self.userFollowersCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(104, 83, 42, 13)];
        
        self.userStatusesView = [[UIView alloc] initWithFrame:CGRectMake(191, 72, 96, 54)];
        self.userStatusesCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(199, 83, 42, 13)];
        
        _userPhoto.tag = 1;
        _userNameLabel.tag = 2;
        _userCityLabel.tag = 3;
        _userFriendsCountLabel.tag = 4;
        _userFollowersCountLabel.tag = 5;
        _userStatusesCountLabel.tag = 6;
        _userFriendsView.tag = 7;
        _userFollowersView.tag = 8;
        _userStatusesView.tag = 9;
        
        [self addSubview:_userPhoto];
        [self addSubview:_userNameLabel];
        [self addSubview:_userCityLabel];
        [self addSubview:_userFriendsView];
        [self addSubview:_userFriendsCountLabel];
        [self addSubview:_userFollowersView];
        [self addSubview:_userFollowersCountLabel];
        [self addSubview:_userStatusesView];
        [self addSubview:_userStatusesCountLabel];
        
        [_userPhoto release];
        [_userNameLabel release];
        [_userCityLabel release];
        [_userFriendsView release];
        [_userFriendsCountLabel release];
        [_userFollowersView release];
        [_userFollowersCountLabel release];
        [_userStatusesView release];
        [_userStatusesCountLabel release];
        
        _userNameLabel.text = @"11111";
        _userCityLabel.text = @"11111";
        _userFollowersCountLabel.text = @"11111";
        _userFriendsCountLabel.text = @"11111";
        _userStatusesCountLabel.text = @"11111";
        
        _userNameLabel.textColor = [UIColor whiteColor];
        _userNameLabel.font = [UIFont boldSystemFontOfSize:19];
        _userNameLabel.backgroundColor = [UIColor clearColor];
        
        _userCityLabel.textColor = [UIColor whiteColor];
        _userCityLabel.backgroundColor = [UIColor clearColor];
        _userCityLabel.font = [UIFont boldSystemFontOfSize:13];
        _userCityLabel.textColor = [UIColor grayColor];
        
        _userFriendsCountLabel.textColor = [UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1];
        _userFriendsCountLabel.backgroundColor = [UIColor clearColor];
        _userFriendsCountLabel.font = [UIFont boldSystemFontOfSize:14];
        
        _userFollowersCountLabel.textColor = [UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1];
        _userFollowersCountLabel.backgroundColor = [UIColor clearColor];
        _userFollowersCountLabel.font = [UIFont boldSystemFontOfSize:14];
        
        _userStatusesCountLabel.textColor = [UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1];
        _userStatusesCountLabel.backgroundColor = [UIColor clearColor];
        _userStatusesCountLabel.font = [UIFont boldSystemFontOfSize:14];
        
        _userFriendsView.layer.masksToBounds = YES;
        _userFriendsView.layer.borderColor = [UIColor colorWithRed:46.0/255.0 green:46.0/255.0 blue:46.0/255.0 alpha:1].CGColor;
        _userFriendsView.layer.borderWidth = 1;
        
        _userFollowersView.layer.masksToBounds = YES;
        _userFollowersView.layer.borderColor = [UIColor colorWithRed:46.0/255.0 green:46.0/255.0 blue:46.0/255.0 alpha:1].CGColor;
        _userFollowersView.layer.borderWidth = 1;
        
        _userStatusesView.layer.masksToBounds = YES;
        _userStatusesView.layer.borderColor = [UIColor colorWithRed:46.0/255.0 green:46.0/255.0 blue:46.0/255.0 alpha:1].CGColor;
        _userStatusesView.layer.borderWidth = 1;
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
