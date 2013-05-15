//
//  DisplayViewController.m
//  WeiboTest
//
//  Created by lucas on 5/5/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import "DisplayViewController.h"
#import "WeiboCell.h"
#import "WeiboStatus.h"
#import "DatabaseManager.h"
#import "NSString+Hashing.h"
#import "SNAppDelegate.h"
#import "UIImageView+WebCache.h"

@interface DisplayViewController ()

@property (nonatomic, retain) NSArray *statuses;

@end

@implementation DisplayViewController

{
    EGORefreshTableHeaderView *_headView;
    YZYRefreshTableFooterView *_footView;
    BOOL _isReflesh;
    UITableView *_tableView;
}

@synthesize delegate = _delegate;
@synthesize statuses = _statuses;

- (void)dealloc
{
    self.statuses = nil;
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
    _isReflesh = NO;
    
    // 设置圆角和阴影
    [self.view.layer setShadowOffset:CGSizeMake(0, 5)];
    [self.view.layer setShadowRadius:4];
    [self.view.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.view.layer setShadowOpacity:1];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:(float)247/255
                                                 green:(float)247/255
                                                  blue:(float)247/255
                                                 alpha:1];
    _tableView.scrollsToTop = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView release];
    
    _headView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -460, 320, 460)];
    _headView.delegate = self;
    [_tableView addSubview:_headView];
    [_headView release];
    
    _footView = [[YZYRefreshTableFooterView alloc] initWithFrame:CGRectMake(0, 460, 320, 460)];
    _footView.delegate = self;
    [_tableView addSubview:_footView];
    [_footView release];
    
    // 滑动手势 - 隐藏table
    UISwipeGestureRecognizer *sgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideStatusesPanel)];
    sgr.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:sgr];
    [sgr release];
    
    // 读取数据库
    [self getStatusesFromDatabase];
}

// 隐藏talbe
- (void)hideStatusesPanel
{
    [_delegate hideStatusesPanel];
}

// 得到数据库的微博
- (void)getStatusesFromDatabase
{
    DatabaseManager *db = [[DatabaseManager alloc] init];
    self.statuses = [db databaseAllStatuses];
    [db databaseClose];
    [db release];
    [_tableView reloadData];
}

// 更新数据
- (void)updateData
{
    [self getStatusesFromDatabase];
    
    _isReflesh = NO;
}

- (void)freshScrollViewDataSourceDidFinishedLoading
{
    [_headView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
    [_footView yzyRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
    _footView.hidden = YES;
}

#pragma mark - RefleshFootView Delegate Methods
- (BOOL)yzyRefreshTableFooterDataSourceIsLoading:(YZYRefreshTableFooterView *)view
{
    return _isReflesh;
}

- (NSDate *)yzyRefreshTableFooterDataSourceLastUpdated:(YZYRefreshTableFooterView *)view
{
    return [NSDate date];
}

- (void)yzyRefreshTableFooterDidTriggerRefresh:(YZYRefreshTableFooterView *)view
{
    [self getFriendsStatuses:NO];
    _isReflesh = YES;
}

#pragma mark - RefleshHeadView Delegate Methods
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _isReflesh;
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self getFriendsStatuses:YES];
    _isReflesh = YES;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}


#pragma mark - ScrollView Methods
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_headView egoRefreshScrollViewDidEndDragging:scrollView];
    _footView.hidden = NO;
    [_footView yzyRefreshScrollViewDidEndDragging:scrollView];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_headView egoRefreshScrollViewDidScroll:scrollView];
    [_footView yzyRefreshScrollViewDidScroll:scrollView];
}

