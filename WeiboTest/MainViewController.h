//
//  MainViewController.h
//  WeiboTest
//
//  Created by lucas on 5/5/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNNetAccess.h"
#import "DisplayViewController.h"
#import "CategoryViewController.h"
#import "PostViewController.h"

@interface MainViewController : UIViewController <SNNetAccessDelegate, DisplayViewControllerDelegate, CategoryViewControllerDelegate, PostViewControllerDelegate>

@end
