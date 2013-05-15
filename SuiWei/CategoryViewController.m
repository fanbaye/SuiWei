//
//  CategoryViewController.m
//  WeiboTest
//
//  Created by lucas on 5/5/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import "CategoryViewController.h"
#import "DisplayViewController.h"
#import "PostViewController.h"
#import "WeiboStatus.h"
#import "SNAppDelegate.h"
#import "DatabaseManager.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "TableHeadView.h"
#import "CategoryCell.h"

@interface CategoryViewController ()

@end

@implementation CategoryViewController

{
    TableHeadView *_headView;
    UITableView *_tableView;
    NSArray *_dataArray;
    NSArray *_imageArray;
    PostViewController *_postvc;
    DisplayViewController *_displayvc;
    
    BOOL _isFirstAppear;
    BOOL _isHideStatusesPanel;
}

- (void)dealloc
{
    [_dataArray release];
    [_imageArray release];
    [_postvc release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isFirstAppear = YES;
    _isHideStatusesPanel = NO;
	// Do any additional setup after loading the view.
    
    // 底部设置按钮
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn setImage:[UIImage imageNamed:@"categorySettingBottom"] forState:UIControlStateNormal];
    settingBtn.frame = CGRectMake(0, 412, 320, 48);
    [settingBtn addTarget:self action:@selector(settingClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingBtn];
    
    _displayvc = [[DisplayViewController alloc] init];
    _displayvc.view.frame = CGRectMake(0, 0, 320, 460);
    _displayvc.delegate = self;
    [self addChildViewController:_displayvc];
    [self.view addSubview:_displayvc.view];
    [_displayvc release];
    
    _postvc = [[PostViewController alloc] init];
    
    NSArray *sectionOne = [NSArray arrayWithObjects:@"全部微博", @"提到你的", @"评论", @"收藏", nil];
    NSArray *sectionTwo = [NSArray arrayWithObjects:@"好友", @"娱乐", @"陌生人", @"秘密关注", nil];
    _dataArray = [[NSArray alloc] initWithObjects:sectionOne, sectionTwo, nil];
    
    sectionOne = [NSArray arrayWithObjects:@"home.png", @"at.png", @"comment.png", @"favourite.png", nil];
    sectionTwo = [NSArray arrayWithObjects:@"home.png", @"at.png", @"comment.png", @"favourite.png", nil];
    _imageArray = [[NSArray alloc] initWithObjects:sectionOne, sectionTwo, nil];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460) style:UITableViewStylePlain];
    _tableView.scrollsToTop = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithRed:36.0/255.0 green:36.0/255.0 blue:36.0/255.0 alpha:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView release];
    
    /*headView begin*/
    _headView = [[TableHeadView alloc] initWithFrame:CGRectMake(0, 0, 320, 126)];
    
    _headView.userPhoto.layer.cornerRadius = 25;
    _headView.userPhoto.layer.masksToBounds = YES;
    
    [_headView.userPhoto setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userPhoto"]]];
    SDImageCache *imageCache = [[SDImageCache alloc] init];
    [_postvc setUserImage:[imageCache imageFromKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"userPhoto"]]];
    [imageCache release];
    
    _headView.userPhoto.userInteractionEnabled = YES;
    UITapGestureRecognizer *photoTgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tgrClick:)];
    [_headView.userPhoto addGestureRecognizer:photoTgr];
    [photoTgr release];
    
    UITapGestureRecognizer *timeLineTgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tgrClick:)];
    [_headView.userStatusesView addGestureRecognizer:timeLineTgr];
    [timeLineTgr release];
    
    [_headView.editButton addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView.tableHeaderView = _headView;
    
    [self.view sendSubviewToBack:_tableView];
    /*headView end*/
    
    // 滑动手势 - 展开微博table
    UISwipeGestureRecognizer *sgrLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showStatusesPanel)];
    sgrLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:sgrLeft];
    [sgrLeft release];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_isFirstAppear) {
        [UIView animateWithDuration:0.2 animations:^{
            _displayvc.view.frame = CGRectMake(300, 0, 320, 460);
        }];
    }else{
        [self login];
        _isFirstAppear = NO;
    }
}

