/*
 * Version for Flutter
 * © 2022 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import <YandexMobileMetrica/YandexMobileMetrica.h>
#import "YMMFAppMetricaActivator.h"

@interface YMMFAppMetricaActivator ()

@property(nonatomic, assign) BOOL isActivated;

@end

@implementation YMMFAppMetricaActivator

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isActivated = NO;
    }

    return self;
}


- (void)activateWithConfig:(YMMYandexMetricaConfiguration *)config
{
    @synchronized (self) {
        [YMMYandexMetrica activateWithConfiguration:config];
        self.isActivated = YES;
    }
}

- (BOOL)isAlreadyActivated
{
    @synchronized (self) {
        return self.isActivated;
    }
}


+ (instancetype)sharedInstance
{
    static YMMFAppMetricaActivator *activator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        activator = [[YMMFAppMetricaActivator alloc] init];
    });
    return activator;
}

@end
