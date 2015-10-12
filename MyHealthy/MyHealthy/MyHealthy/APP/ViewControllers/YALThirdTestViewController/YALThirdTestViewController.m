// For License please refer to LICENSE file in the root of YALAnimatingTabBarController project

#import "YALThirdTestViewController.h"
#import "BaseHTTPManager.h"
#import "XFLDetialViewController.h"
#import "LDRefreshFooterView.h"
#import "LDRefreshHeaderView.h"
#import "UIScrollView+LDRefresh.h"



NSString *const YALChatDemoImageName = @"imageName";
NSString *const YALChatDemoUserName = @"userName";
NSString *const YALChatDemoMessageText = @"messageText";
NSString *const YALChatDemeDateText = @"dateText";

#define debug 1

//view
#import "YALChatDemoCollectionViewCell.h"

@interface YALThirdTestViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *chatDemoCollectionView;
@property (nonatomic, copy) NSArray *chatDemoData;

@property (nonatomic, strong) NSMutableArray * dataArray;


@end

@implementation YALThirdTestViewController
{
    NSString * _url;
    int _page;
    BOOL _refresh;
    int _type;

}

#pragma mark - View & LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    _type = 1;
    _refresh = NO;
    _dataArray = [NSMutableArray array];
    _url = @"info/list?rows=10";
    
    [self getData];
    [self addRefreshView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self.chatDemoCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    
//    [self prepareVisibleCellsForAnimation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [self animateVisibleCells];
}

- (void)getData{
    
    NSString * url = [NSString stringWithFormat:@"%@&page=%d",_url,_page];
    
    [BaseHTTPManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (_refresh) {
            [_dataArray removeAllObjects];
            [_dataArray addObjectsFromArray:responseObject[@"tngou"]];
        }else{
            [_dataArray addObjectsFromArray:responseObject[@"tngou"]];
        }

        [self.chatDemoCollectionView reloadData];

        [self prepareVisibleCellsForAnimation];

        [self animateVisibleCells];
        
        if (_refresh) {
            [self.chatDemoCollectionView.refreshHeader endRefresh];
        }else{
            [self.chatDemoCollectionView.refreshFooter endRefresh];
        }


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (IBAction)segmentClcik:(UISegmentedControl *)sender {
    
    [_dataArray removeAllObjects];
    
    if (sender.selectedSegmentIndex == 0) {
        _page = 1;
        _url = @"info/list?rows=10";
        _type = 1;
        
    }else{
        _page = 1;
        _url = @"lore/list?rows=10";
        _type = 2;
    }
    
    [self getData];
}









#pragma mark - Private

- (void)prepareVisibleCellsForAnimation {
    NSLog(@"%ld",[self.chatDemoCollectionView.visibleCells count]);
    for (int i = 0; i < [self.chatDemoCollectionView.visibleCells count]; i++) {
        YALChatDemoCollectionViewCell * cell = (YALChatDemoCollectionViewCell *) [self.chatDemoCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        cell.frame = CGRectMake(-CGRectGetWidth(cell.bounds), cell.frame.origin.y, CGRectGetWidth(cell.bounds), CGRectGetHeight(cell.bounds));
        cell.alpha = 0.f;
    }
}

- (void)animateVisibleCells {
    for (int i = 0; i < [self.chatDemoCollectionView.visibleCells count]; i++) {
        YALChatDemoCollectionViewCell * cell = (YALChatDemoCollectionViewCell *) [self.chatDemoCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
        cell.alpha = 1.f;
        [UIView animateWithDuration:0.25f
                              delay:i * 0.1
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             cell.frame = CGRectMake(0.f, cell.frame.origin.y, CGRectGetWidth(cell.bounds), CGRectGetHeight(cell.bounds));
                         }
                         completion:nil];
    }
}

#pragma mark - YALTabBarInteracting

- (void)tabBarViewWillCollapse {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}

- (void)tabBarViewWillExpand {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}

- (void)tabBarViewDidCollapsed {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}

- (void)tabBarViewDidExpanded {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}

- (void)extraLeftItemDidPressed {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}

- (void)extraRightItemDidPressed {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
         
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
          [self.chatDemoCollectionView performBatchUpdates:nil completion:nil];
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (void)addRefreshView {
    
    __weak __typeof(self) weakSelf = self;
    
    //下拉刷新
    self.chatDemoCollectionView.refreshHeader = [self.chatDemoCollectionView addRefreshHeaderWithHandler:^ {
        _refresh = YES;
        _page = 1;
        [weakSelf getData];
    }];
    
    //上拉加载更多
    self.chatDemoCollectionView.refreshFooter = [self.chatDemoCollectionView addRefreshFooterWithHandler:^ {
        _refresh = NO;
        _page += 1;
        [weakSelf getData];
    }];
    //    _footerView.autoLoadMore = NO;
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YALChatDemoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YALChatDemoCollectionViewCell class]) forIndexPath:indexPath];
    
    NSDictionary *dictionary = self.dataArray[indexPath.row];
    
    [cell configureCellWithImage:dictionary [@"img"]
                        userName:dictionary [@"title"]
                     messageText:dictionary [@"description"]
                        dateText:[self changeTimeWithInt:[NSString stringWithFormat:@"%@",dictionary [@"time"]]]];

    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dictionary = self.dataArray[indexPath.row];
    XFLDetialViewController * xdvc = [[XFLDetialViewController alloc] init];
    xdvc.dataDict = dictionary;
    if (_type == 1) {
        xdvc.url = [NSString stringWithFormat:@"info/show?id=%@",dictionary[@"id"]];
    }else if (_type == 2){
        xdvc.url = [NSString stringWithFormat:@"lore/show?id=%@",dictionary[@"id"]];
    }
    [self presentViewController:xdvc animated:YES completion:nil];
}


- (NSString *)changeTimeWithInt:(NSString *)intTime{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSTimeInterval timeInt=[intTime  doubleValue]/1000;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:timeInt];
    NSString * time = [formatter stringFromDate:detaildate];
    return time;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    
    return CGSizeMake(CGRectGetWidth(self.view.bounds), layout.itemSize.height);
}

@end
