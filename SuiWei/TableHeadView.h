//
//  TableHeadView.h
//  SuiWei
//
//  Created by lucas on 5/13/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableHeadView : UIView

@property (nonatomic, retain) UIImageView *userPhoto;
@property (nonatomic, retain) UILabel *userNameLabel;
@property (nonatomic, retain) UILabel *userCityLabel;
@property (nonatomic, retain) UIButton *editButton;

@property (nonatomic, retain) UIView *userFriendsView;
@property (nonatomic, retain) UILabel *userFriendsCountLabel;

@property (nonatomic, retain) UIView *userFollowersView;
@property (nonatomic, retain) UILabel *userFollowersCountLabel;

@property (nonatomic, retain) UIView *userStatusesView;
@property (nonatomic, retain) UILabel *userStatusesCountLabel;

@end
