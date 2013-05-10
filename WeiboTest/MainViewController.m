//
//  MainViewController.m
//  WeiboTest
//
//  Created by lucas on 5/5/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import "MainViewController.h"
#import "SNAppDelegate.h"
#import "WeiboStatus.h"
#import "DatabaseManager.h"

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
        [self login];
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


- (SinaWeibo *)sinaweibo
{
    SNAppDelegate *delegate = (SNAppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}


#pragma mark - Setting AuthData
// 移除用户数据
- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}


// 保存用户数据
- (void)storeAuthData
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Weibo Login&logout

// 登入
- (void)login
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo logIn];
}

// 登出
- (void)logout
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo logOut];
}

#pragma mark - Get Weibo Infomations

// 用户信息
- (void)getUserInfo
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"users/show.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
    NSLog(@"send users/show.json");
}

// 用户自己的微博
- (void)getTimeline
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"statuses/user_timeline.json"
                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:sinaweibo.userID, @"uid", nil]
                   httpMethod:@"GET"
                     delegate:self];
    NSLog(@"send statuses/user_timeline.json");
}


// 全部微博
- (void)getFriendsTime
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    DatabaseManager *db = [[DatabaseManager alloc] init];
    NSString *maxId = [db databaseGetLastId];
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"statuses/friends_timeline.json"
                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:sinaweibo.userID, @"uid",maxId , @"since_id", nil]
                   httpMethod:@"GET"
                     delegate:self];
    [db databaseClose];
    [db release];
    NSLog(@"send statuses/friends_timeline.json");
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

#pragma mark - Setting InterfaceOrientation

// 支持屏幕翻转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - SinaWeibo Delegate

// 登入之后执行
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    [self storeAuthData];
    [self getUserInfo];
    [_dvc openApp];

}

// 等出之后执行
- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    [self removeAuthData];
    [self login];
}

// 登入取消时执行
- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
}

// 登入失败报告
- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
}

// 取消授权？
- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
    [self removeAuthData];
}

#pragma mark - SinaWeiboRequest Delegate

// 获取数据各种失败
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"users/show.json"]){
        NSLog(@"get userInfo failed");
    }else if ([request.url hasSuffix:@"statuses/user_timeline.json"]
              || [request.url hasSuffix:@"statuses/friends_timeline.json"]){
        NSLog(@"get statuses failed");
    }else if ([request.url hasSuffix:@"statuses/update.json"]){
        NSLog(@"Post status failed with error : %@", error);
    }else if ([request.url hasSuffix:@"statuses/upload.json"]){
        NSLog(@"Post image status failed with error : %@", error);
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

// 返回结果
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    // 用户信息
    if ([request.url hasSuffix:@"users/show.json"]){
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[result objectForKey:@"profile_image_url"]]];
        [_pvc.userPhoto setImage:[UIImage imageWithData:data]];
        [_cvc updateUserInfo:result];
    }
    
    // 用户自己的微博 或 全部微博
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"] || [request.url hasSuffix:@"statuses/friends_timeline.json"]){
        DatabaseManager *db = [[DatabaseManager alloc] init];
        NSArray *statuses = [[result objectForKey:@"statuses"] retain];
        for (NSDictionary *dic in statuses) {
            
            WeiboStatus *oneStatus = [[WeiboStatus alloc] init];
            oneStatus.contentStr = [dic objectForKey:@"text"];
            oneStatus.authorStr = [[dic objectForKey:@"user"] objectForKey:@"screen_name"];
            oneStatus.timeStr = [dic objectForKey:@"created_at"];
            oneStatus.imgStr = [dic objectForKey:@"thumbnail_pic"];
            oneStatus.sourceStr = [dic objectForKey:@"source"];
            oneStatus.idStr = [dic objectForKey:@"idstr"];
            
            [db databaseInsert:oneStatus];
            [oneStatus release];
        }
        
        [db databaseClose];
        [db release];
        [statuses release];
        [_dvc updateData];
        
    }
    
    // 发微博
    else if ([request.url hasSuffix:@"statuses/update.json"] || [request.url hasSuffix:@"statuses/upload.json"]){
        
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"%@", request.url);
}

@end
