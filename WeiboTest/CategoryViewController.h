//
//  CategoryViewController.h
//  WeiboTest
//
//  Created by lucas on 5/5/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryViewControllerDelegate <NSObject>

- (void)showStatuses;
- (void)showEdit;

@end

@interface CategoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIActionSheetDelegate>

{
    id<CategoryViewControllerDelegate> _delegate;
}

@property (nonatomic, assign) id<CategoryViewControllerDelegate> delegate;

- (void)updateUserInfo:(NSDictionary *)userInfo;

@end
