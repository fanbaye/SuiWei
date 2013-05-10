//
//  PostViewController.h
//  WeiboTest
//
//  Created by lucas on 5/6/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PostViewControllerDelegate <NSObject>

- (void)hideEdit;
- (void)postText:(NSString *)text;
- (void)postText:(NSString *)text AndImage:(UIImage *)image;

@end

@interface PostViewController : UIViewController <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

{
    id<PostViewControllerDelegate> _delegate;
    UIImageView *_userPhoto;
}

@property (nonatomic, assign) id<PostViewControllerDelegate> delegate;
@property (nonatomic, retain) UIImageView *userPhoto;
- (void)showKeyboard;
@end
