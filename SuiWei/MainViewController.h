//
//  MainViewController.h
//  WeiboTest
//
//  Created by lucas on 5/5/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayViewController.h"
#import "CategoryViewController.h"
#import "PostViewController.h"
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"

@interface MainViewController : UIViewController <DisplayViewControllerDelegate, CategoryViewControllerDelegate, PostViewControllerDelegate, SinaWeiboDelegate, SinaWeiboRequestDelegate>

@end
