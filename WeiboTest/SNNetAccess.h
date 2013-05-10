//
//  SNNetAccess.h
//  WeiboTest
//
//  Created by lucas on 5/5/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"

@protocol SNNetAccessDelegate <NSObject>

- (void)userInfo:(NSDictionary *)dic;
- (void)updateStatuses;
- (void)openApp;

@end

@interface SNNetAccess : NSObject <SinaWeiboDelegate, SinaWeiboRequestDelegate>
{
    
    id<SNNetAccessDelegate> _delegate;
}

+ (SNNetAccess *)sharedNetAccess;
@property (nonatomic, assign) id<SNNetAccessDelegate> delegate;

- (void)login;
- (void)logout;
- (void)getFriendsTime;
- (void)getUserInfo;
- (void)getTimeline;
- (void)postText:(NSString *)text;
- (void)postText:(NSString *)text AndImage:(UIImage *)image;

@end
