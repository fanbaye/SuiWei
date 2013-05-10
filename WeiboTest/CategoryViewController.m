//
//  CategoryViewController.m
//  WeiboTest
//
//  Created by lucas on 5/5/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import "CategoryViewController.h"
#import "SNNetAccess.h"
#import "SNAppDelegate.h"

@interface CategoryViewController ()

@end

@implementation CategoryViewController

{
    UIView *_headView;
    UITableView *_tableView;
    NSArray *_data;
    BOOL _isHideStatuses;
}
@synthesize delegate = _delegate;

- (void)dealloc
{
    [_tableView release];
    [_data release];
    [_delegate release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isHideStatuses = NO;
    
    NSArray *array1 = [[NSArray alloc] initWithObjects:@"全部微博", @"提到你的", @"评论", @"收藏", nil];
    NSArray *array2 = [[NSArray alloc] initWithObjects:@"好友", @"娱乐", @"秘密关注", nil];
    _data = [[NSArray alloc] initWithObjects:array1, array2, nil];
    [array1 release];
    [array2 release];
    
    self.view.backgroundColor = [UIColor yellowColor];
    [self.navigationController setNavigationBarHidden:YES];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 460) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:(float)247/255 green:(float)247/255 blue:(float)247/255 alpha:1];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
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
}

- (void)editClick
{
    [_delegate showEdit];
}

- (void)tgrClick:(UISwipeGestureRecognizer *)sender
{
    if (sender.view.tag == 9) {
        UILabel *label = (UILabel *)[_headView viewWithTag:6];
        label.textColor = [UIColor blackColor];
        
        sender.view.backgroundColor = [UIColor whiteColor];
        
        SNNetAccess *netAccess = [SNNetAccess sharedNetAccess];
        [netAccess getTimeline];
        [_delegate showStatuses];
    }else if (sender.view.tag == 1){
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登录" otherButtonTitles:nil, nil];
        as.delegate = self;
        as.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [as showInView:self.view];
    }
}

#pragma mark - UIActionSheet Delegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        SNAppDelegate *snDelegate = (SNAppDelegate *)[UIApplication sharedApplication].delegate;
        SinaWeibo *sinaweibo = snDelegate.sinaweibo;
        [sinaweibo logOut];
    }
}

- (void)updateUserInfo:(NSDictionary *)userInfo
{
    // 名字
    UILabel *userName = (UILabel *)[_headView viewWithTag:2];
    userName.text = [userInfo objectForKey:@"screen_name"];
    
    // 头像
    UIImageView *photo = (UIImageView *)[_headView viewWithTag:1];
    photo.layer.cornerRadius = 23;
    photo.layer.masksToBounds = YES;
    [photo setImage:[UIImage imageWithData:
                     [NSData dataWithContentsOfURL:
                      [NSURL URLWithString:
                       [userInfo objectForKey:@"profile_image_url"]]]]];
    
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

#pragma mark - TableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_data objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    cell.textLabel.text = [[_data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:@"sub"];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
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
        SNNetAccess *netAccess = [SNNetAccess sharedNetAccess];
        [netAccess getFriendsTime];
        [_delegate showStatuses];
    }
}

@end