#pragma mark - Weibo Delegate Methods
- (SinaWeibo *)sinaweibo
{
    SNAppDelegate *delegate = (SNAppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}

// 全部微博
- (void)getFriendsStatuses:(BOOL)max
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    DatabaseManager *db = [[DatabaseManager alloc] init];
    NSString *Id = [db databaseGetId:max];
    SinaWeibo *sinaweibo = [self sinaweibo];
    NSString *prama;
    if (max) {
        prama = @"since_id";
    }else{
        prama = @"max_id";
        Id = [NSString stringWithFormat:@"%lld", [Id longLongValue]-1];
    }
    
    [sinaweibo requestWithURL:@"statuses/friends_timeline.json"
                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:sinaweibo.userID, @"uid",Id , prama, @"5", @"count", nil]
                   httpMethod:@"GET"
                     delegate:self];
    [db databaseClose];
    [db release];
    NSLog(@"send friends_timeline.json");
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"get friends_timeline failed");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self freshScrollViewDataSourceDidFinishedLoading];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    DatabaseManager *db = [[DatabaseManager alloc] init];
    NSArray *statuses = [[result objectForKey:@"statuses"] retain];
    for (NSDictionary *dic in statuses) {
        WeiboStatus *status = [[WeiboStatus alloc] init];
        status.contentStr = [dic objectForKey:@"text"];
        status.authorStr = [[dic objectForKey:@"user"] objectForKey:@"screen_name"];
        status.timeStr = [dic objectForKey:@"created_at"];
        status.imgStr = [dic objectForKey:@"thumbnail_pic"];
        status.sourceStr = [dic objectForKey:@"source"];
        status.idStr = [dic objectForKey:@"idstr"];
        status.authorImageStr = [[dic objectForKey:@"user"] objectForKey:@"profile_image_url"];
        status.commentsStr = [dic objectForKey:@"comments_count"];
        status.repostsStr = [dic objectForKey:@"reposts_count"];
        NSDictionary *reDic = [dic objectForKey:@"retweeted_status"];
        if (dic) {
            status.reAuthorStr = [[reDic objectForKey:@"user"] objectForKey:@"screen_name"];
            status.reContentStr = [reDic objectForKey:@"text"];
            status.reImageStr = [reDic objectForKey:@"thumbnail_pic"];
        }else{
            status.reImageStr = nil;
            status.reContentStr = nil;
            status.reAuthorStr = nil;
        }
        [db databaseInsert:status];
        [status release];
    }
    [db databaseClose];
    [db release];
    [statuses release];
    
    [self updateData];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self freshScrollViewDataSourceDidFinishedLoading];
    NSLog(@"get friends_timeline success");
}

#pragma mark - TableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_statuses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell =  [[[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    WeiboStatus *st = [_statuses objectAtIndex:indexPath.row];
    
    [cell.authorImageView setImageWithURL:[NSURL URLWithString:st.authorImageStr]];
    cell.labelAuthor.text = st.authorStr;
    cell.labelPostTime.text = [st getTime];
    cell.labelComments.text = st.commentsStr;
    cell.labelReports.text = st.repostsStr;
    cell.labelContent.text = st.contentStr;
    cell.labelContent.frame = [st contentRect];
    cell.leftLine.frame = [st leftLineRect];
    
    // 图片
    cell.statusImage.image = nil;
    if (st.imgStr) {
        [cell.statusImage setImageWithURL:[NSURL URLWithString:st.imgStr]];
    }
    cell.statusImage.frame = [st imageRect];
    
    // 转发的内容
    cell.labelRetweetContent.text = [NSString stringWithFormat:@"@%@:%@", st.reAuthorStr, st.reContentStr];
    cell.labelRetweetContent.frame = [st retweetContentRect];
    
    // 转发的图片
    cell.retweetImageView.image = nil;
    if (st.reImageStr) {
        [cell.retweetImageView setImageWithURL:[NSURL URLWithString:st.reImageStr]];
    }
    cell.retweetImageView.frame = [st retweetImageRect];
    
    // 来源
    cell.labelPostSource.text = [st getSource];
    cell.labelPostSource.frame = [st sourceRect];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboStatus *st = [_statuses objectAtIndex:indexPath.row];
    return [st heightForRow];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
