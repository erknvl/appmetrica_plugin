/*
 * Version for Flutter
 * © 2022 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import "YMMFAppMetricaPlugin.h"
#import "YMMFPigeon.h"
#import "YMMFAppMetricaImplementation.h"
#import "YMMFReporterImplementation.h"
#import "YMMFAppMetricaConfigConverterImplementation.h"
#import "YMMFInitialDeepLinkHolderImplementation.h"

@interface YMMFAppMetricaPlugin()
@property(nonatomic, strong) YMMFInitialDeepLinkHolderImplementation *deeplinkHolder;
@end

@implementation YMMFAppMetricaPlugin

+ (instancetype)sharedInstance
{
    static YMMFAppMetricaPlugin *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YMMFAppMetricaPlugin alloc] init];
    });
    return instance;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar
{
    YMMFAppMetricaPlugin *instance = [YMMFAppMetricaPlugin sharedInstance];
    instance.deeplinkHolder = [[YMMFInitialDeepLinkHolderImplementation alloc] init];
    [registrar addApplicationDelegate:instance];

    YMMFAppMetricaPigeonSetup(registrar.messenger, [[YMMFAppMetricaImplementation alloc] init]);
    YMMFReporterPigeonSetup(registrar.messenger, [[YMMFReporterImplementation alloc] init]);
    YMMFAppMetricaConfigConverterPigeonSetup(registrar.messenger, [[YMMFAppMetricaConfigConverterImplementation alloc] init]);
    YMMFInitialDeepLinkHolderPigeonSetup(registrar.messenger, instance.deeplinkHolder);
}

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSURL *url = [self extractDeeplink:launchOptions];
    [self.deeplinkHolder setInitialDeeplink:[url absoluteString]];
    return YES;
}

- (NSURL *)extractDeeplink:(NSDictionary *)launchOptions
{
    NSURL *__block openUrl = nil;
    if ([launchOptions[UIApplicationLaunchOptionsURLKey] isKindOfClass:NSURL.class]) {
        openUrl = launchOptions[UIApplicationLaunchOptionsURLKey];
    }
    if (openUrl.absoluteString.length == 0) {
        if ([launchOptions[UIApplicationLaunchOptionsUserActivityDictionaryKey] isKindOfClass:NSDictionary.class]) {
            NSDictionary *userActivity = launchOptions[UIApplicationLaunchOptionsUserActivityDictionaryKey];
            [userActivity enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
                if ([value isKindOfClass:NSUserActivity.class]) {
                    NSUserActivity *activity = value;
                    openUrl = activity.webpageURL;
                    *stop = YES;
                }
            }];
        }
    }
    return openUrl;
}

@end
