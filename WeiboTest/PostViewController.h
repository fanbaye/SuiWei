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
    NSData *_imgData;
    FDTakeController *_fdTakeController;
}

@property (nonatomic, assign) id<PostViewControllerDelegate> delegate;
@property (nonatomic, retain) NSData *imgData;
@property (nonatomic, retain) FDTakeController *fdTakeController;
- (IBAction)selectImg:(id)sender;
@property (retain, nonatomic) IBOutlet UITextView *textView;
@property (retain, nonatomic) IBOutlet UIImageView *headPhoto;
@property (retain, nonatomic) IBOutlet UILabel *remainLetter;
@property (retain, nonatomic) IBOutlet UIImageView *libraryPhoto;
- (IBAction)back:(id)sender;
- (IBAction)send:(id)sender;
- (void)showKeyboard;
@end
