//
//  Status.m
//  WeiboTest
//
//  Created by lucas on 5/5/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import "Status.h"
#import "WeiboCell.h"

@implementation Status

@synthesize contentStr = _contentStr;
@synthesize authorStr = _authorStr;
@synthesize timeStr = _timeStr;
@synthesize imgData = _imgData;
@synthesize sourceStr = _sourceStr;

- (void)dealloc
{
    [_contentStr release];
    [_authorStr release];
    [_timeStr release];
    [_imgData release];
    [_sourceStr release];
    [super dealloc];
}

- (NSString *)getSourceStr
{
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
    NSArray *array = [_sourceStr componentsSeparatedByCharactersInSet:set];
    return [NSString stringWithFormat:@"来自：%@", [array objectAtIndex:2]];
}

- (CGFloat)heightForRow
{
    CGSize size = [self contentSize];
    float imgHeight = 0;
    if (_imgData) {
        imgHeight = 80+5;
    }
    return 35+size.height+5+imgHeight+21+5;
}

- (CGSize)contentSize
{
    WeiboCell *cell = (WeiboCell *)[[[NSBundle mainBundle] loadNibNamed:@"WeiboCell" owner:self options:nil] objectAtIndex:0];
    return [_contentStr sizeWithFont:cell.content.font constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGRect)imageRect
{
    WeiboCell *cell = (WeiboCell *)[[[NSBundle mainBundle] loadNibNamed:@"WeiboCell" owner:self options:nil] objectAtIndex:0];
    CGSize size = [self contentSize];
    if (_imgData) {
        return CGRectMake(10, cell.content.frame.origin.y+size.height+5, cell.img.frame.size.width, cell.img.frame.size.height);
    }else{
        return CGRectMake(0, cell.content.frame.origin.y+size.height, 0, 0);
    }
}

- (CGRect)sourceRect
{
    WeiboCell *cell = (WeiboCell *)[[[NSBundle mainBundle] loadNibNamed:@"WeiboCell" owner:self options:nil] objectAtIndex:0];
    CGRect rect = [self imageRect];
    return CGRectMake(10, rect.origin.y+rect.size.height+5, cell.source.frame.size.width, cell.source.frame.size.height);
}

@end
