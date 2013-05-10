//
//  WeiboCell.h
//  WeiboTest
//
//  Created by lucas on 5/4/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *content;
@property (retain, nonatomic) IBOutlet UILabel *author;
@property (retain, nonatomic) IBOutlet UILabel *time;
@property (retain, nonatomic) IBOutlet UILabel *source;
@property (retain, nonatomic) IBOutlet UIImageView *img;

@end
