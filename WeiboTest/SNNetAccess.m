//
//  SNNetAccess.m
//  WeiboTest
//
//  Created by lucas on 5/5/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import "SNNetAccess.h"
#import "SNAppDelegate.h"
#import "Status.h"

@implementation SNNetAccess

@synthesize userInfo = _userInfo;
@synthesize friendsStatuses = _friendsStatuses;
@synthesize statuses = _statuses;
@synthesize delegate = _delegate;

static SNNetAccess *_netAccess;
+ (SNNetAccess *)sharedNetAccess
{
    if (!_netAccess) {
        _netAccess = [[SNNetAccess alloc] init];
    }
    return _netAccess;
}

- (void)dealloc
{
    [_userInfo release]; _userInfo = nil;
    [_statuses release]; _statuses = nil;
    [_friendsStatuses release]; _friendsStatuses = nil;
    [super dealloc];
}

- (SinaWeibo *)sinaweibo
{
    SNAppDelegate *delegate = (SNAppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}

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


// 登入
- (void)login
{
    [_userInfo release], _userInfo = nil;
    [_statuses release], _statuses = nil;
    
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo logIn];

}

// 登出
- (void)logout
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo logOut];
}


// 全部微博
- (void)getFriendsTime
{
    [_delegate startAct];
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"statuses/friends_timeline.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
}

// 用户信息
- (void)getUserInfo
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"users/show.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
}

// 用户自己的微博
- (void)getTimeline
{
    [_delegate startAct];
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"statuses/user_timeline.json"
                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:sinaweibo.userID, @"uid", nil]
                   httpMethod:@"GET"
                     delegate:self];
}

// 发微博
- (void)postText:(NSString *)text
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"statuses/update.json"
                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:text, @"status", nil]
                   httpMethod:@"POST"
                     delegate:self];
}


// 发带图片微博
- (void)postText:(NSString *)text AndImage:(UIImage *)image
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    
    [sinaweibo requestWithURL:@"statuses/upload.json"
                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               text, @"status",
                               image, @"pic", nil]
                   httpMethod:@"POST"
                     delegate:self];
}

// 返回结果
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    // 用户信息
    if ([request.url hasSuffix:@"users/show.json"])
    {
        [_userInfo release];
        _userInfo = [result retain];
        [_delegate userInfo:_userInfo];
    }
    
    // 用户微博
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        [_statuses release];
        _statuses = [[result objectForKey:@"statuses"] retain];
        NSMutableArray *readyStatuses = [[NSMutableArray alloc] initWithCapacity:20];
        for (int i=0; i<[_statuses count]; i++) {
            Status *oneStatus = [[Status alloc] init];
            NSDictionary *dic = [_statuses objectAtIndex:i];
            oneStatus.contentStr = [dic objectForKey:@"text"];
            oneStatus.authorStr = [[dic objectForKey:@"user"] objectForKey:@"screen_name"];
            oneStatus.timeStr = [dic objectForKey:@"created_at"];
            oneStatus.imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"thumbnail_pic"]]];
            oneStatus.sourceStr = [dic objectForKey:@"source"];
            [readyStatuses addObject:oneStatus];
            [oneStatus release];
        }
        [_delegate statuses:readyStatuses];
        [_delegate stopAct];
        
    }
    
    // 发微博
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post status \"%@\" succeed!", [result objectForKey:@"text"]]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
        
    }
    
    // 发带图片的微博
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post image status \"%@\" succeed!", [result objectForKey:@"text"]]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
        
    }
    
    // 全部微博
    else if ([request.url hasSuffix:@"statuses/friends_timeline.json"]){
        [_friendsStatuses release];
        _friendsStatuses = [[result objectForKey:@"statuses"] retain];
        NSMutableArray *readyStatuses = [[NSMutableArray alloc] initWithCapacity:20];
        for (int i=0; i<[_friendsStatuses count]; i++) {
            Status *oneStatus = [[Status alloc] init];
            NSDictionary *dic = [_friendsStatuses objectAtIndex:i];
            oneStatus.contentStr = [dic objectForKey:@"text"];
            oneStatus.authorStr = [[dic objectForKey:@"user"] objectForKey:@"screen_name"];
            oneStatus.timeStr = [dic objectForKey:@"created_at"];
            oneStatus.imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"thumbnail_pic"]]];
            oneStatus.sourceStr = [dic objectForKey:@"source"];
            [readyStatuses addObject:oneStatus];
            [oneStatus release];
        }
        [_delegate statuses:readyStatuses];
        [_delegate stopAct];
    }
    
//    NSLog(@"%@", result);
}

/*
 
 *****************************************华丽的分割线**************************************
 
 */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - SinaWeibo Delegate

// 登入之后执行
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    [self storeAuthData];
    [self getFriendsTime];
    [self getUserInfo];
}

// 等出之后执行
- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    [self removeAuthData];
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
    if ([request.url hasSuffix:@"users/show.json"])
    {
        [_userInfo release], _userInfo = nil;
    }
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        [_statuses release], _statuses = nil;
    }
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:@"Post status failed!"
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
        
        NSLog(@"Post status failed with error : %@", error);
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:@"Post image status failed!"
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
        
        NSLog(@"Post image status failed with error : %@", error);
    }
    
}


@end
