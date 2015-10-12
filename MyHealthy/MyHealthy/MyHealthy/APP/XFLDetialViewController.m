//
//  XFLDetialViewController.m
//  YI18
//
//  Created by 薛飞龙 on 14-7-6.
//  Copyright (c) 2014年 Flonger. All rights reserved.
//

#import "XFLDetialViewController.h"
#import "UIImageView+AFNetworking.h"
#import "BaseHTTPManager.h"
@interface XFLDetialViewController ()

@end

@implementation XFLDetialViewController
{
    NSMutableArray * _dataArray;
    UIScrollView * _sv;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getData];
    
    
    
    
    UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [[self view] addGestureRecognizer:recognizer];
}
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)getBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getData{
    [BaseHTTPManager GET:self.url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dataDict = responseObject;
        [self create];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)create
{
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    titleView.backgroundColor = [UIColor whiteColor];
    
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    [bgView setImage:[UIImage imageNamed:@"reg_kuang"]];
    [titleView addSubview:bgView];
    
    
    UIButton * back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(10, 20, 40, 40);
    [back setBackgroundImage:[UIImage imageNamed:@"返回箭头"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(getBack) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:back];
    
    UILabel * titleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.center = CGPointMake(self.view.bounds.size.width/2, 42);
    titleLabel.text = @"详情";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:0.37f green:0.35f blue:0.59f alpha:1.00f];
    [titleView addSubview:titleLabel];
    
    
    
    [self.view addSubview:titleView];
    
    
    _sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    _sv.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_sv];
    [self createUI];
}
- (void)createUI
{
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.bounds.size.width - 40, 50)];
    titleLabel.text = _dataDict[@"title"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.numberOfLines = 2;
    
    [_sv addSubview:titleLabel];
    
    UILabel * timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, self.view.bounds.size.width - 40, 20)];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.text = [self changeTimeWithInt:[NSString stringWithFormat:@"%@",_dataDict[@"time"]]];
    timeLabel. font = [UIFont systemFontOfSize:14];
    timeLabel.textColor = [UIColor lightGrayColor];
    [_sv addSubview:timeLabel];
    
    NSString * imgUrl = _dataDict[@"img"];
    if (imgUrl.length > 0) {
        UIImageView * iv = [[UIImageView alloc] initWithFrame:CGRectMake(40, 80, 240, 150)];
        iv.center = CGPointMake(self.view.bounds.size.width/2, 80+150/2);
        [iv setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",_dataDict[@"img"]]]];
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.clipsToBounds = YES;
//        [_sv addSubview:iv];
    }

    
    
    UILabel * meLabel = [[UILabel alloc] init];
    UIWebView * wv = [[UIWebView alloc] init];

    meLabel.text = _dataDict[@"message"];
    [wv loadHTMLString:_dataDict[@"message"] baseURL:nil];
    
    meLabel.numberOfLines = 0;
    // 计算大小
    CGSize size;

    size = [_dataDict[@"message"] sizeWithFont:meLabel.font constrainedToSize:CGSizeMake(300, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    
    
    if (imgUrl.length > 0) {
        meLabel.frame = CGRectMake(10, 80, size.width, size.height);
        wv.frame = CGRectMake(10, 80, _sv.bounds.size.width-10, size.height+50);
    }else{
        meLabel.frame = CGRectMake(10, 80, size.width, size.height);
        wv.frame = CGRectMake(10, 80, _sv.bounds.size.width-10, size.height+50);
    }
    
//    [_sv addSubview:meLabel];
    wv.userInteractionEnabled = NO;
    [_sv addSubview:wv];
    if (imgUrl.length > 0) {
        if ((size.height + 80) > (self.view.bounds.size.height - 49 - 64)) {
            _sv.contentSize = CGSizeMake(self.view.bounds.size.width, size.height + 130);
        }
    }else{
        if ((size.height + 80) > (self.view.bounds.size.height - 49 - 64)) {
            _sv.contentSize = CGSizeMake(self.view.bounds.size.width, size.height + 130);
        }
    }

}
- (NSString *)changeTimeWithInt:(NSString *)intTime{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSTimeInterval timeInt=[intTime  doubleValue]/1000;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:timeInt];
    NSString * time = [formatter stringFromDate:detaildate];
    return time;
}

@end
