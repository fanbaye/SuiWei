//
//  CategoryViewController.h
//  WeiboTest
//
//  Created by lucas on 5/5/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
#import "DisplayViewController.h"

@interface CategoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate,DisplayViewControllerDelegate, SinaWeiboDelegate, SinaWeiboRequestDelegate>

@end
