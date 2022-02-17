## VOLCDemo介绍

VOLCDemo基于TTSDK点播SDK构建，当前版本以小视频场景演示，后续会持续迭代，短视频、长视频场景的使用；
目标帮助业务侧快速集成的点播模块，通过迭代短视频、小视频、长视频等场景帮助业务侧快速实现接入最佳实践；

TTSDK v_1.23.1.4 版本增加播放器策略模块，一期上线小视频策略：通用策略、预加载、预渲染；




## 目录结构说明

```
├─ TTSDK 
|  ├─ TTSDKFramework-x.x.x.x-premium-ta.zip  // 解压后是高级版动态库
|  ├─ TTSDKFramework-x.x.x.x-standard-ta.zip // 解压后是基础版动态库
├─ VOLCDemo 
└── VOLCDemo
    ├── Base    // Appdelegate
    ├── Player  // 播放器
    ├── Module  // 实现模块：小视频等
    └── Utils   // 工具类
```



## VOLCDemo运行

1. 进入 VEVodDemo-iOS/VOLCDemo 文件夹
2. 执行 pod install
3. 打开 VOLCDemo.xcworkspace 编译运行



## TTSDK点播SDK 集成方式

### 方式一：CocoaPods集成【推荐】
1. 添加pod依赖
```
source 'https://github.com/volcengine/volcengine-specs.git'
pod 'TTSDK', 'x.x.x.x', :subspecs => [ # 推荐使用最新稳定版，具体版本号请参考最下方的ChangeLog 
  'Player',   # 点播SDK
]
```

2. 执行 pod install
3. import <TTSDK/TTVideoEngineHeader.h>


