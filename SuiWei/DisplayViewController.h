//
//  DisplayViewController.h
//  WeiboTest
//
//  Created by lucas on 5/5/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "EGORefreshTableHeaderView.h"
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"

@protocol  DisplayViewControllerDelegate <NSObject>

- (void)hideStatusesPanel;

@end

@interface DisplayViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ASIHTTPRequestDelegate, EGORefreshTableHeaderDelegate, SinaWeiboRequestDelegate>

{
    id<DisplayViewControllerDelegate> _delegate;
}

@property (nonatomic, assign) id<DisplayViewControllerDelegate> delegate;
- (void)getFriendsStatuses;

@end
