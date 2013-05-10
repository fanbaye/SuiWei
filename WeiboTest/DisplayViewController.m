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

@interface DisplayViewController ()

@end

@implementation DisplayViewController

{
    UIView *_headView;
    UIActivityIndicatorView *_act;
    UILabel *_reflashLabel;
}

@synthesize tableView = _tableView;
@synthesize statuses = _statuses;
@synthesize delegate = _delegate;

- (void)dealloc
{
    [_tableView release];
    [_statuses release];
    [_headView release];
    [_act release];
    [_reflashLabel release];
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
    
    _headView = [[UIView alloc] init];
    _headView.frame = CGRectMake(0, 0, 320, 70);
//    _headView.backgroundColor = [UIColor yellowColor];
    _act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _act.frame = CGRectMake(90, 20+16, 0, 0);
    [_headView addSubview:_act];
    
    _reflashLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 20, 100, 30)];
    _reflashLabel.backgroundColor = [UIColor clearColor];
    _reflashLabel.text = @"正在更新";
    [_headView addSubview:_reflashLabel];
    
    _statuses = [[NSArray alloc] init];
    
    UISwipeGestureRecognizer *sgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(sgrSlider)];
    sgr.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:sgr];
    [sgr release];
}

- (void)startAct
{
    _tableView.tableHeaderView = _headView;
    [_act startAnimating];
}

- (void)stopAct
{
    [_act stopAnimating];
    [_headView removeFromSuperview];
    _tableView.tableHeaderView = nil;
}

- (void)sgrSlider
{
    [_delegate hideStatuses];
}

- (void)updateData:(NSArray *)array
{
    _statuses = array;
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_statuses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    WeiboCell *cell = (WeiboCell *)[tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = (WeiboCell *)[[[NSBundle mainBundle] loadNibNamed:@"WeiboCell" owner:self options:nil] objectAtIndex:0];
    }
    Status *st = [_statuses objectAtIndex:indexPath.row];
    cell.author.text = [st authorStr];
    
    cell.time.text = [st timeStr];
    
    cell.content.text = [st contentStr];
    cell.content.frame = CGRectMake(10, cell.content.frame.origin.y, [st contentSize].width, [st contentSize].height);
    cell.content.lineBreakMode = NSLineBreakByWordWrapping;
    cell.content.numberOfLines = 50;
    
    cell.img.image = [UIImage imageWithData:[st imgData]];
    cell.img.frame = [st imageRect];
    
    cell.source.text = [st getSourceStr];
    cell.source.frame = [st sourceRect];
    
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
