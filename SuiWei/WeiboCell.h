//
//  WeiboCell.h
//  WeiboTest
//
//  Created by lucas on 5/4/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboCell : UITableViewCell

@property (retain, nonatomic) UILabel *labelContent;
@property (retain, nonatomic) UILabel *labelAuthor;
@property (retain, nonatomic) UILabel *labelPostTime;
@property (retain, nonatomic) UILabel *labelPostSource;
@property (retain, nonatomic) UIImageView *statusImage;
@property (retain, nonatomic) UILabel *labelRetweetContent;
@property (retain, nonatomic) UIImageView *retweetImageView;

@end
