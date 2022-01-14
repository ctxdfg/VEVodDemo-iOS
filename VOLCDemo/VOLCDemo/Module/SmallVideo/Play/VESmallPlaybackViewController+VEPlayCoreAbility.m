//
//  VESmallPlaybackViewController+VEPlayCoreAbility.m
//  VOLCDemo
//
//  Created by real on 2022/1/13.
//

#import "VESmallPlaybackViewController+VEPlayCoreAbility.h"

@implementation VESmallPlaybackViewController (VEPlayCoreAbility)

#pragma mark ----- VEPlayCoreAbilityProtocol
// 这些实现是为了转换 当前所用播放器 可以提供的函数 与 空间层 需要的播放能力。

- (BOOL)looping {
    return self.videoPlayer.looping;
}

- (void)setLooping:(BOOL)looping {
    [self.videoPlayer setLooping:looping];
}

- (CGFloat)playbackSpeed {
    return self.videoPlayer.playbackRate;
}

- (void)setPlaybackSpeed:(CGFloat)playbackSpeed {
    [self.videoPlayer setPlaybackRate:playbackSpeed];
}

- (CGFloat)volume {
    return [self.videoPlayer playbackVolume];
}

- (void)setVolume:(CGFloat)volume {
    [self.videoPlayer setPlaybackVolume:volume];
}

- (void)play {
    [self.videoPlayer play];
}

- (void)pause {
    [self.videoPlayer pause];
}

- (void)seek:(NSTimeInterval)destination {
    [self.videoPlayer seekToTime:destination complete:^(BOOL success) {
    } renderComplete:^{
    }];
}

- (NSString *)title {
    return self.videoPlayer.playerTitle;
}

- (NSTimeInterval)duration {
    return self.videoPlayer.duration;
}

- (NSTimeInterval)playableDuration {
    return self.videoPlayer.playableDuration;
}

- (NSArray *)playSpeedSet {
    return @[
        @{@"0.5x" : @(0.5)},
        @{@"1.0x" : @(1.0)},
        @{@"1.5x" : @(1.5)},
        @{@"2.0x" : @(2.0)},
        @{@"3.0x" : @(3.0)}
    ];
}

- (VEPlaybackState)currentPlaybackState {
    VEPlaybackState state = VEPlaybackStateError;
    switch (self.videoPlayer.playbackState) {
        case TTVideoEnginePlaybackStateError: {
            state = VEPlaybackStateError;
        }
            break;
        case TTVideoEnginePlaybackStateStopped: {
            state = VEPlaybackStateStopped;
        }
            break;
        case TTVideoEnginePlaybackStatePlaying: {
            state = VEPlaybackStatePlaying;
        }
            break;
        case TTVideoEnginePlaybackStatePaused: {
            state = VEPlaybackStatePause;
        }
            break;
        default: {
            state = VEPlaybackStateUnknown;
        }
            break;
    }
    return state;
}

@end
