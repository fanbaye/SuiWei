//
//  SNAppDelegate.h
//  sinaweibo_ios_sdk_demo
//
//  Created by Wade Cheng on 4/23/12.
//  Copyright (c) 2012 SINA. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kAppKey             @"3269184963"
#define kAppSecret          @"0ba0e0a9bc5da1fd99035f7febc960ad"
#define kAppRedirectURI     @"http://www.sina.com"

@class SinaWeibo;

@interface SNAppDelegate : UIResponder <UIApplicationDelegate>
{
    SinaWeibo *sinaweibo;
}

@property (readonly, nonatomic) SinaWeibo *sinaweibo;
@property (strong, nonatomic) UIWindow *window;

@end
