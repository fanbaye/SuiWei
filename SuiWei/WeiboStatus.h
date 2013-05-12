//
//  Status.h
//  WeiboTest
//
//  Created by lucas on 5/5/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboStatus : NSObject

@property (nonatomic, copy) NSString *contentStr;
@property (nonatomic, copy) NSString *authorStr;
@property (nonatomic, copy) NSString *timeStr;
@property (nonatomic, copy) NSString *imgStr;
@property (nonatomic, copy) NSString *sourceStr;
@property (nonatomic, copy) NSString *idStr;
@property (nonatomic, copy) NSString *reContentStr;
@property (nonatomic, copy) NSString *reAuthorStr;
@property (nonatomic, copy) NSString *reImageStr;

- (NSString *)getSource;
- (NSString *)getTime;
- (CGFloat)heightForRow;
- (CGSize)contentSize;
- (CGRect)contentRect;
- (CGRect)imageRect;
- (CGRect)retweetContentRect;
- (CGRect)retweetImageRect;
- (CGRect)sourceRect;

@end
