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
    [_statuses release];
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
    
	// Do any additional setup after loading the view.
    
    [self.view.layer setShadowOffset:CGSizeMake(0, 5)];
    [self.view.layer setShadowRadius:4];
    [self.view.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.view.layer setShadowOpacity:1];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:(float)247/255 green:(float)247/255 blue:(float)247/255 alpha:1];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView release];
    
    _headView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -460, 320, 460)];
    _headView.delegate = self;
    [_tableView addSubview:_headView];
    [_headView release];
    
    // 滑动手势
    UISwipeGestureRecognizer *sgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideStatuses)];
    sgr.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:sgr];
    [sgr release];
}


- (void)openApp
{
    _tableView.contentOffset = CGPointMake(0, -66);
    [self scrollViewDidEndDragging:_tableView willDecelerate:YES];
    [self getStatusesFromDatabase];
}

// 收起表格
- (void)hideStatuses
{
    [_delegate hideStatuses];
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
    [_delegate getFriendsTime];
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

#pragma mark - ASIHTTPRequest Delegate Methods
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *data = request.responseData;
    NSString *path = NSHomeDirectory();
    NSString *str = [NSString stringWithFormat:@"%@", request.url];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"tmp/%@", [str MD5Hash]]];
    BOOL res = [data writeToFile:path atomically:NO];
    if (!res) {
        NSLog(@"缓存图片失败");
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:request.tag inSection:0];
    WeiboCell *cell = (WeiboCell *)[_tableView cellForRowAtIndexPath:indexPath];
    [cell.statusImage setImage:[UIImage imageWithData:data]];
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
    }
    WeiboStatus *st = [_statuses objectAtIndex:indexPath.row];
    // 作者
    cell.labelAuthor.text = st.authorStr;
    
    // 时间
    cell.labelPostTime.text = [st getTime];
    
    // 内容
    cell.labelContent.text = st.contentStr;
    cell.labelContent.frame = [st contentRect];
    cell.labelContent.lineBreakMode = NSLineBreakByWordWrapping;
    cell.labelContent.numberOfLines = 50;
    
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
            request.cachePolicy = ASIDoNotWriteToCacheCachePolicy;
            request.delegate = self;
            request.tag = indexPath.row;
            [request startAsynchronous];
        }
    }
    cell.statusImage.frame = [st imageRect];
    
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
