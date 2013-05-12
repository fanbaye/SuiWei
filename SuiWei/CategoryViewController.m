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

@interface CategoryViewController ()

@end

@implementation CategoryViewController

{
    UIView *_headView;
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
    
    _displayvc = [[DisplayViewController alloc] init];
    _displayvc.view.frame = CGRectMake(0, 0, 320, 460);
    _displayvc.delegate = self;
    [self addChildViewController:_displayvc];
    [self.view addSubview:_displayvc.view];
    [_displayvc release];
    
    _postvc = [[PostViewController alloc] init];
    
    NSArray *sectionOne = [NSArray arrayWithObjects:@"全部微博", @"提到你的", @"评论", @"收藏", nil];
    NSArray *sectionTwo = [NSArray arrayWithObjects:@"好友", @"娱乐", @"秘密关注", nil];
    _dataArray = [[NSArray alloc] initWithObjects:sectionOne, sectionTwo, nil];
    
    sectionOne = [NSArray arrayWithObjects:@"home.png", @"at.png", @"comment.png", @"favourite.png", nil];
    sectionTwo = [NSArray arrayWithObjects:@"home.png", @"at.png", @"comment.png", nil];
    _imageArray = [[NSArray alloc] initWithObjects:sectionOne, sectionTwo, nil];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 460) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:(float)247/255
                                                 green:(float)247/255
                                                  blue:(float)247/255
                                                 alpha:1];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView release];
    
    /*headView begin*/
    _headView = (UIView *)[[[NSBundle mainBundle] loadNibNamed:@"headView" owner:self options:nil] objectAtIndex:0];
    _headView.frame = CGRectMake(0, 0, 300, 100);
    
    UIImageView *photo = (UIImageView *)[_headView viewWithTag:1];
    photo.userInteractionEnabled = YES;
    UITapGestureRecognizer *photoTgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tgrClick:)];
    [photo addGestureRecognizer:photoTgr];
    [photoTgr release];
    
    UIView *timeLine = (UIView *)[_headView viewWithTag:9];
    UITapGestureRecognizer *timeLineTgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tgrClick:)];
    [timeLine addGestureRecognizer:timeLineTgr];
    [timeLineTgr release];
    
    UIButton *edit = (UIButton *)[_headView viewWithTag:10];
    [edit addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView.tableHeaderView = _headView;
    _tableView.backgroundColor = [UIColor whiteColor];
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
        UILabel *label = (UILabel *)[_headView viewWithTag:6];
        label.textColor = [UIColor blackColor];
        sender.view.backgroundColor = [UIColor whiteColor];
    }
}

- (void)updateUserInfo:(NSDictionary *)userInfo
{
    
    // 头像
    UIImageView *userImageView = (UIImageView *)[_headView viewWithTag:1];
    userImageView.layer.cornerRadius = 23;
    userImageView.layer.masksToBounds = YES;
    UIImage *image = [UIImage imageWithData:
                      [NSData dataWithContentsOfURL:
                       [NSURL URLWithString:
                        [userInfo objectForKey:@"profile_image_url"]]]];
    [userImageView setImage:image];
    _postvc.userImage = image;
    
    // 名字
    UILabel *userName = (UILabel *)[_headView viewWithTag:2];
    userName.text = [userInfo objectForKey:@"screen_name"];

    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName] autorelease];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    cell.textLabel.text = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[[_imageArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"好友分组";
    }else{
        return nil;
    }
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
            _displayvc.view.frame = CGRectMake(300, 0, 320, 460);
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
