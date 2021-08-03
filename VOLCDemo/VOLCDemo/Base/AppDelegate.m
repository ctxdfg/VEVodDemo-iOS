
//
//  AppDelegate.m
//  VOLCDemo
//
//  Created by real on 2021/5/21.
//

#import "AppDelegate.h"
#import "VOLCMainViewController.h"
#import "VOLCUserGlobalConfiguration.h"
#import <TTSDK/TTSDKManager.h>
#import <TTSDK/TTVideoEngineHeader.h>

#if __has_include(<RangersAppLog/RangersAppLogCore.h>)
#import <RangersAppLog/RangersAppLogCore.h>
#endif


FOUNDATION_EXTERN NSString * const TTLicenseNotificationLicenseDidAdd;
FOUNDATION_EXTERN NSString * const TTLicenseNotificationLicenseInfoDidUpdate;;
FOUNDATION_EXTERN NSString * const TTLicenseNotificationLicenseResultKey;


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [UIWindow new];
    self.window.frame = UIScreen.mainScreen.bounds;
    self.window.backgroundColor = [UIColor blackColor];
 
    VOLCMainViewController *mainController = [VOLCMainViewController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainController];
    
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    /// global config
    [VOLCUserGlobalConfiguration sharedInstance];
    
    /// init ttsdk
    [self initTTSDKWithOptions:launchOptions];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /// Don’t forget, this code must be added ！！！
    [TTVideoEngine stopOpenGLESActivity];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /// Don’t forget, this code must be added ！！！
    [TTVideoEngine startOpenGLESActivity];
}


#pragma mark - TTSDK init

- (void)initTTSDKWithOptions:(NSDictionary *)launchOptions {
    NSString *appId = @"229234";
    NSString *appName = @"ToB_Demo";
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *bundleId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    NSString *channelName = @"test_channel"; // channel name
    
    /// Initialize TTSDK, configure Lisence ，this step cannot be skipped !!!!!
    /// TTSDK default config app log, appLog depends on RangersAppLog SDK.
    /// If your APP has been connected to RangersAppLog SDK before, please set "configuration.shouldInitAppLog = NO".
    TTSDKConfiguration *configuration = [TTSDKConfiguration defaultConfigurationWithAppID:appId];
    configuration.appName = appName;
    configuration.channel = channelName;
    configuration.bundleID = bundleId;
    configuration.shouldInitAppLog = YES;
    configuration.serviceVendor = TTSDKServiceVendorCN;
    configuration.licenseFilePath = [NSBundle.mainBundle pathForResource:@"VOLC-PlayerDemo.lic" ofType:nil];
#if DEBUG
    /// add lisence observer，suggest debug open
    [self addLicenseObserver];
#endif
    [TTSDKManager startWithConfiguration:configuration];
    
    
    /// Initialize TTVideoEngine
    NSDictionary *appInfo = @{TTVideoEngineAID: [NSNumber numberWithLongLong:[appId longLongValue]],
                              TTVideoEngineAppName:appName,
                              TTVideoEngineChannel:channelName,
                              TTVideoEngineAppVersion:appVersion,
                              TTVideoEngineServiceVendor:@(TTVideoEngineServiceVendorCN)
    };
    [TTVideoEngine configureAppInfo:appInfo];
    
    
    /// Configuration data loading module MDL (Media Data Loader)
    /// When TTVideoEngine play video, MDL to download video data and manage video cache. MDL will act as a proxy for the player's I/O module. When there is no buffer, it can play while buffering, reducing playback pauses. When there is a cache, use the cache to start broadcasting to improve the speed of starting broadcasting.
    /// Note: Please configure and enable the MDL module before creating the TTVideoEngine instance.
    TTVideoEngine.ls_localServerConfigure.maxCacheSize = 300 * 1024 * 1024; // example 300M （default 100M）
    NSString *cacheDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"com.video.cache"];
    TTVideoEngine.ls_localServerConfigure.cachDirectory = cacheDir; // cache path
    [TTVideoEngine ls_start]; // start MDL
    
#ifdef DEBUG
    // print debug log，suggest debug open
    [TTVideoEngine setLogFlag:TTVideoEngineLogFlagPrint];
#endif
}


#pragma mark - Add license observer

- (void)addLicenseObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(licenseDidAdd:) name:TTLicenseNotificationLicenseDidAdd object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(licenseInfoDidUpdate:) name:TTLicenseNotificationLicenseInfoDidUpdate object:nil];
}

- (void)licenseDidAdd:(NSNotification *)noti {
    NSNumber *success = [noti userInfo][TTLicenseNotificationLicenseResultKey];
    BOOL isSuccess = [success boolValue];
    if (isSuccess) {
        NSLog(@"add license successfully");
    } else {
        NSLog(@"failed to add license");
    }
}

- (void)licenseInfoDidUpdate:(NSNotification *)noti {
    NSNumber *success = [noti userInfo][TTLicenseNotificationLicenseResultKey];
    BOOL isSuccess = [success boolValue];
    if (isSuccess) {
        NSLog(@"update license successfully");
    } else {
        NSLog(@"failed to update license");
    }
}


@end
