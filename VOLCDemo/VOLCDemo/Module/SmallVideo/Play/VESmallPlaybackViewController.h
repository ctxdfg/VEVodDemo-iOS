//
//  VESmallPlaybackViewController.h
//  VOLCDemo
//
//  Created by real on 2022/1/12.
//

#import "VEVideoPlayback.h"
#import <VEPlayerUIModule/VEPlayerUIModule.h>
#import "VEVideoModel.h"

@protocol VESmallPlayDataSouce <NSObject>

- (TTVideoEngineVidSource *)playSource;

- (NSString *)playTitle;

@end

@interface VESmallPlaybackViewController : UIViewController

@property (nonatomic, weak) id<VESmallPlayDataSouce> dataSource;

- (id<VEVideoPlayback>)videoPlayer;

- (void)reloadData;

- (void)stopSession;

@end

