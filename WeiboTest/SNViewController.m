//
//  SNViewController.m
//  sinaweibo_ios_sdk_demo
//
//  Created by Wade Cheng on 4/23/12.
//  Copyright (c) 2012 SINA. All rights reserved.
//

#import "SNViewController.h"
#import "SNAppDelegate.h"

@interface SNViewController ()

@end

@implementation SNViewController

{
    StatusesViewController *_statusesVc;
    UIView *_headView;
    UITableView *_tableView;
    NSArray *_data;
    BOOL _isHideStatuses;
}

- (void)dealloc
{
    [userInfo release]; userInfo = nil;
    [statuses release]; statuses = nil;
    [friendsStatuses release]; friendsStatuses = nil;
    [postStatusText release]; postStatusText = nil;
    [postImageStatusText release]; postImageStatusText = nil;
    [_statusesVc release];
    [_tableView release];
    [_data release];
    [super dealloc];
}

- (SinaWeibo *)sinaweibo
{
    SNAppDelegate *delegate = (SNAppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}

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


- (UIButton *)buttonWithFrame:(CGRect)frame action:(SEL)action
{
    UIImage *buttonBackgroundImage = [[UIImage imageNamed:@"button_background.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    UIImage *disabledButtonBackgroundImage = [[UIImage imageNamed:@"button_background_disabled.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    [button setBackgroundImage:disabledButtonBackgroundImage forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    return button;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isHideStatuses = NO;
    _data = [[NSArray alloc] initWithObjects:@"全部微博", @"提到你的", @"评论", @"收藏", nil];
    self.view.backgroundColor = [UIColor yellowColor];
    [self.navigationController setNavigationBarHidden:YES];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 460) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:(float)247/255 green:(float)247/255 blue:(float)247/255 alpha:1];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _headView = (UIView *)[[[NSBundle mainBundle] loadNibNamed:@"WeiboCell" owner:self options:nil] objectAtIndex:1];
    _headView.frame = CGRectMake(0, 0, 300, 100);
    
    // 我的微博
    UIView *timeLine = (UIView *)[_headView viewWithTag:9];
    UITapGestureRecognizer *timeLineTgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tgrClick:)];
    [timeLine addGestureRecognizer:timeLineTgr];
    [timeLineTgr release];
        
    _tableView.tableHeaderView = _headView;
    _tableView.backgroundColor = [UIColor whiteColor];
    
//    postStatusButton = [self buttonWithFrame:CGRectMake(20, 300, 280, 40) action:@selector(postStatusButtonPressed)];
//    [postStatusButton setTitle:@"发微博" forState:UIControlStateNormal];
//    
//    postImageStatusButton = [self buttonWithFrame:CGRectMake(20, 350, 280, 40) action:@selector(postImageStatusButtonPressed)];
//    [postImageStatusButton setTitle:@"发带图片的微博" forState:UIControlStateNormal];
    
    _statusesVc = [[StatusesViewController alloc] init];
    _statusesVc.delegate = self;
    _statusesVc.view.frame = CGRectMake(0, 0, 320, 460);
    [self.view addSubview:_statusesVc.view];
    
    UISwipeGestureRecognizer *sgrLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showStatuses)];
    sgrLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:sgrLeft];
    [sgrLeft release];
}

- (void)tgrClick:(UITapGestureRecognizer *)sender
{
    if (sender.view.tag == 9) {
        sender.view.backgroundColor = [UIColor whiteColor];
        UILabel *label = (UILabel *)[_headView viewWithTag:6];
        label.textColor = [UIColor blackColor];
        [self timelineButtonPressed];
        [self showStatuses];
    }
}

// 显示微博表格
- (void)showStatuses
{
    if (_isHideStatuses) {
        [UIView animateWithDuration:0.25 animations:^{
            _statusesVc.view.frame = CGRectMake(0, 0, 320, 460);
        }];
        _isHideStatuses = NO;
    }
}

// 隐藏微博表格
- (void)hideStatuses
{
    if (!_isHideStatuses) {
        [UIView animateWithDuration:0.25 animations:^{
            _statusesVc.view.frame = CGRectMake(300, 0, 320, 460);
        } completion:^(BOOL finished) {
            _statusesVc.tableView.contentOffset = CGPointMake(0, 0);
        }];
        _isHideStatuses = YES;
    }
}

// 开应用自动登陆
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loginButtonPressed];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    cell.textLabel.text = [_data objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:@"sub"];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self friendsTimelineButtonPressed];
        [self showStatuses];
    }
}

- (void)loginButtonPressed
{
    [userInfo release], userInfo = nil;
    [statuses release], statuses = nil;
    
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo logIn];
}

- (void)logoutButtonPressed
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo logOut];
}

- (void)friendsTimelineButtonPressed
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"statuses/friends_timeline.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
}

- (void)userInfoButtonPressed
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"users/show.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
}

