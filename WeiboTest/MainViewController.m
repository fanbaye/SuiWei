//
//  MainViewController.m
//  WeiboTest
//
//  Created by lucas on 5/5/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

{
    CategoryViewController *_cvc;
    DisplayViewController *_dvc;
    PostViewController *_pvc;
    BOOL _isHideStatuses;
    BOOL _firstAppear;
}

- (void)dealloc
{
    [_cvc release];
    [_dvc release];
    [_pvc release];
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
    self.view.backgroundColor = [UIColor blackColor];
    _isHideStatuses = NO;
    _firstAppear = YES;
	// Do any additional setup after loading the view.
    
    _cvc = [[CategoryViewController alloc] init];
    _cvc.delegate = self;
    _cvc.view.frame = CGRectMake(0, 0, 300, 460);
    [self.view addSubview:_cvc.view];

    _dvc = [[DisplayViewController alloc] init];
    _dvc.delegate = self;
    _dvc.view.frame = CGRectMake(0, 0, 320, 460);
    [self.view addSubview:_dvc.view];
    
    _pvc = [[PostViewController alloc] init];
    _pvc.delegate = self;
    _pvc.view.frame = CGRectMake(0, 480, 320, 460);
    
    SNNetAccess *netAccess = [SNNetAccess sharedNetAccess];
    netAccess.delegate = self;
    
    UISwipeGestureRecognizer *sgrLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showStatuses)];
    sgrLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:sgrLeft];
    [sgrLeft release];
    
}

// 自动登陆
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_firstAppear) {
        SNNetAccess *netAccess = [SNNetAccess sharedNetAccess];
        [netAccess login];
        
        _firstAppear = NO;
    }
}

- (void)openApp
{
    SNNetAccess *netAccess = [SNNetAccess sharedNetAccess];
    [netAccess getUserInfo];
    [_dvc openApp];
}


// 显示微博表格
- (void)showStatuses
{
    if (_isHideStatuses) {
        [UIView animateWithDuration:0.25 animations:^{
            _dvc.view.frame = CGRectMake(0, 0, 320, 460);
        }];
        _isHideStatuses = NO;
    }
}

// 隐藏微博表格
- (void)hideStatuses
{
    if (!_isHideStatuses) {
        [UIView animateWithDuration:0.25 animations:^{
            _dvc.view.frame = CGRectMake(300, 0, 320, 460);
        }];
        _isHideStatuses = YES;
    }
}

// 显示编辑框
- (void)showEdit
{
    [self.view addSubview:_pvc.view];
    [UIView animateWithDuration:0.2 animations:^{
        _dvc.view.frame = CGRectMake(320, 0, 320, 460);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            _pvc.view.frame = CGRectMake(0, 0, 320, 460);
        }];
    }];
    [_pvc showKeyboard];
}

// 隐藏编辑框
- (void)hideEdit
{
    
    [UIView animateWithDuration:0.2 animations:^{
        _pvc.view.frame = CGRectMake(0, 480, 320, 460);
    } completion:^(BOOL finished) {
        [_pvc.view removeFromSuperview];
        [UIView animateWithDuration:0.2 animations:^{
            _dvc.view.frame = CGRectMake(300, 0, 320, 460);
        }];
    }];
    
}

// 返回微博给display
- (void)updateStatuses
{
    [_dvc updateData];
}

// 返回用户信息给category和post
- (void)userInfo:(NSDictionary *)dic
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"profile_image_url"]]];
    [_pvc.userPhoto setImage:[UIImage imageWithData:data]];
    [_cvc updateUserInfo:dic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
