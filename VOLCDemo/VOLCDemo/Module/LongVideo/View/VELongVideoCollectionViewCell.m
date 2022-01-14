//
//  VELongVideoCollectionViewCell.m
//  VOLCDemo
//
//  Created by RealZhao on 2021/12/23.
//

#import "VELongVideoCollectionViewCell.h"
#import "VEVideoModel.h"

@interface VELongVideoCollectionViewCell ()

@property (nonatomic, strong) UIImageView *coverImgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *playIconView;

@end

@implementation VELongVideoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialUI];
    }
    return self;
}

#pragma mark ----- UI

- (void)initialUI {
    [self.contentView addSubview:self.coverImgView];
    [self.contentView addSubview:self.titleLabel];
    [self.coverImgView addSubview:self.playIconView];
    self.coverImgView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.coverImgView.layer.borderWidth = (1.0 / UIScreen.mainScreen.scale);
    self.backgroundColor = self.contentView.backgroundColor = [UIColor clearColor];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self.contentView);
        make.height.equalTo(@20);
    }];
    [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.contentView);
        make.bottom.equalTo(self.titleLabel.mas_top);
    }];
    [self.playIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(CGSizeMake(50, 50)));
        make.center.equalTo(self.coverImgView);
    }];
}


#pragma mark ----- Setter

- (void)setVideoModel:(VEVideoModel *)videoModel {
    _videoModel = videoModel;
    if ([videoModel isKindOfClass:[VEVideoModel class]]) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@", videoModel.title];
        [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:videoModel.coverUrl]];
    } else {
        self.titleLabel.text = @"";
        self.coverImgView.image = nil;
    }
}


#pragma mark ----- lazy load

- (UIImageView *)coverImgView {
    if (!_coverImgView) {
        _coverImgView = [UIImageView new];
        _coverImgView.backgroundColor = [UIColor clearColor];
    }
    return _coverImgView;
}

- (UIImageView *)playIconView {
    if (!_playIconView) {
        _playIconView = [UIImageView new];
        _playIconView.backgroundColor = [UIColor clearColor];
        _playIconView.image = [UIImage imageNamed:@"ve_longvideo_play"];
    }
    return _playIconView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
