//
//  PostViewController.h
//  WeiboTest
//
//  Created by lucas on 5/6/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDTakeController.h"

@protocol PostViewControllerDelegate <NSObject>

- (void)hideEdit;

@end

@interface PostViewController : UIViewController <UITextViewDelegate, FDTakeDelegate>

{
    id<PostViewControllerDelegate> _delegate;
    FDTakeController *_fdTakeController;
    UIImageView *_userPhoto;
    
}

@property (nonatomic, assign) id<PostViewControllerDelegate> delegate;
@property (nonatomic, retain) FDTakeController *fdTakeController;
@property (nonatomic, retain) UIImageView *userPhoto;
- (void)showKeyboard;
@end
