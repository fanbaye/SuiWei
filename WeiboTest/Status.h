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
    NSData *_imgData;
    NSString *_sourceStr;
}

@property (nonatomic, copy) NSString *contentStr;
@property (nonatomic, copy) NSString *authorStr;
@property (nonatomic, copy) NSString *timeStr;
@property (nonatomic, retain) NSData *imgData;
@property (nonatomic, copy) NSString *sourceStr;

- (NSString *)getSourceStr;
- (CGFloat)heightForRow;
- (CGSize)contentSize;
- (CGRect)imageRect;
- (CGRect)sourceRect;

@end
