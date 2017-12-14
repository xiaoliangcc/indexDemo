//
//  FMRefreshHeader.h
//  FMRefresh2
//
//  Created by qianjn on 2017/5/7.
//  Copyright © 2017年 SF. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, FMRefreshState) {
    FMRefreshStateNormal = 0,     /** 普通状态 */
    FMRefreshStatePulling,        /** 释放刷新状态 */
    FMRefreshStateRefreshing,     /** 正在刷新 */
};
static NSString *FM_Refresh_normal_title  = @"正常状态";
static NSString *FM_Refresh_pulling_title  = @"释放刷新状态";
static NSString *FM_Refresh_Refreshing_title  = @"正在刷新";

@interface FMRefreshHeader : UIRefreshControl
@property (nonatomic, assign) FMRefreshState currentStatus;

- (instancetype)initWithTargrt:(id)target refreshAction:(SEL)refreshAction;
- (void)endRefreshing;

@end
