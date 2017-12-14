//
//  ViewController.m
//  IndexDemo
//
//  Created by zhangxiaoliang on 2017/11/27.
//  Copyright © 2017年 zhangxiaoliang. All rights reserved.
//

#import "ViewController.h"
#import "RefreshHeaader.h"
#import "UIButton+Index.h"
#import "IndexButton.h"

#define SCREEN_HEIGHT                      [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH                       [UIScreen mainScreen].bounds.size.width
#define SCALE_6                                                   (SCREEN_WIDTH / 375)
#define kTopViewHeight 270.0

#define kColorGlobalBG [UIColor colorWithRed:65/255.0 green:128/255.0 blue:1 alpha:1]
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic) UIView * topView;
@property (nonatomic) UITableView *tableView;
@property(nonatomic,strong)UIView *coverNavView;
@property(nonatomic,strong)UIView *mainNavView;
@property(nonatomic,strong)UIView *functionHeaderView;
@property(nonatomic,strong)UIView *extensionFunctionView;
@property (nonatomic) RefreshHeaader * refreshHeaaderView;
@end
@implementation ViewController
- (UIView *)mainNavView
{
    if (!_mainNavView) {
        _mainNavView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _mainNavView.backgroundColor = kColorGlobalBG;
        UIButton *payBtn = [[UIButton alloc]init];
        [payBtn setImage:[UIImage imageNamed:@"home_bill_320"] forState:UIControlStateNormal];
        [payBtn setTitle:@"账单" forState:UIControlStateNormal];
        payBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        payBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [payBtn sizeToFit];
        
        CGRect newFrame = payBtn.frame;
        newFrame.origin.y = 20 + 10;
        newFrame.origin.x = 10;
        newFrame.size.width = newFrame.size.width + 20;
        payBtn.frame = newFrame;
        [_mainNavView addSubview:payBtn];

    }
    return  _mainNavView;
}
- (UIView *)coverNavView
{
    if (!_coverNavView) {
        _coverNavView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _coverNavView.backgroundColor = kColorGlobalBG;
        
        UIButton *payBtn = [[UIButton alloc]init];
        [payBtn setImage:[UIImage imageNamed:@"pay_mini"] forState:UIControlStateNormal];
        [payBtn sizeToFit];
        
        CGRect newFrame = payBtn.frame;
        newFrame.origin.y = 20 + 10;
        newFrame.origin.x = 10;
        newFrame.size.width = newFrame.size.width + 10;
        payBtn.frame = newFrame;
        
        UIButton *scanBtn = [[UIButton alloc]init];
        [scanBtn setImage:[UIImage imageNamed:@"scan_mini"] forState:UIControlStateNormal];
        [payBtn sizeToFit];
        newFrame.origin.x = newFrame.origin.x + 40 + newFrame.size.width;
        scanBtn.frame = newFrame;
        
        UIButton *cameraBtn = [[UIButton alloc]init];
        [cameraBtn setImage:[UIImage imageNamed:@"camera_mini"] forState:UIControlStateNormal];
        [cameraBtn sizeToFit];
        
        newFrame.origin.x = newFrame.origin.x + 40 + newFrame.size.width;
        
        cameraBtn.frame = newFrame;
        
        [_coverNavView addSubview:payBtn];
        [_coverNavView addSubview:scanBtn];
        [_coverNavView addSubview:cameraBtn];
        
        
        _coverNavView.alpha = 0.0;
        
    }
    return _coverNavView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.mainNavView];
    [self.view addSubview:self.coverNavView];
    [self.tableView addSubview:self.topView];
    [self.tableView reloadData];
}
#pragma mark - delegate
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat tableViewoffsetY = scrollView.contentOffset.y;
    if ( tableViewoffsetY>= 0) {
        self.topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kTopViewHeight);
    }else if( tableViewoffsetY < 0){
        self.topView.frame = CGRectMake(0, tableViewoffsetY, SCREEN_WIDTH, kTopViewHeight);
    }
    CGFloat alpha = (1 - tableViewoffsetY/kTopViewHeight * 2.5) > 0?(1 - tableViewoffsetY/kTopViewHeight*2.5):0;
    self.functionHeaderView.alpha = alpha;
    if (alpha > 0.5) {
        self.coverNavView.alpha = 0;
        
    }else{
        CGFloat newAlpha =  alpha * 2;
        self.coverNavView.alpha = 1 - newAlpha;
    }

    if (tableViewoffsetY > -64.0f) {
        self.refreshHeaaderView.type = typeNull;
    }else if (tableViewoffsetY > - 125.0f && tableViewoffsetY<-64.0f){
        self.refreshHeaaderView.type = typeWillRefresh;
    }else if(tableViewoffsetY < -125.0f){
        self.refreshHeaaderView.type = typeRefreshing;
    }else{
        
    }
}

