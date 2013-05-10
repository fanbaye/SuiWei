//
//  StatusesViewController.h
//  WeiboTest
//
//  Created by lucas on 5/4/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"

@protocol  StatusesViewControllerDelegate <NSObject>

- (void)hideStatuses;

@end

@interface StatusesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

{
    NSArray *_statuses;
    id<StatusesViewControllerDelegate> _delegate;
    UITableView *_tableView;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, assign) id<StatusesViewControllerDelegate> delegate;
@property (nonatomic, retain) NSArray *statuses;
- (void)updateData:(NSArray *)data;

@end
