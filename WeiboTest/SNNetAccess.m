//
//  SNNetAccess.m
//  WeiboTest
//
//  Created by lucas on 5/5/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import "SNNetAccess.h"
#import "SNAppDelegate.h"
#import "WeiboStatus.h"
#import "DatabaseManager.h"

@implementation SNNetAccess

@synthesize delegate = _delegate;

static SNNetAccess *_netAccess;
+ (SNNetAccess *)sharedNetAccess
{
    if (!_netAccess) {
        _netAccess = [[SNNetAccess alloc] init];
    }
    return _netAccess;
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
    [_delegate openApp];
}

// 等出之后执行
- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    [self removeAuthData];
    NSLog(@"logout");
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
        [_delegate userInfo:[[result retain] autorelease]];
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
        [_delegate updateStatuses];
        
    }
    
    // 发微博
    else if ([request.url hasSuffix:@"statuses/update.json"] || [request.url hasSuffix:@"statuses/upload.json"]){
        
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"%@", request.url);
}

@end