#pragma mark - setter && getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTopViewHeight)];
        tableHeaderView.backgroundColor = [UIColor clearColor];
        _tableView.tableHeaderView = tableHeaderView;
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(kTopViewHeight, 0, 0, 0);
        [_tableView.tableHeaderView addSubview:self.refreshHeaaderView];
    }
    return _tableView;
}

- (RefreshHeaader *)refreshHeaaderView {
    if (!_refreshHeaaderView) {
        CGFloat refreshHeaaderViewH = 50;
        _refreshHeaaderView = [[RefreshHeaader alloc]init];
        _refreshHeaaderView.frame = CGRectMake(0, kTopViewHeight - refreshHeaaderViewH, SCREEN_WIDTH, refreshHeaaderViewH);
    }
    return _refreshHeaaderView;
}
- (UIView *)functionHeaderView
{
    if (!_functionHeaderView) {
        CGFloat padding  = 5.0;
        CGFloat buttonWidth = SCREEN_WIDTH/4.0 - padding * 2;
        CGFloat buttonHeigh = buttonWidth + 22;
        _functionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, buttonHeigh + 20)];
        _functionHeaderView.backgroundColor = kColorGlobalBG;
   
        IndexButton *scanButton = [[IndexButton alloc]init];
        scanButton.frame = CGRectMake(padding, padding, buttonWidth, buttonHeigh);
        [scanButton setImage:[UIImage imageNamed:@"home_scan"] forState:UIControlStateNormal];
        [scanButton setTitle:@"扫一扫" forState:UIControlStateNormal];

        IndexButton *payButton = [[IndexButton alloc]init];
        payButton.frame = CGRectMake(padding + SCREEN_WIDTH/4.0, padding, buttonWidth, buttonHeigh);
        [payButton setTitle:@"付款" forState:UIControlStateNormal];
        [payButton setImage:[UIImage imageNamed:@"home_pay"] forState:UIControlStateNormal];

        
        [payButton alignImageAndTitleVertically:6.0];
        IndexButton *cardButton = [[IndexButton alloc]init];
        cardButton.frame = CGRectMake(padding + SCREEN_WIDTH/4.0*2, padding, buttonWidth, buttonHeigh);
        [cardButton setImage:[UIImage imageNamed:@"home_card"] forState:UIControlStateNormal];

        [cardButton setTitle:@"卡券" forState:UIControlStateNormal];
        
        IndexButton *xiuBytton = [[IndexButton alloc]init];
        xiuBytton.frame = CGRectMake(padding + SCREEN_WIDTH/4.0*3, padding, buttonWidth, buttonHeigh);
        [xiuBytton setTitle:@"到位" forState:UIControlStateNormal];
        [xiuBytton setImage:[UIImage imageNamed:@"home_xiu"]  forState:UIControlStateNormal];
    
        [_functionHeaderView addSubview:scanButton];
        [_functionHeaderView addSubview:payButton];
        [_functionHeaderView addSubview:cardButton];
        [_functionHeaderView addSubview:xiuBytton];
        
    }
    return  _functionHeaderView;
}
- (UIView *)extensionFunctionView
{
    if (!_extensionFunctionView) {
        _extensionFunctionView = [[UIView alloc]initWithFrame:CGRectMake(0, self.functionHeaderView.bounds.size.height, SCREEN_WIDTH, kTopViewHeight - self.functionHeaderView.bounds.size.height)];
        _extensionFunctionView.backgroundColor = [UIColor blueColor];
    }
    return _extensionFunctionView;
}



- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTopViewHeight)];
        _topView.backgroundColor = kColorGlobalBG;
        
        [_topView addSubview:self.functionHeaderView];
        [_topView addSubview:self.extensionFunctionView];
    }
    return _topView;
}
#pragma mark  UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    cell.textLabel.text = [NSString stringWithFormat:@" 这里是数据啦啦啦啦啦%zd",indexPath.row];
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
}

@end
