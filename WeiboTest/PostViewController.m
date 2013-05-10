//
//  PostViewController.m
//  WeiboTest
//
//  Created by lucas on 5/6/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import "PostViewController.h"
#import "SNNetAccess.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PostViewController ()

@end

@implementation PostViewController

{
    BOOL _havePhoto;
    UILabel *_remainLetter;
    UITextView *_editTextView;
    UIImageView *_selectPhoto;
}

@synthesize delegate = _delegate;
@synthesize fdTakeController = _fdTakeController;
@synthesize userPhoto = _userPhoto;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
    
    _userPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(10, 26, 50, 50)];
    [_userPhoto setImage:[UIImage imageNamed:@"headphoto.png"]];
    _userPhoto.layer.cornerRadius = 23;
    _userPhoto.layer.masksToBounds = YES;
    [self.view addSubview:_userPhoto];
    [_userPhoto release];
    
    _remainLetter = [[UILabel alloc] initWithFrame:CGRectMake(18, 86, 42, 21)];
    _remainLetter.textAlignment = NSTextAlignmentCenter;
    _remainLetter.text = @"140";
    [self.view addSubview:_remainLetter];
    [_remainLetter release];
    
    _editTextView = [[UITextView alloc] initWithFrame:CGRectMake(75, 45, 225, 155)];
    _editTextView.delegate = self;
    [self.view addSubview:_editTextView];
    [_editTextView release];
    
    _selectPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(40, 285, 240, 128)];
    [self.view addSubview:_selectPhoto];
    [_selectPhoto release];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectBtn.frame = CGRectMake(65, 199, 73, 29);
    [selectBtn setTitle:@"选择图片" forState:UIControlStateNormal];
    selectBtn.tag = 2;
    [selectBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectBtn];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(146, 199, 73, 29);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    backBtn.tag = 0;
    [backBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *postBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    postBtn.frame = CGRectMake(227, 199, 73, 29);
    [postBtn setTitle:@"发表" forState:UIControlStateNormal];
    postBtn.tag = 1;
    [postBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:postBtn];
    
    _fdTakeController = [[FDTakeController alloc] init];
    _fdTakeController.delegate = self;
    
    
    
    UISwipeGestureRecognizer *sgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(sgrSlider)];
    sgr.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:sgr];
    
    _havePhoto = NO;
}

- (void)sgrSlider
{
    [_editTextView resignFirstResponder];
    [_delegate hideEdit];
}

- (void)btnClick:(UIButton *)sender
{
    if (sender.tag == 0) {
        [self sgrSlider];
    }else if (sender.tag == 1){
        SNNetAccess *netAccess = [SNNetAccess sharedNetAccess];
        
        if (_havePhoto) {
            [netAccess postText:_editTextView.text AndImage:_selectPhoto.image];
        }else{
            [netAccess postText:_editTextView.text];
        }
        _havePhoto = NO;
    }else if (sender.tag == 2){
        [_editTextView resignFirstResponder];
        [_fdTakeController takePhotoOrChooseFromLibrary];
    }
}

- (void)showKeyboard
{
    [_editTextView becomeFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    _remainLetter.text = [NSString stringWithFormat:@"%d", 140-[_editTextView.text length]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_fdTakeController release];
    [super dealloc];
}

- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info
{
    [_selectPhoto setImage:photo];
    _havePhoto = YES;
}

@end
