//
//  DisplayViewController.m
//  WeiboTest
//
//  Created by lucas on 5/5/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import "DisplayViewController.h"
#import "WeiboCell.h"
#import "Status.h"
#import "SNNetAccess.h"

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
    
    UISwipeGestureRecognizer *sgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(sgrSlider)];
    sgr.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:sgr];
    [sgr release];
}



- (void)firstUpdate
{
    _tableView.contentOffset = CGPointMake(0, -66);
    [self scrollViewDidEndDragging:_tableView willDecelerate:YES];
}

// 收起表格
- (void)sgrSlider
{
    [_delegate hideStatuses];
}

// 更新数据
- (void)updateData:(NSArray *)array
{
    self.statuses = array;
    [_tableView reloadData];
    
    int i = 0;
    for (Status *st in _statuses) {
        if (st.imgStr) {
            NSURL *url = [NSURL URLWithString:st.imgStr];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            request.delegate = self;
            request.tag = i;
            [request startAsynchronous];
        }
        i++;
    }
    _tableView.contentOffset = CGPointMake(0, 0);
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
    SNNetAccess *netAccess = [SNNetAccess sharedNetAccess];
    [netAccess getFriendsTime];
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
    Status *st = [_statuses objectAtIndex:request.tag];
    st.imgData = data;
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
    WeiboCell *cell = [[[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
    if (!cell) {
        cell = (WeiboCell *)[[[NSBundle mainBundle] loadNibNamed:@"WeiboCell" owner:self options:nil] objectAtIndex:0];
    }
    Status *st = [_statuses objectAtIndex:indexPath.row];
    // 作者
    cell.labelAuthor.text = [st authorStr];
    
    // 时间
    cell.labelPostTime.text = [st timeStr];
    
    // 内容
    cell.labelContent.text = [st contentStr];
    cell.labelContent.frame = [st contentRect];
    cell.labelContent.lineBreakMode = NSLineBreakByWordWrapping;
    cell.labelContent.numberOfLines = 50;
    
    // 图片
    cell.statusImage.image = [UIImage imageWithData:[st imgData]];
    cell.statusImage.frame = [st imageRect];
    
    // 来源
    cell.labelPostSource.text = [st getSourceStr];
    cell.labelPostSource.frame = [st sourceRect];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Status *st = [_statuses objectAtIndex:indexPath.row];
    return [st heightForRow];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
