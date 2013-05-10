//
//  StatusesViewController.m
//  WeiboTest
//
//  Created by lucas on 5/4/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import "StatusesViewController.h"
#import "WeiboCell.h"

@interface StatusesViewController ()

@end

@implementation StatusesViewController

@synthesize tableView = _tableView;
@synthesize statuses = _statuses;
@synthesize delegate = _delegate;

- (void)dealloc
{
    [_tableView release];
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
    
    _statuses = [[NSArray alloc] init];
    
    UISwipeGestureRecognizer *sgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(sgrSlider)];
    sgr.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:sgr];
    [sgr release];
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
    
    NSDictionary *info = [_statuses objectAtIndex:indexPath.row];
    // 内容
    cell.content.text = [info objectForKey:@"text"];
    CGSize size = [[info objectForKey:@"text"] sizeWithFont:cell.content.font constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    cell.content.frame = CGRectMake(cell.content.frame.origin.x, cell.content.frame.origin.y, size.width, size.height);
    cell.content.numberOfLines = 1000;
    
    // 作者
    cell.author.text = [[info objectForKey:@"user"] objectForKey:@"screen_name"];
    
    // 时间
    cell.time.text = [info objectForKey:@"created_at"];
    
    // 图片
    float imgHeight = 0;
    if ([info objectForKey:@"thumbnail_pic"]) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[info objectForKey:@"thumbnail_pic"] copy]]];
        [cell.img setImage:[UIImage imageWithData:data]];
        cell.img.frame = CGRectMake(10, cell.content.frame.origin.y+size.height+5, cell.img.frame.size.width, cell.img.frame.size.height);
        imgHeight = cell.img.frame.origin.y+cell.img.frame.size.height+5;
//        NSLog(@"%@", data);
    }else{
        [cell.img removeFromSuperview];
        imgHeight = cell.content.frame.origin.y+size.height+5;
    }
    
    // 来源
    cell.source.frame = CGRectMake(10, imgHeight, cell.source.frame.size.width, cell.source.frame.size.height);
    cell.source.text = @"来自：";
    cell.source.text = [cell.source.text stringByAppendingString:[self getSource:[info objectForKey:@"source"]]];
    return cell;
}

- (NSString *)getSource:(NSString *)source
{
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
    NSArray *array = [source componentsSeparatedByCharactersInSet:set];
    return [array objectAtIndex:2];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboCell *cell = (WeiboCell *)[[[NSBundle mainBundle] loadNibNamed:@"WeiboCell" owner:self options:nil] objectAtIndex:0];
    CGSize size = [[[_statuses objectAtIndex:indexPath.row] objectForKey:@"text"] sizeWithFont:cell.content.font constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    float imgHeight = 0;
    if ([[_statuses objectAtIndex:indexPath.row] objectForKey:@"thumbnail_pic"]) {
        imgHeight = 80+5;
    }
    return cell.content.frame.origin.y+size.height+5+imgHeight+21+10;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
