//
//  IndexButton.m
//  IndexDemo
//
//  Created by zhangxiaoliang on 2017/11/27.
//  Copyright © 2017年 zhangxiaoliang. All rights reserved.
//

#import "IndexButton.h"

@implementation IndexButton
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    return self;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, contentRect.size.width, contentRect.size.width);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, contentRect.size.width, contentRect.size.width, contentRect.size.height - contentRect.size.width);
}

@end