- (void)settingClick
{
    NSLog(@"暂无功能");
}

- (void)editClick
{
    [UIView animateWithDuration:0.2 animations:^{
        _displayvc.view.frame = CGRectMake(320, 0, 320, 460);
    }];
    [self presentViewController:_postvc animated:YES completion:^{
        [_postvc.editTextView becomeFirstResponder];
    }];
}

- (void)tgrClick:(UISwipeGestureRecognizer *)sender
{
    if (sender.view.tag == 1){
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登录" otherButtonTitles:nil, nil];
        as.delegate = self;
        as.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [as showInView:self.view];
        [as release];
    }else if (sender.view.tag == 9) {
        _headView.userStatusesCountLabel.textColor = [UIColor blackColor];
        sender.view.backgroundColor = [UIColor whiteColor];
    }
}

- (void)updateUserInfo:(NSDictionary *)userInfo
{
    
    // 头像
    [_headView.userPhoto setImageWithURL:[NSURL URLWithString:[userInfo objectForKey:@"profile_image_url"]]];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[userInfo objectForKey:@"profile_image_url"] forKey:@"userPhoto"];
    [ud synchronize];
    
    SDImageCache *imageCache = [[SDImageCache alloc] init];
    [_postvc setUserImage:[imageCache imageFromKey:[userInfo objectForKey:@"profile_image_url"]]];
    [imageCache release];
    
    
    // 名字
    _headView.userNameLabel.text = [userInfo objectForKey:@"screen_name"];

    
    // 所在地
    _headView.userCityLabel.text = [userInfo objectForKey:@"location"];
    
    // 关注
    _headView.userFriendsCountLabel.text = [NSString stringWithFormat:@"%@", [userInfo objectForKey:@"friends_count"]];
    
    // 粉丝
    _headView.userFollowersCountLabel.text = [NSString stringWithFormat:@"%@", [userInfo objectForKey:@"followers_count"]];
    
    // 微博
    _headView.userStatusesCountLabel.text = [NSString stringWithFormat:@"%@", [userInfo objectForKey:@"statuses_count"]];
}

#pragma mark - UIActionSheet Delegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        SinaWeibo *sinaweibo = [self sinaweibo];
        [sinaweibo logOut];
    }
}

#pragma mark - TableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[[CategoryCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName] autorelease];
    }
    
    cell.category.text = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.icon.image = [UIImage imageNamed:[[_imageArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 0) {
        [self showStatusesPanel];
    }else if (indexPath.row == 0 && indexPath.section == 1){
        DatabaseManager *db = [[DatabaseManager alloc] init];
        [db databaseDropTable];
        [db databaseClose];
        [db release];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fenzu"]] autorelease];
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 1) {
        return 0;
    }else{
        return 22;
    }
}

/* 显示和隐藏微博表格 begin*/
- (void)showStatusesPanel
{
    if (_isHideStatusesPanel) {
        [UIView animateWithDuration:0.2 animations:^{
            _displayvc.view.frame = CGRectMake(0, 0, 320, 460);
        }];
        _isHideStatusesPanel = NO;
    }
}

- (void)hideStatusesPanel
{
    if (!_isHideStatusesPanel) {
        [UIView animateWithDuration:0.2 animations:^{
            _displayvc.view.frame = CGRectMake(280, 0, 320, 460);
        }];
        _isHideStatusesPanel = YES;
    }
}
/* 显示和隐藏微博表格 end*/

#pragma mark - Setting Weibo
- (SinaWeibo *)sinaweibo
{
    SNAppDelegate *delegate = (SNAppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}

// 移除用户数据
- (void)removeAuthData
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"SinaWeiboAuthData"];
    [ud removeObjectForKey:@"userPhoto"];
    [ud synchronize];
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


#pragma mark - SinaWeibo Delegate

// 登入之后执行
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    [self storeAuthData];
    [self getUserInfo];
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

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"get userInfo failed");

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    [self updateUserInfo:result];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"get userInfo success");
}

@end
