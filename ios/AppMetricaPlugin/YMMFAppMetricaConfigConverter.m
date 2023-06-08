/*
 * Version for Flutter
 * © 2022 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import "YMMFAppMetricaConfigConverter.h"
#import "YMMFLocationConverter.h"
#import <YandexMobileMetrica/YandexMobileMetrica.h>

@interface YMMFAppMetricaConfigPigeon ()
+ (YMMFAppMetricaConfigPigeon *)fromMap:(NSDictionary *)dict;
- (NSDictionary *)toMap;
@end

@implementation YMMFAppMetricaConfigConverter

+ (YMMYandexMetricaConfiguration *)convert:(YMMFAppMetricaConfigPigeon *)pigeon
{
    YMMYandexMetricaConfiguration *configuration = [[YMMYandexMetricaConfiguration alloc] initWithApiKey:pigeon.apiKey];
    if (pigeon.appVersion != nil) {
        configuration.appVersion = pigeon.appVersion;
    }
    if (pigeon.crashReporting != nil) {
        configuration.crashReporting = pigeon.crashReporting.boolValue;
    }
    if (pigeon.firstActivationAsUpdate != nil) {
        [configuration setHandleFirstActivationAsUpdate:pigeon.firstActivationAsUpdate.boolValue];
    }
    if (pigeon.location != nil) {
        configuration.location = [YMMFLocationConverter convert:pigeon.location];
    }
    if (pigeon.locationTracking != nil) {
        configuration.locationTracking = pigeon.locationTracking.boolValue;
    }
    if (pigeon.logs != nil) {
        configuration.logs = pigeon.logs.boolValue;
    }
    if (pigeon.sessionTimeout != nil) {
        configuration.sessionTimeout = pigeon.sessionTimeout.unsignedIntegerValue;
    }
    if (pigeon.statisticsSending != nil) {
        configuration.statisticsSending = pigeon.statisticsSending.boolValue;
    }
    if (pigeon.preloadInfo != nil) {
        YMMYandexMetricaPreloadInfo *info = [[YMMYandexMetricaPreloadInfo alloc] initWithTrackingIdentifier:pigeon.preloadInfo.trackingId];
        for (NSString *key in pigeon.preloadInfo.additionalInfo) {
            [info setAdditionalInfo:pigeon.preloadInfo.additionalInfo[key] forKey:key];
        }
        configuration.preloadInfo = info;
    }
    if (pigeon.maxReportsInDatabaseCount != nil) {
        configuration.maxReportsInDatabaseCount = pigeon.maxReportsInDatabaseCount.unsignedLongValue;
    }
    if (pigeon.sessionsAutoTracking != nil) {
        configuration.sessionsAutoTracking = pigeon.sessionsAutoTracking.boolValue;
    }
    if (pigeon.errorEnvironment != nil) {
        for (NSString *key in pigeon.errorEnvironment) {
            [YMMYandexMetrica setErrorEnvironmentValue:pigeon.errorEnvironment[key] forKey:key];
        }
    }
    if (pigeon.userProfileID != nil) {
        configuration.userProfileID = pigeon.userProfileID;
    }
    if (pigeon.revenueAutoTracking != nil) {
        configuration.revenueAutoTrackingEnabled = pigeon.revenueAutoTracking.boolValue;
    }
    if (pigeon.appOpenTrackingEnabled != nil) {
        configuration.appOpenTrackingEnabled = pigeon.appOpenTrackingEnabled.boolValue;
    }
    return configuration;
}

+ (NSString *)toJson:(YMMFAppMetricaConfigPigeon *)pigeon
{
    NSDictionary *configMap = [pigeon toMap];
    NSError *jsonError = nil;
    NSData *json = [NSJSONSerialization dataWithJSONObject:configMap options:0 error:&jsonError];
    if (jsonError == nil && json != nil) {
        return [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    } else {
        return nil;
    }
}

+ (YMMYandexMetricaConfiguration *)fromJson:(NSString *)json
{
    if (json != nil) {
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                                             options:0
                                                               error:&error];
        if (error == nil && dict != nil && [dict isKindOfClass:[NSDictionary class]]) {
            YMMFAppMetricaConfigPigeon *pigeon = [YMMFAppMetricaConfigPigeon fromMap:dict];
            return [YMMFAppMetricaConfigConverter convert:pigeon];
        }
    }
    return nil;
}

@end
