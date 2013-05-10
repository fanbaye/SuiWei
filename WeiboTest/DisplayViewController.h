//
//  DisplayViewController.h
//  WeiboTest
//
//  Created by lucas on 5/5/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  DisplayViewControllerDelegate <NSObject>

- (void)hideStatuses;

@end

@interface DisplayViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

{
    NSArray *_statuses;
    id<DisplayViewControllerDelegate> _delegate;
    UITableView *_tableView;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, assign) id<DisplayViewControllerDelegate> delegate;
@property (nonatomic, retain) NSArray *statuses;
- (void)updateData:(NSArray *)data;
- (void)startAct;
- (void)stopAct;

@end
