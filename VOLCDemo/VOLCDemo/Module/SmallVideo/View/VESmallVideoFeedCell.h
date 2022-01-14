//
//  VESmallVideoFeedCell.h
//  VOLCDemo
//
//  Created by wangzhiyong on 2021/6/30.
//  Copyright © 2021 ByteDance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class VEVideoModel;

@protocol VEVideoFeedViewCellProtocol

- (void)shouldPlay;

- (void)shouldStop;

- (void)shouPause;

@end

@interface VESmallVideoFeedCell : UITableViewCell <VEVideoFeedViewCellProtocol>

@property (nonatomic, strong) VEVideoModel *videoModel;

@end

NS_ASSUME_NONNULL_END