- (void)timelineButtonPressed
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"statuses/user_timeline.json"
                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:sinaweibo.userID, @"uid", nil]
                   httpMethod:@"GET"
                     delegate:self];
}

static int post_status_times = 0;
- (void)postStatusButtonPressed
{
    if (!postStatusText)
    {
        post_status_times ++;
        [postStatusText release], postStatusText = nil;
        postStatusText = [[NSString alloc] initWithFormat:@"test post status : %i %@", post_status_times, [NSDate date]];
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:[NSString stringWithFormat:@"Will post status with text \"%@\"", postStatusText]
                                                       delegate:self cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
    alertView.tag = 0;
    [alertView show];
    [alertView release];
}

static int post_image_status_times = 0;
- (void)postImageStatusButtonPressed
{
    if (!postImageStatusText)
    {
        post_image_status_times ++;
        [postImageStatusText release], postImageStatusText = nil;
        postImageStatusText = [[NSString alloc] initWithFormat:@"test post image status : %i %@", post_image_status_times, [NSDate date]];
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:[NSString stringWithFormat:@"Will post image status with text \"%@\"", postImageStatusText]
                                                       delegate:self cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
    alertView.tag = 1;
    [alertView show];
    [alertView release];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if (alertView.tag == 0)
        {
            // post status
            SinaWeibo *sinaweibo = [self sinaweibo];
            [sinaweibo requestWithURL:@"statuses/update.json"
                               params:[NSMutableDictionary dictionaryWithObjectsAndKeys:postStatusText, @"status", nil]
                           httpMethod:@"POST"
                             delegate:self];
            
        }
        else if (alertView.tag == 1)
        {
            // post image status
            SinaWeibo *sinaweibo = [self sinaweibo];
            
            [sinaweibo requestWithURL:@"statuses/upload.json"
                               params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       postImageStatusText, @"status",
                                       [UIImage imageNamed:@"logo.png"], @"pic", nil]
                           httpMethod:@"POST"
                             delegate:self];
            
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    [self storeAuthData];
    NSLog(@"1");
    [self friendsTimelineButtonPressed];
    [self userInfoButtonPressed];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    [self removeAuthData];
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
//    NSLog(@"sinaweiboLogInDidCancel");
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
    [self removeAuthData];
}

#pragma mark - SinaWeiboRequest Delegate

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"users/show.json"])
    {
        [userInfo release], userInfo = nil;
    }
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        [statuses release], statuses = nil;
    }
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post status \"%@\" failed!", postStatusText]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
        
        NSLog(@"Post status failed with error : %@", error);
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post image status \"%@\" failed!", postImageStatusText]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
        
        NSLog(@"Post image status failed with error : %@", error);
    }
    
}

// 返回结果
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"users/show.json"])
    {
        [userInfo release];
        userInfo = [result retain];
        // 名字
        UILabel *userName = (UILabel *)[_headView viewWithTag:2];
        userName.text = [userInfo objectForKey:@"screen_name"];
        
        // 头像
        UIImageView *photo = (UIImageView *)[_headView viewWithTag:1];
        photo.layer.cornerRadius = 23;
        photo.layer.masksToBounds = YES;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[userInfo objectForKey:@"profile_image_url"]]];
        [photo setImage:[UIImage imageWithData:data]];
        
        // 所在地
        UILabel *userLocation = (UILabel *)[_headView viewWithTag:3];
        userLocation.text = [userInfo objectForKey:@"location"];
        
        // 关注
        UILabel *userFriendsCount = (UILabel *)[_headView viewWithTag:4];
        userFriendsCount.text = [NSString stringWithFormat:@"%@", [userInfo objectForKey:@"friends_count"]];

        // 粉丝
        UILabel *userFollowersCount = (UILabel *)[_headView viewWithTag:5];
        userFollowersCount.text = [NSString stringWithFormat:@"%@", [userInfo objectForKey:@"followers_count"]];
        
        // 微博
        UILabel *userStatusesCount = (UILabel *)[_headView viewWithTag:6];
        userStatusesCount.text = [NSString stringWithFormat:@"%@", [userInfo objectForKey:@"statuses_count"]];
    }
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        [statuses release];
        statuses = [[result objectForKey:@"statuses"] retain];
        [_statusesVc updateData:statuses];
    }
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post status \"%@\" succeed!", [result objectForKey:@"text"]]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
        
        [postStatusText release], postStatusText = nil;
    }else if ([request.url hasSuffix:@"statuses/friends_timeline.json"]){
        [friendsStatuses release];
        friendsStatuses = [[result objectForKey:@"statuses"] retain];
        [_statusesVc updateData:friendsStatuses];
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post image status \"%@\" succeed!", [result objectForKey:@"text"]]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
        
        [postImageStatusText release], postImageStatusText = nil;
    }
//    NSLog(@"%@", result);
}

@end
