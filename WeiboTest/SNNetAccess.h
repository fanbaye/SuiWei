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
- (void)statuses:(NSArray *)array;
- (void)startAct;
- (void)stopAct;

@end

@interface SNNetAccess : NSObject <SinaWeiboDelegate, SinaWeiboRequestDelegate>
{
    NSDictionary *_userInfo;
    NSArray *_friendsStatuses;
    NSArray *_statuses;
    
    id<SNNetAccessDelegate> _delegate;
}

+ (SNNetAccess *)sharedNetAccess;
@property (nonatomic, retain) NSDictionary *userInfo;
@property (nonatomic, retain) NSArray *friendsStatuses;
@property (nonatomic, retain) NSArray *statuses;
@property (nonatomic, assign) id<SNNetAccessDelegate> delegate;

- (void)login;
- (void)logout;
- (void)getFriendsTime;
- (void)getUserInfo;
- (void)getTimeline;
- (void)postText:(NSString *)text;
- (void)postText:(NSString *)text AndImage:(UIImage *)image;

@end
