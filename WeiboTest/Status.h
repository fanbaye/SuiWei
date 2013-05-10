//
//  Status.h
//  WeiboTest
//
//  Created by lucas on 5/5/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Status : NSObject

{
    NSString *_contentStr;
    NSString *_authorStr;
    NSString *_timeStr;
    NSString *_imgStr;
    NSString *_sourceStr;
    NSData *_imgData;
}

@property (nonatomic, copy) NSString *contentStr;
@property (nonatomic, copy) NSString *authorStr;
@property (nonatomic, copy) NSString *timeStr;
@property (nonatomic, copy) NSString *imgStr;
@property (nonatomic, copy) NSString *sourceStr;
@property (nonatomic, retain) NSData *imgData;

- (NSString *)getSourceStr;
- (CGFloat)heightForRow;
- (CGSize)contentSize;
- (CGRect)contentRect;
- (CGRect)imageRect;
- (CGRect)sourceRect;

@end
