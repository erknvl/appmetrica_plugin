/*
 * Version for Flutter
 * © 2022 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import "YMMFAppMetricaImplementation.h"
#import "YMMFECommerceConverter.h"
#import "YMMFLocationConverter.h"
#import "YMMFRevenueInfoConverter.h"
#import <YandexMobileMetrica/YandexMobileMetrica.h>
#import "YMMFUserProfileConverter.h"
#import "YMMFAppMetricaConfigConverter.h"
#import "YMMFPluginErrorDetailsConverter.h"
#import "YMMFAppMetricaActivator.h"

@implementation YMMFAppMetricaImplementation

- (void)activateConfig:(YMMFAppMetricaConfigPigeon *)config error:(FlutterError **)flutterError
{
    [[YMMFAppMetricaActivator sharedInstance] activateWithConfig:[YMMFAppMetricaConfigConverter convert:config]];
}

- (void)activateReporterConfig:(YMMFReporterConfigPigeon *)config error:(FlutterError **)flutterError
{
    YMMMutableReporterConfiguration *configuration = [[YMMMutableReporterConfiguration alloc] initWithApiKey:config.apiKey];
    if (config.sessionTimeout != nil) {
        configuration.sessionTimeout = config.sessionTimeout.unsignedLongValue;
    }
    if (config.statisticsSending != nil) {
        configuration.statisticsSending = config.statisticsSending.boolValue;
    }
    if (config.maxReportsInDatabaseCount != nil) {
        configuration.maxReportsInDatabaseCount = config.maxReportsInDatabaseCount.unsignedLongValue;
    }
    if (config.userProfileID != nil) {
        configuration.userProfileID = config.userProfileID;
    }
    if (config.logs != nil) {
        configuration.logs = config.logs.boolValue;
    }
    [YMMYandexMetrica activateReporterWithConfiguration:configuration];
}

- (void)touchReporterApiKey:(NSString *)apiKey error:(FlutterError **)flutterError
{
    [YMMYandexMetrica reporterForApiKey:apiKey];
}

- (NSNumber *)getLibraryApiLevelWithError:(FlutterError **)flutterError
{
    return nil;
}

- (NSString *)getLibraryVersionWithError:(FlutterError **)flutterError
{
    return [YMMYandexMetrica libraryVersion];
}

- (void)resumeSessionWithError:(FlutterError **)flutterError
{
    [YMMYandexMetrica resumeSession];
}

- (void)pauseSessionWithError:(FlutterError **)flutterError
{
    [YMMYandexMetrica pauseSession];
}

- (void)reportAppOpenDeeplink:(NSString *)deeplink error:(FlutterError **)flutterError
{
    [YMMYandexMetrica handleOpenURL:[NSURL URLWithString:deeplink]];
}

- (void)reportErrorError:(YMMFErrorDetailsPigeon *)error message:(nullable NSString *)message error:(FlutterError **)flutterError
{
    [[YMMYandexMetrica getPluginExtension] reportError:[YMMFPluginErrorDetailsConverter convert:error]
                                               message:message
                                             onFailure:nil];
}

- (void)reportErrorWithGroupGroupId:(NSString *)groupId error:(YMMFErrorDetailsPigeon *)error message:(nullable NSString *)message error:(FlutterError **)flutterError
{
    [[YMMYandexMetrica getPluginExtension] reportErrorWithIdentifier:groupId
                                                             message:message
                                                             details:[YMMFPluginErrorDetailsConverter convert:error]
                                                           onFailure:nil];
}

- (void)reportUnhandledExceptionError:(YMMFErrorDetailsPigeon *)error error:(FlutterError **)flutterError
{
    [[YMMYandexMetrica getPluginExtension] reportUnhandledException:[YMMFPluginErrorDetailsConverter convert:error]
                                                          onFailure:nil];
}

- (void)reportEventWithJsonEventName:(NSString *)eventName attributesJson:(nullable NSString *)attributesJson error:(FlutterError **)flutterError
{
    NSDictionary *attributes = nil;
    NSError *error = nil;
    if (attributesJson != nil) {
        attributes = [NSJSONSerialization JSONObjectWithData:[attributesJson dataUsingEncoding:NSUTF8StringEncoding]
                                                     options:kNilOptions
                                                       error:&error];
    }
    if (error == nil && (attributes == nil || [attributes isKindOfClass:[NSDictionary class]])) {
        [YMMYandexMetrica reportEvent:eventName
                           parameters:attributes
                            onFailure:nil];
    }
    else {
        NSLog(@"Invalid attributesJson to report to AppMetrica %@", attributesJson);
    }
}

- (void)reportEventEventName:(NSString *)eventName error:(FlutterError **)flutterError
{
    [YMMYandexMetrica reportEvent:eventName
                        onFailure:nil];
}

- (void)reportReferralUrlReferralUrl:(NSString *)referralUrl error:(FlutterError **)flutterError
{
    [YMMYandexMetrica reportReferralUrl:[NSURL URLWithString:referralUrl]];
}

- (void)requestDeferredDeeplinkWithCompletion:(void(^)(YMMFAppMetricaDeferredDeeplinkPigeon *, FlutterError *))flutterCompletion
{
    YMMFAppMetricaDeferredDeeplinkErrorPigeon *error = [YMMFAppMetricaDeferredDeeplinkErrorPigeon makeWithReason:YMMFAppMetricaDeferredDeeplinkReasonPigeonUNKNOWN
                                                                                                     description:@""
                                                                                                         message:nil];
    flutterCompletion([YMMFAppMetricaDeferredDeeplinkPigeon makeWithDeeplink:nil
                                                                       error:error], nil);
}

- (void)requestDeferredDeeplinkParametersWithCompletion:(void(^)(YMMFAppMetricaDeferredDeeplinkParametersPigeon *, FlutterError *))flutterCompletion
{
    YMMFAppMetricaDeferredDeeplinkErrorPigeon *error = [YMMFAppMetricaDeferredDeeplinkErrorPigeon makeWithReason:YMMFAppMetricaDeferredDeeplinkReasonPigeonUNKNOWN
                                                                                                     description:@""
                                                                                                         message:nil];
    flutterCompletion([YMMFAppMetricaDeferredDeeplinkParametersPigeon makeWithParameters:nil
                                                                                   error:error], nil);
}

- (void)requestAppMetricaDeviceIDWithCompletion:(void(^)(YMMFAppMetricaDeviceIdPigeon *, FlutterError *))flutterCompletion
{
    [YMMYandexMetrica requestAppMetricaDeviceIDWithCompletionQueue:nil
                                                   completionBlock:^(NSString *appMetricaDeviceID, NSError *error) {
        if (error == nil) {
            flutterCompletion([YMMFAppMetricaDeviceIdPigeon makeWithDeviceId:appMetricaDeviceID
                                                                 errorReason:YMMFAppMetricaDeviceIdReasonPigeonNO_ERROR], nil);
        } else {
            if ([error.domain isEqualToString:NSURLErrorDomain]) {
                flutterCompletion([YMMFAppMetricaDeviceIdPigeon makeWithDeviceId:nil
                                                                     errorReason:YMMFAppMetricaDeviceIdReasonPigeonNETWORK], nil);
            }
            else {
                flutterCompletion([YMMFAppMetricaDeviceIdPigeon makeWithDeviceId:nil
                                                                     errorReason:YMMFAppMetricaDeviceIdReasonPigeonUNKNOWN], nil);
            }
        }
    }];
}

- (void)sendEventsBufferWithError:(FlutterError **)flutterError
{
    [YMMYandexMetrica sendEventsBuffer];
}

- (void)setLocationLocation:(YMMFLocationPigeon *)location error:(FlutterError **)flutterError
{
    [YMMYandexMetrica setLocation:[YMMFLocationConverter convert:location]];
}

- (void)setLocationTrackingEnabled:(NSNumber *)enabled error:(FlutterError **)flutterError
{
    [YMMYandexMetrica setLocationTracking:enabled.boolValue];
}

- (void)setStatisticsSendingEnabled:(NSNumber *)enabled error:(FlutterError **)flutterError
{
    [YMMYandexMetrica setStatisticsSending:enabled.boolValue];
}

- (void)setUserProfileIDUserProfileID:(nullable NSString *)userProfileID error:(FlutterError **)flutterError
{
    [YMMYandexMetrica setUserProfileID:userProfileID];
}

- (void)reportUserProfileUserProfile:(YMMFUserProfilePigeon *)userProfile error:(FlutterError **)error
{
    [YMMYandexMetrica reportUserProfile:[YMMFUserProfileConverter convert:userProfile] onFailure:nil];
}

- (void)putErrorEnvironmentValueKey:(NSString *)key value:(nullable NSString *)value error:(FlutterError **)flutterError
{
    [YMMYandexMetrica setErrorEnvironmentValue:value
                                        forKey:key];
}

- (void)reportRevenueRevenue:(YMMFRevenuePigeon *)revenue error:(FlutterError **)flutterError
{
    [YMMYandexMetrica reportRevenue:[YMMFRevenueInfoConverter convert:revenue]
                          onFailure:nil];
}

- (void)reportECommerceEvent:(YMMFECommerceEventPigeon *)event error:(FlutterError **)flutterError
{
    [YMMYandexMetrica reportECommerce:[YMMFECommerceConverter convert:event]
                            onFailure:nil];
}

- (void)handlePluginInitFinishedWithError:(FlutterError **)flutterError
{
    [[YMMYandexMetrica getPluginExtension] handlePluginInitFinished];
}

@end
