//
//  PostViewController.m
//  WeiboTest
//
//  Created by lucas on 5/6/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import "PostViewController.h"
#import "SNAppDelegate.h"

@interface PostViewController ()

@end

@implementation PostViewController

{
    BOOL _isHavePhoto;
    UILabel *_remainLetter;
    UIImageView *_selectImgeView;
}

@synthesize userImage = _userImage;
@synthesize editTextView = _editTextView;

- (void)dealloc
{
    self.userImage = nil;
    self.editTextView = nil;
    [super dealloc];
}

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
    _isHavePhoto = NO;
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
    
    UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 26, 50, 50)];
    [userImageView setImage:_userImage];
    userImageView.layer.cornerRadius = 23;
    userImageView.layer.masksToBounds = YES;
    [self.view addSubview:userImageView];
    [userImageView release];
    
    _remainLetter = [[UILabel alloc] initWithFrame:CGRectMake(18, 86, 42, 21)];
    _remainLetter.textAlignment = NSTextAlignmentCenter;
    _remainLetter.text = @"140";
    [self.view addSubview:_remainLetter];
    [_remainLetter release];
    
    self.editTextView = [[UITextView alloc] initWithFrame:CGRectMake(75, 26, 225, 155)];
    _editTextView.delegate = self;
    _editTextView.font = [UIFont systemFontOfSize:18];
    _editTextView.layer.masksToBounds = YES;
    _editTextView.layer.borderWidth = 5.0;
    _editTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.view addSubview:_editTextView];
    [_editTextView release];
    
    _selectImgeView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 285, 240, 128)];
    [self.view addSubview:_selectImgeView];
    [_selectImgeView release];
    
    
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
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectBtn.frame = CGRectMake(65, 199, 73, 29);
    [selectBtn setTitle:@"选择图片" forState:UIControlStateNormal];
    selectBtn.tag = 2;
    [selectBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectBtn];
    
    // 滑动手势 - 收起编辑框
    UISwipeGestureRecognizer *sgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(sgrSlider)];
    sgr.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:sgr];
    
}

// 收起编辑框
- (void)sgrSlider
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)btnClick:(UIButton *)sender
{
    if (sender.tag == Back) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else if (sender.tag == PostText){
        if (_isHavePhoto) {
            [self postText:_editTextView.text AndImage:_selectImgeView.image];
        }else{
            [self postText:_editTextView.text];
        }
        _isHavePhoto = NO;
    }else if (sender.tag == ChooseImage){
        [_editTextView resignFirstResponder];
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"相册", nil];
        as.delegate = self;
        [as showInView:self.view];
        [as release];
    }
}

#pragma mark - Weibo Delegate Methods
- (SinaWeibo *)sinaweibo
{
    SNAppDelegate *delegate = (SNAppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}

// 发微博
- (void)postText:(NSString *)text
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    SinaWeibo *sinaweibo = [self sinaweibo];
    
    [sinaweibo requestWithURL:@"statuses/update.json"
                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:text, @"status", nil]
                   httpMethod:@"POST"
                     delegate:self];
}

// 发带图片微博
- (void)postText:(NSString *)text AndImage:(UIImage *)image
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    SinaWeibo *sinaweibo = [self sinaweibo];
    
    [sinaweibo requestWithURL:@"statuses/upload.json"
                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               text, @"status",
                               image, @"pic", nil]
                   httpMethod:@"POST"
                     delegate:self];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"发表成功" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [av show];
    [av release];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"post status success");
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"statuses/update.json"]){
        NSLog(@"Post status failed with error : %@", error);
    }else if ([request.url hasSuffix:@"statuses/upload.json"]){
        NSLog(@"Post image status failed with error : %@", error);
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - ActionSheet Delegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }
    UIImagePickerController *pc = [[UIImagePickerController alloc] init];
    pc.delegate = self;
    if (buttonIndex == 0) {
        pc.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    [self presentViewController:pc animated:YES completion:^{
        
    }];
    [pc release];
}

#pragma mark - ImagePicker Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _selectImgeView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    _isHavePhoto = YES;
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

// 改变剩余字数的显示
- (void)textViewDidChange:(UITextView *)textView
{
    _remainLetter.text = [NSString stringWithFormat:@"%d", 140-[_editTextView.text length]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
