

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	YZYOPullRefreshPulling = 0,
	YZYOPullRefreshNormal,
	YZYOPullRefreshLoading,	
} YZYPullRefreshState;

@protocol YZYRefreshTableFooterDelegate;
@interface YZYRefreshTableFooterView : UIView {
	
	id _delegate;
	YZYPullRefreshState _state;

	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
	

}

@property(nonatomic,assign) id <YZYRefreshTableFooterDelegate> delegate;

- (void)refreshLastUpdatedDate;
- (void)yzyRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)yzyRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)yzyRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end
@protocol YZYRefreshTableFooterDelegate
- (void)yzyRefreshTableFooterDidTriggerRefresh:(YZYRefreshTableFooterView*)view;
- (BOOL)yzyRefreshTableFooterDataSourceIsLoading:(YZYRefreshTableFooterView*)view;
@optional
- (NSDate*)yzyRefreshTableFooterDataSourceLastUpdated:(YZYRefreshTableFooterView*)view;
@end
