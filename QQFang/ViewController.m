//
//  ViewController.m
//  QQFang
//
//  Created by apple on 2018/3/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ViewController.h"
#define ScreenHeight        self.view.frame.size.height
#define ScreenWidth         self.view.frame.size.width
#define CScreenWidth        [[UIScreen mainScreen] bounds].size.width
#define CScreenHeight       [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UIView *navView;
@property(nonatomic, strong)UIView *toolView;


/**
 整个框架视图
 */
@property(nonatomic, strong)QQScrollView *contentScrollView;

@property(nonatomic, strong)UIView *headView;
@property(nonatomic, strong)UIView *titleView;
@property(nonatomic, strong)UIView *titleLineView;
@property(nonatomic, strong)NSMutableArray *titleBtnArr;
@property(nonatomic, strong)UIButton *currTitleBtn;
@property(nonatomic, strong)UIScrollView *titleScrollView;
@property(nonatomic, strong)NSMutableArray *scrollViewArr;

@property(nonatomic, assign)BOOL isMainScroll;
@property(nonatomic, assign)BOOL isCellScroll;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    self.isMainScroll = YES;
    self.isCellScroll = NO;
    [self.view addSubview:self.navView];
    [self.view addSubview:self.contentScrollView];
    [self.view addSubview:self.toolView];
}

#pragma mark---UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offSetY = scrollView.contentOffset.y;
    if ([scrollView isKindOfClass:[UITableView class]]) {
        NSLog(@"UITableView===%f",offSetY);
        if (self.isCellScroll) {
            if (offSetY<=0) {
                scrollView.contentOffset = CGPointZero;
                self.isMainScroll = YES;
                self.isCellScroll = NO;
            }
        }else{
            scrollView.contentOffset = CGPointZero;
        }
        scrollView.showsVerticalScrollIndicator = self.isCellScroll;

    }else{
//        NSLog(@"UIScrollView===%f",offSetY);
        if (scrollView.tag == 1000) 
        {
            if (self.isMainScroll) 
            {
                if (offSetY>=142) 
                {
                    scrollView.contentOffset = CGPointMake(0, 142);
                    self.isMainScroll = NO;
                    self.isCellScroll = YES;
                }
                else
                {
                    for (UITableView *tableView in self.scrollViewArr)
                    {
                        tableView.contentOffset = CGPointZero;
                    }
                }
            }
            else
            {
                scrollView.contentOffset = CGPointMake(0, 142);
            }
            scrollView.showsVerticalScrollIndicator = self.isMainScroll;
        }
    }
}
/*

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag ==2000) {
        NSLog(@"===%@",NSStringFromCGPoint(scrollView.contentOffset));
        NSInteger offSetx = scrollView.contentOffset.x/CScreenWidth;
        UIButton *btn =_titleBtnArr[offSetx];
        if (self.currTitleBtn.tag==btn.tag) {
            return;
        }
        [self.currTitleBtn setTitleColor:[[UIColor grayColor] colorWithAlphaComponent:.7] forState:UIControlStateNormal];
        [btn setTitleColor:[[UIColor blueColor] colorWithAlphaComponent:.7] forState:UIControlStateNormal];
        [UIView animateWithDuration:.2 animations:^{
            self.titleLineView.center = CGPointMake(btn.center.x, 43);
            self.titleLineView.bounds = CGRectMake(0, 0, 20*[btn.currentTitle length], 2);
        }];
        self.currTitleBtn = btn;
    }
}
*/
#pragma mark---UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text =@"测试一下";
    return cell;
}

#pragma mark --- ButtonClick
- (void)titleButtonClick:(UIButton *)btn{
    if (self.currTitleBtn.tag==btn.tag) {
        return;
    }
    [self.currTitleBtn setTitleColor:[[UIColor grayColor] colorWithAlphaComponent:.7] forState:UIControlStateNormal];
    [btn setTitleColor:[[UIColor blueColor] colorWithAlphaComponent:.7] forState:UIControlStateNormal];
    [UIView animateWithDuration:.2 animations:^{
        self.titleLineView.center = CGPointMake(btn.center.x, 43);
        self.titleLineView.bounds = CGRectMake(0, 0, 20*[btn.currentTitle length], 2);
    }];
    self.currTitleBtn = btn;
    self.titleScrollView.contentOffset = CGPointMake(CScreenWidth*btn.tag, 0);
}

#pragma mark-------contentScrollView

- (UIScrollView *)titleScrollView{
    if (!_titleScrollView) {
        _titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 142+44, CScreenWidth, CScreenHeight-64*2-44)];
        _titleScrollView.contentSize = CGSizeMake(CScreenWidth*5,  0);
        _titleScrollView.showsHorizontalScrollIndicator = NO;
        _titleScrollView.tag = 2000;
        _titleScrollView.delegate = self;
        _titleScrollView.pagingEnabled = YES;
        _scrollViewArr = [NSMutableArray array];
        for (int i=0; i<5; i++) {
            UITableView *tableView =[[UITableView alloc] initWithFrame:CGRectMake(CScreenWidth*i, 0, CScreenWidth, CScreenHeight-64*2-44)];
            tableView.tag = i;
            tableView.backgroundColor = @[[UIColor redColor],[UIColor grayColor],[UIColor blueColor],[UIColor yellowColor],[UIColor greenColor]][i];
            tableView.delegate = self;
            tableView.dataSource = self;
            [_scrollViewArr addObject:tableView];
            [_titleScrollView addSubview:tableView];
        }
    }
    return _titleScrollView;
}


- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CScreenWidth, 44*3)];
        _headView.backgroundColor = [UIColor whiteColor];
        for (int i=0; i<3; i++) {
            if (i==0) {
                UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, CScreenWidth-20, 34)];
                textField.placeholder = @"搜索";
                textField.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:.1];
                textField.textAlignment = NSTextAlignmentCenter;
                textField.borderStyle = UITextBorderStyleRoundedRect;
                [_headView addSubview:textField];
            }else{
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 44*i+7, 200, 30)];
                label.text = @[@"新朋友",@"创建群聊"][i-1];
                [_headView addSubview:label];
            }
            UIView *line =[[UIView alloc] initWithFrame:CGRectMake(0, 44*(i+1), CScreenWidth, .5)];
            line.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:.3];
            [_headView addSubview:line];
        }
    }
    return _headView;
}

- (UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 142, CScreenWidth, 44)];
        _titleView.backgroundColor = [UIColor whiteColor];
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"好友",@"群聊",@"设备",@"通讯录",@"公众号", nil];
        _titleBtnArr = [[NSMutableArray alloc] init];
        for (int i=0; i<arr.count; i++) {
            UIButton *titilBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [titilBtn setTitle:arr[i] forState:UIControlStateNormal];
            [titilBtn setTitleColor:[[UIColor grayColor] colorWithAlphaComponent:.7] forState:UIControlStateNormal];
            titilBtn.frame = CGRectMake(CScreenWidth/5*i, 5, CScreenWidth/5, 34);
            [titilBtn addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            titilBtn.tag = i;
            [_titleView addSubview:titilBtn];
            [_titleBtnArr addObject:titilBtn];
            if (i==0) {
                _titleLineView = [[UIView alloc] init];
                _titleLineView.center = CGPointMake(CScreenWidth/10, 43);
                _titleLineView.bounds = CGRectMake(0, 0,20*[@"好友" length], 2);
                _titleLineView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:.7];
                [titilBtn setTitleColor:[[UIColor blueColor] colorWithAlphaComponent:.7] forState:UIControlStateNormal];
                self.currTitleBtn = titilBtn;
                [_titleView addSubview:_titleLineView];
            }else if(i==1||i==2){
                UIView *line =[[UIView alloc] initWithFrame:CGRectMake(0, 43.5*(i-1), CScreenWidth, .5)];
                line.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:.3];
                [_titleView addSubview:line];
            }
        }
        
    }
    return _titleView;
}

#pragma mark------- 主体三部分
- (UIScrollView *)contentScrollView{
    if (!_contentScrollView) {
        _contentScrollView = [[QQScrollView alloc] initWithFrame:CGRectMake(0, 64, CScreenWidth, CScreenHeight-64*2)];
        _contentScrollView.contentSize = CGSizeMake(CScreenWidth, CScreenHeight-64*2+10+44*3);
        _contentScrollView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:.1];
        _contentScrollView.delegate = self;
        _contentScrollView.tag = 1000;
        [_contentScrollView addSubview:self.headView];
        [_contentScrollView addSubview:self.titleView];
        [_contentScrollView addSubview:self.titleScrollView];
    }
    return _contentScrollView;
}

- (UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CScreenWidth, 64)];
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.frame = CGRectMake(0, 0, CScreenWidth, 64);
        layer.colors = @[(id)UIColor.blueColor.CGColor,(id)UIColor.greenColor];
        layer.locations = @[@0,@1];
        layer.startPoint = CGPointMake(0, 1);
        layer.endPoint = CGPointMake(1, 0);
        layer.type = kCAGradientLayerAxial;
        [_navView.layer addSublayer:layer];
        
        UIImageView *headIG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic1"]];
        headIG.frame = CGRectMake(10, 27, 30, 30);
        headIG.layer.cornerRadius = 22;
        headIG.layer.masksToBounds = YES;
        [_navView addSubview:headIG];
        UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, CScreenWidth-120, 44)];
        navLabel.text = @"联系人";
        navLabel.textColor = [UIColor whiteColor];
        navLabel.textAlignment = NSTextAlignmentCenter;
        navLabel.font = [UIFont systemFontOfSize:16];
        [_navView addSubview:navLabel];
        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setTitle:@"添加" forState:UIControlStateNormal];
        [addBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        addBtn.frame = CGRectMake(CScreenWidth-54, 20, 44, 44);
        [_navView addSubview:addBtn];
    }
    return _navView;
}


- (UIView *)toolView{
    if (!_toolView) {
        _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, CScreenHeight-64, CScreenWidth, 64)];
        
        for (int i=0; i<3; i++) {
            QQButton *qBtn = [QQButton buttonWithType:UIButtonTypeCustom];
            qBtn.frame = CGRectMake(CScreenWidth/3*i, 0, CScreenWidth/3, 64);
            [qBtn setTitle:@[@"消息",@"联系人",@"动态"][i] forState:UIControlStateNormal];
            qBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [qBtn setImage:[UIImage imageNamed:@"pic2"] forState:UIControlStateNormal];
            [_toolView addSubview:qBtn];
        }

        
        UIView *line =[[UIView alloc] initWithFrame:CGRectMake(0, 0, CScreenWidth, .5)];
        line.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:.3];
        [_toolView addSubview:line];
    }
    return _toolView;
}


@end

@implementation QQButton

- (instancetype )initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat btnHeight = self.frame.size.height-10;
    self.imageView.center = CGPointMake(self.frame.size.width/2, btnHeight*2/3/2+5);
    self.imageView.bounds = CGRectMake(0, 0, btnHeight*2/3-5, btnHeight*2/3-5);
    self.titleLabel.frame = CGRectMake(0, btnHeight*2/3+5, self.frame.size.width, btnHeight/3);
}
@end

@interface QQScrollView()<UIGestureRecognizerDelegate>
@end
@implementation QQScrollView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
@end