### 方式二：动态库方式手动集成
我们强烈推荐使用CocoaPods在线方式集成方式，但从业务测反馈业务侧接入时可能三方库存在冲突问题，这时候需要使用动态库方式手动集成；
- [手动集成文档](https://www.volcengine.com/docs/4/65775#%E6%96%B9%E6%B3%95%E4%BA%8C%EF%BC%9A%E6%89%8B%E5%B7%A5%E9%9B%86%E6%88%90)


### 更多集成相关文档链接
- [集成准备](https://www.volcengine.com/docs/4/65775)
- [快速开始](https://www.volcengine.com/docs/4/65777)
- [基础功能接入](https://www.volcengine.com/docs/4/65779)
- [高级功能接入](https://www.volcengine.com/docs/4/67626)
- [预加载功能接入](https://www.volcengine.com/docs/4/65780)
- [控件层使用](https://bytedance.feishu.cn/docx/doxcnqF1Y9NIzOQH0m8OVQ0cPFo)


###控件层快速开始
首先请查看iOS开源控件层使用指南 ，如果你想快速开始，那么只需使用./VEPlayerUIModule/Classes/Example/下的范例使用方式。

集成代码
将VEUIModule源码引入工程，然后在Podfile中添加对应对应条目。
pod 'VEPlayerUIModule', :path=> './VEPlayerUIModule/'

前置条件（以TTVideoEngine为范例）
实现 VEPlayCoreAbilityProtocol
@implementation VEVideoPlayerController (VEPlayCoreAbility)

#pragma mark ----- origin class implementated
/*
 @property (nonatomic, weak) id<VEPlayCoreCallBackAbilityProtocol> receiver;
 @property (nonatomic, assign) BOOL looping;
 - (void)play;
 - (void)pause;
 */


#pragma mark ----- implementatation

- (CGFloat)playbackSpeed {
    return [self playbackRate];
}

- (void)setPlaybackSpeed:(CGFloat)speed {
    [self setPlaybackRate:speed];
}

- (void)setCurrentResolution:(TTVideoEngineResolutionType)resolution {
    NSDictionary *param = @{};
    [self.videoEngine configResolution:resolution params:param completion:^(BOOL success, TTVideoEngineResolutionType completeResolution) {
        NSLog(@"resolution changed %@, current = %ld, param = %@", (success ? @"success" : @"fail"), completeResolution, param);
    }];
}

- (TTVideoEngineResolutionType)currentResolution {
    return self.videoEngine.currentResolution;
}

- (void)setVolume:(CGFloat)volume {
    [self setPlaybackVolume:volume];
}

- (CGFloat)volume {
    return [self playbackVolume];
}

- (void)seek:(NSTimeInterval)destination {
    if (destination > 0.00) {
        NSLog(@"zxy time inner interval = %lf", destination);
        [self seekToTime:destination complete:^(BOOL success) {
            NSLog(@"call seek succeed");
        } renderComplete:^{
            NSLog(@"render succeed after seek");
        }];
    }
}

- (VEPlaybackState)currentPlaybackState {
    VEPlaybackState state = VEPlaybackStateError;
    if (self.videoEngine) {
        switch (self.videoEngine.playbackState) {
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
    }
    return state;
}

- (NSString *)title {
    return [self playerTitle];
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

- (NSArray *)resolutionSet {
    NSMutableArray *resolutionSet = [NSMutableArray array];
    for (NSNumber *originTypeNum in self.videoEngine.supportedResolutionTypes) {
        NSString *resolutionTitle = [self _transferResolutionTitleByType:originTypeNum.integerValue];
        [resolutionSet addObject:@{resolutionTitle : originTypeNum}];
    }
    return resolutionSet;
}

- (NSString *)_transferResolutionTitleByType:(NSInteger)type {
    NSString *resolutionTitle;
    switch (type) {
        case TTVideoEngineResolutionTypeSD:
            resolutionTitle = @"320";
            break;
        case TTVideoEngineResolutionTypeHD:
            resolutionTitle = @"540";
            break;
        case TTVideoEngineResolutionTypeFullHD:
            resolutionTitle = @"720";
            break;
        case TTVideoEngineResolutionType1080P:
            resolutionTitle = @"1080";
            break;
        case TTVideoEngineResolutionType4K:
            resolutionTitle = @"4K";
            break;
        case TTVideoEngineResolutionTypeABRAuto:
            resolutionTitle = @"ABR自动";
            break;
        case TTVideoEngineResolutionTypeAuto:
            resolutionTitle = @"自动";
            break;
        case TTVideoEngineResolutionTypeUnknown:
            resolutionTitle = @"未知";
            break;
        case TTVideoEngineResolutionTypeHDR:
            resolutionTitle = @"HDR";
            break;
        case TTVideoEngineResolutionTypeHDR_240P:
            resolutionTitle = @"240p HDR";
            break;
        case TTVideoEngineResolutionTypeHDR_360P:
            resolutionTitle = @"360p HDR";
            break;
        case TTVideoEngineResolutionTypeHDR_480P:
            resolutionTitle = @"480p HDR";
            break;
        case TTVideoEngineResolutionTypeHDR_540P:
            resolutionTitle = @"540p HDR";
            break;
        case TTVideoEngineResolutionTypeHDR_720P:
            resolutionTitle = @"720p HDR";
            break;
        case TTVideoEngineResolutionTypeHDR_1080P:
            resolutionTitle = @"1080p HDR";
            break;
        case TTVideoEngineResolutionTypeHDR_2K:
            resolutionTitle = @"2k HDR";
            break;
        case TTVideoEngineResolutionTypeHDR_4K:
            resolutionTitle = @"4k HDR";
            break;
        case TTVideoEngineResolutionType2K:
            resolutionTitle = @"2k";
            break;
        case TTVideoEngineResolutionType1080P_120F:
            resolutionTitle = @"1080P_120F";
            break;
        case TTVideoEngineResolutionType2K_120F:
            resolutionTitle = @"2K_120F";
            break;
        case TTVideoEngineResolutionType4K_120F:
            resolutionTitle = @"4K_120F";
            break;
        default:
            resolutionTitle = @"默认";
            break;
    }
    return resolutionTitle;
}

@end

Class-Method方式
涉及的类： VEInterfacePlayElement，VEInterfaceProgressElement，VEInterfaceSimpleMethodSceneConf
只需在对应业务中添加 playerControlView，这是一个播控能力View。
#import <VEPlayerUIModule/VEPlayerUIModule.h>
#import "VEInterfaceSimpleMethodSceneConf.h"

- (VEInterface *)playerControlView {
    if (!_playerControlView) {
        _playerControlView = [[VEInterface alloc] initWithPlayerCore:self.playerController scene:[VEInterfaceSimpleMethodSceneConf new]];
        _playerControlView.delegate = self;
    }
    return _playerControlView;
}

Method-Block方式
涉及的类： VEInterfaceSimpleBlockSceneConf
只需在对应业务中添加 playerControlView，这是一个播控能力View。
#import <VEPlayerUIModule/VEPlayerUIModule.h>
#import "VEInterfaceSimpleBlockSceneConf.h"

- (VEInterface *)playerControlView {
    if (!_playerControlView) {
        _playerControlView = [[VEInterface alloc] initWithPlayerCore:self.playerController scene:[VEInterfaceSimpleBlockSceneConf new]];
        _playerControlView.delegate = self;
    }
    return _playerControlView;
}





## ChangeLog
链接：https://www.volcengine.com/docs/4/66438


