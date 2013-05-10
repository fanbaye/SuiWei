//
//  Status.m
//  WeiboTest
//
//  Created by lucas on 5/5/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import "WeiboStatus.h"
#import "WeiboCell.h"

@implementation WeiboStatus

@synthesize contentStr = _contentStr;
@synthesize authorStr = _authorStr;
@synthesize timeStr = _timeStr;
@synthesize imgStr = _imgStr;
@synthesize sourceStr = _sourceStr;
@synthesize idStr = _idStr;

- (void)dealloc
{
    self.contentStr = nil;
    self.authorStr = nil;
    self.timeStr = nil;
    self.imgStr = nil;
    self.sourceStr = nil;
    self.idStr = nil;
    [super dealloc];
}

- (NSString *)getTime
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE MMM dd HH:mm:ss +S yyyy"];
    NSDate *date = [dateFormat dateFromString:_timeStr];
    [dateFormat release];
    NSTimeInterval timeInterval = [date timeIntervalSinceNow];
    timeInterval = -timeInterval;
    NSString *time = nil;
    if (timeInterval < 10) {
        time = @"10秒前";
    }else if (timeInterval < 30){
        time = @"30秒前";
    }else if (timeInterval/60 < 60){
        time = [NSString stringWithFormat:@"%d分钟前", (int)timeInterval/60];
    }else if (timeInterval/3600 < 24){
        time = [NSString stringWithFormat:@"%d小时前", (int)timeInterval/3600];
    }else if (timeInterval/(3600*24) < 365){
        time = [NSString stringWithFormat:@"%d天前", (int)timeInterval/(3600*24)];
    }else{
        time = [NSString stringWithFormat:@"%d年前", (int)timeInterval/(3600*24*365)];
    }
    return time;
}

- (NSString *)getSource
{
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
    NSArray *array = [_sourceStr componentsSeparatedByCharactersInSet:set];
    return [NSString stringWithFormat:@"来自：%@", [array objectAtIndex:2]];
}

- (CGFloat)heightForRow
{
    WeiboCell *cell = [[[WeiboCell alloc] init] autorelease];
    CGSize size = [self contentSize];
    float imgHeight = 0;
    if (_imgStr) {
        imgHeight = cell.statusImage.frame.size.height+5;
    }
    return cell.labelContent.frame.origin.y+size.height+5+imgHeight+cell.labelPostSource.frame.size.height+5;
}

- (CGSize)contentSize
{
    WeiboCell *cell = [[[WeiboCell alloc] init] autorelease];
    return [_contentStr sizeWithFont:cell.labelContent.font constrainedToSize:CGSizeMake(cell.labelContent.frame.size.width, 1000) lineBreakMode:NSLineBreakByWordWrapping];
}

#pragma mark - UIRect
- (CGRect)contentRect
{
    WeiboCell *cell = [[[WeiboCell alloc] init] autorelease];
    CGSize size = [self contentSize];
    return CGRectMake(cell.labelContent.frame.origin.x, cell.labelContent.frame.origin.y, size.width, size.height);
}

- (CGRect)imageRect
{
    WeiboCell *cell = [[[WeiboCell alloc] init] autorelease];
    CGSize size = [self contentSize];
    if (_imgStr) {
        return CGRectMake(cell.statusImage.frame.origin.x, cell.labelContent.frame.origin.y+size.height+5, cell.statusImage.frame.size.width, cell.statusImage.frame.size.height);
    }else{
        return CGRectMake(0, cell.labelContent.frame.origin.y+size.height, 0, 0);
    }
}

- (CGRect)sourceRect
{
    WeiboCell *cell = [[[WeiboCell alloc] init] autorelease];
    CGRect rect = [self imageRect];
    return CGRectMake(cell.labelPostSource.frame.origin.x, rect.origin.y+rect.size.height+5, cell.labelPostSource.frame.size.width, cell.labelPostSource.frame.size.height);
}

@end
