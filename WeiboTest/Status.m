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
@synthesize imgStr = _imgStr;
@synthesize sourceStr = _sourceStr;
@synthesize imgData = _imgData;

- (void)dealloc
{
    [_contentStr release];
    [_authorStr release];
    [_timeStr release];
    [_imgStr release];
    [_sourceStr release];
    [_imgData release];
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
