//
//  VELongVideoViewController.m
//  VOLCDemo
//
//  Created by RealZhao on 2021/12/23.
//

#import "VELongVideoViewController.h"
#import "VELongVideoDetailViewController.h"
#import "VELongVideoCollectionViewCell.h"
#import "VENetworkHelper.h"
#import "VEVideoModel.h"

static NSString *VELongVideoCollectionViewCellReuseID = @"VELongVideoCollectionViewCellReuseID";

@interface VELongVideoViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *normalVideos;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation VELongVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialUI];
    [self loadData];
}


#pragma mark ----- Base

- (void)initialUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[VELongVideoCollectionViewCell class] forCellWithReuseIdentifier:VELongVideoCollectionViewCellReuseID];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.title = NSLocalizedString(@"title_long_video", nil);
    self.navigationItem.leftBarButtonItem = ({
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(close)];
        leftItem.tintColor = [UIColor blackColor];
        leftItem;
    });
}


#pragma mark ----- UICollectionView Delegate & DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.normalVideos.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VELongVideoCollectionViewCell *cell = [collectionView
                                                dequeueReusableCellWithReuseIdentifier:VELongVideoCollectionViewCellReuseID forIndexPath:indexPath];
    VEVideoModel *videoModel = [self.normalVideos objectAtIndex:indexPath.item];
    cell.videoModel = videoModel;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    VEVideoModel *videoModel = [self.normalVideos objectAtIndex:indexPath.item];
    VELongVideoDetailViewController *detailViewController = [VELongVideoDetailViewController new];
    detailViewController.videoModel = videoModel;
    [self.navigationController pushViewController:detailViewController animated:YES];
}


#pragma mark ----- lazy load

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:({
            UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            CGFloat div = 30.0;
            NSInteger rowCount = 2;
            CGFloat itemWidth = (UIScreen.mainScreen.bounds.size.width - div) / rowCount;
            CGFloat itemHeight = itemWidth * 9.0 / 16.0 + 20.0; // (cover + title)
            layout.itemSize = CGSizeMake(itemWidth, itemHeight);
            layout;
        })];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (NSMutableArray *)normalVideos {
    if (!_normalVideos) {
        _normalVideos = [NSMutableArray array];
    }
    return _normalVideos;
}


#pragma mark ----- Data Load

- (void)loadData {
    NSDictionary *param = @{ @"userID" : @"small-video" };
    NSString *urlString = @"http://vod-app-server.snssdk.com/api/general/v1/getFeedStreamWithPlayAuthToken";
    [VENetworkHelper requestDataWithUrl:urlString httpMethod:@"POST" parameters:param success:^(id  _Nonnull responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *responseDictionary = responseObject;
            NSArray *retVideoList = [responseDictionary objectForKey:@"result"];
            [retVideoList enumerateObjectsUsingBlock:^(NSDictionary *itemDictionary, NSUInteger idx, BOOL * _Nonnull stop) {
                VEVideoModel *videoModel = [[VEVideoModel alloc] initWithJsonDictionary:itemDictionary];
                videoModel.extendIndex = idx;
                [self.normalVideos addObject:videoModel];
            }];
            [self.collectionView reloadData];
        }
    } failure:^(NSString * _Nonnull errorMessage) {
        
    }];
}

@end
