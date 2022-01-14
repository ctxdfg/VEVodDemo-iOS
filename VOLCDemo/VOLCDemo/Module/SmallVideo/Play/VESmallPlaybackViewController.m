//
//  VESmallPlaybackViewController.m
//  VOLCDemo
//
//  Created by real on 2022/1/12.
//

#import "VESmallPlaybackViewController.h"
#import <VEPlayerUIModule/VEInterfacePlayElement.h>
#import <VEPlayerUIModule/VEInterfaceProgressElement.h>
#import "VEVideoPlayerController.h"
#import "Masonry.h"

@interface VESmallPlaybackViewController () <VEPlayCoreAbilityProtocol, VEInterfaceElementDataSource, VEVideoPlaybackDelegate>

@property (nonatomic, strong) VEInterface *playerControlView; // player Control view

@property (nonatomic, strong) VEVideoPlayerController *playerController;

@end

@implementation VESmallPlaybackViewController

@synthesize receiver;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)setUpUI {
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.playerController.view];
    [self.view addSubview:self.playerControlView];
    [self.playerController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.playerControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)reloadData {
    if (self.playerController) [self.playerControlView reloadCore:self.playerController];
    if ([self.dataSource respondsToSelector:@selector(playSource)]) {
        TTVideoEngineVidSource *vidSource = [self.dataSource playSource];
        [self.playerController playWithMediaSource:vidSource];
        [self.playerController loadBackgourdImageWithMediaSource:vidSource];
    }
    if ([self.dataSource respondsToSelector:@selector(playTitle)]) {
        [self.playerController setPlayerTitle:[self.dataSource playTitle]];
    }
}

- (void)stopSession {
    [self.playerController stop];
}


#pragma mark ----- Lazy Load

- (VEInterface *)playerControlView {
    if (!_playerControlView) {
        _playerControlView = [[VEInterface alloc] initWithPlayerCore:(id<VEPlayCoreAbilityProtocol>)self scene:self];
    }
    return _playerControlView;
}

- (VEVideoPlayerController *)playerController {
    if (!_playerController) {
        _playerController = [VEVideoPlayerController new];
        _playerController.delegate = self;
    }
    return _playerController;
}

- (id<VEVideoPlayback>)videoPlayer {
    return self.playerController;
}


#pragma mark ----- VEInterfaceProtocol

- (NSArray<id<VEInterfaceElementDescription>> *)customizedElements {
    return @[
        [VEInterfacePlayElement playButton],
        [VEInterfacePlayElement playGesture],
        [VEInterfaceProgressElement progressView],
        // [VEInterfaceProgressElement progressGesture]
    ];
}


#pragma mark ----- VEVideoPlaybackDelegate

- (void)videoPlayerViewSizeDidChange:(id<VEVideoPlayback>)player timeIntervalDidChanged:(NSTimeInterval)interval {
    if ([self.receiver respondsToSelector:@selector(playerCore:playTimeDidChanged:info:)]) {
        [self.receiver playerCore:self.playerController playTimeDidChanged:interval info:@{}];
    }
}

- (void)videoPlayer:(id<VEVideoPlayback>)player playbackStateDidChange:(VEVideoPlaybackState)state {
    if ([self.receiver respondsToSelector:@selector(playerCore:playbackStateDidChanged:info:)]) {
        [self.receiver playerCore:self.playerController playbackStateDidChanged:self.currentPlaybackState info:@{}];
    }
}

@end
