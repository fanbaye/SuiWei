//
//  PostViewController.h
//  WeiboTest
//
//  Created by lucas on 5/6/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"

enum {
    Back = 0,
    PostText,
    ChooseImage
    };

@interface PostViewController : UIViewController <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, SinaWeiboRequestDelegate>

@property (nonatomic, retain) UIImage *userImage;
@property (nonatomic, retain) UITextView *editTextView;

@end
