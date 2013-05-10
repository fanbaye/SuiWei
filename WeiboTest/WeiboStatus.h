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

@property (nonatomic, retain) NSData *imgData;

- (NSString *)getSourceStr;
- (CGFloat)heightForRow;
- (CGSize)contentSize;
- (CGRect)contentRect;
- (CGRect)imageRect;
- (CGRect)sourceRect;

@end
