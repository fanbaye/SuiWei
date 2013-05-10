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

@synthesize statuses = _statuses;

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
        } completion:^(BOOL finished) {
            _dvc.tableView.contentOffset = CGPointMake(0, 0);
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

// 开始更新
- (void)startAct
{
    [_dvc startAct];
}

// 更新结束
- (void)stopAct
{
    [_dvc stopAct];
}

// 返回微博给display
- (void)statuses:(NSArray *)array
{
    [_dvc updateData:array];
}

// 返回用户信息给category
- (void)userInfo:(NSDictionary *)dic
{
    _pvc.imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"profile_image_url"]]];
    [_pvc.headPhoto setImage:[UIImage imageWithData:_pvc.imgData]];
    [_cvc updateUserInfo:dic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
