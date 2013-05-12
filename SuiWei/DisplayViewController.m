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

@interface DisplayViewController ()

@property (nonatomic, retain) NSArray *statuses;

@end

@implementation DisplayViewController

{
    EGORefreshTableHeaderView *_headView;
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
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView release];
    
    _headView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -460, 320, 460)];
    _headView.delegate = self;
    [_tableView addSubview:_headView];
    [_headView release];
    
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
    [_headView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
    _isReflesh = NO;
}

#pragma mark - RefleshHeadView Delegate Methods
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _isReflesh;
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self getFriendsStatuses];
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
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_headView egoRefreshScrollViewDidScroll:scrollView];
    
}

#pragma mark - Weibo Delegate Methods
- (SinaWeibo *)sinaweibo
{
    SNAppDelegate *delegate = (SNAppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}

// 全部微博
- (void)getFriendsStatuses
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
    NSLog(@"send friends_timeline.json");
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"get friends_timeline failed");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
    NSLog(@"get friends_timeline success");
}

#pragma mark - ASIHTTPRequest Delegate Methods
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *data = request.responseData;
    NSString *path = NSHomeDirectory();
    NSString *urlStr = [NSString stringWithFormat:@"%@", request.url];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"tmp/%@", [urlStr MD5Hash]]];
    BOOL res = [data writeToFile:path atomically:NO];
    if (!res) {
        NSLog(@"缓存图片失败");
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:request.tag inSection:0];
    WeiboCell *cell = (WeiboCell *)[_tableView cellForRowAtIndexPath:indexPath];
    WeiboStatus *status = [_statuses objectAtIndex:request.tag];
    if (status.imgStr) {
        [cell.statusImage setImage:[UIImage imageWithData:data]];
    }else{
        [cell.retweetImageView setImage:[UIImage imageWithData:data]];
    }

}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"get img failed");
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
    
    cell.labelAuthor.text = st.authorStr;
    cell.labelPostTime.text = [st getTime];
    cell.labelContent.text = st.contentStr;
    cell.labelContent.frame = [st contentRect];
    
    // 图片
    cell.statusImage.image = nil;
    if (st.imgStr) {
        NSString *path = NSHomeDirectory();
        path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"tmp/%@", [st.imgStr MD5Hash]]];
        NSFileManager *fm = [NSFileManager defaultManager];
        BOOL res = [fm fileExistsAtPath:path];
        if (res) {
            cell.statusImage.image = [UIImage imageWithContentsOfFile:path];
        }else{
            NSURL *url = [NSURL URLWithString:st.imgStr];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            request.cachePolicy = ASIDoNotWriteToCacheCachePolicy | ASIDoNotReadFromCacheCachePolicy;
            request.delegate = self;
            request.tag = indexPath.row;
            [request startAsynchronous];
        }
    }
    cell.statusImage.frame = [st imageRect];
    
    cell.labelRetweetContent.text = [NSString stringWithFormat:@"@%@:%@", st.reAuthorStr, st.reContentStr];
    cell.labelRetweetContent.frame = [st retweetContentRect];
    
    cell.retweetImageView.image = nil;
    if (st.reImageStr) {
        NSString *path = NSHomeDirectory();
        path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"tmp/%@", [st.reImageStr MD5Hash]]];
        NSFileManager *fm = [NSFileManager defaultManager];
        BOOL res = [fm fileExistsAtPath:path];
        if (res) {
            cell.retweetImageView.image = [UIImage imageWithContentsOfFile:path];
        }else{
            NSURL *url = [NSURL URLWithString:st.reImageStr];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            request.cachePolicy = ASIDoNotWriteToCacheCachePolicy | ASIDoNotReadFromCacheCachePolicy;
            request.delegate = self;
            request.tag = indexPath.row;
            [request startAsynchronous];
        }
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
