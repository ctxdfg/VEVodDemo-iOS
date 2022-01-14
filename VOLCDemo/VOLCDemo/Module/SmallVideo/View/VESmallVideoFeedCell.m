//
//  VESmallVideoFeedCell.m
//  VOLCDemo
//
//  Created by wangzhiyong on 2021/6/30.
//  Copyright © 2021 ByteDance. All rights reserved.
//

#import "VESmallVideoFeedCell.h"
#import "VEVideoModel.h"
#import "VESmallPlaybackViewController.h"
#import "TTVideoEngineVidSource.h"

@interface VESmallVideoFeedCell () <VESmallPlayDataSouce>

@property (nonatomic, strong) VESmallPlaybackViewController *playerViewController;

@end

@implementation VESmallVideoFeedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configuratoinCustomView];
    }
    return self;
}


#pragma mark ----- UI

- (void)configuratoinCustomView {
    self.playerViewController = [VESmallPlaybackViewController new];
    self.playerViewController.dataSource = self;
    [self.contentView addSubview:self.playerViewController.view];
    [self.playerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}


#pragma mark ----- VEVideoFeedViewCellProtocol

- (void)shouldPlay {
    [self.playerViewController reloadData];
}

- (void)shouldStop {
    [self.playerViewController stopSession];
}

- (void)shouPause {
    
}


#pragma mark ----- VESmallPlayDataSouce

- (TTVideoEngineVidSource *)playSource {
    return [VEVideoModel videoEngineVidSource:self.videoModel];
}

- (NSString *)playTitle {
    return self.videoModel.title;
}

@end
