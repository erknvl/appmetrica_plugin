/*
 * Version for Flutter
 * © 2022 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import <YandexMobileMetrica/YandexMobileMetrica.h>
#import "YMMFReporterImplementation.h"
#import "YMMFRevenueInfoConverter.h"
#import "YMMFECommerceConverter.h"
#import "YMMFUserProfileConverter.h"
#import "YMMFPluginErrorDetailsConverter.h"

@implementation YMMFReporterImplementation

- (void)sendEventsBufferApiKey:(NSString *)apiKey error:(FlutterError **)flutterError
{
    [[YMMYandexMetrica reporterForApiKey:apiKey] sendEventsBuffer];
}

- (void)reportEventApiKey:(NSString *)apiKey eventName:(NSString *)eventName error:(FlutterError **)flutterError
{
    [[YMMYandexMetrica reporterForApiKey:apiKey] reportEvent:eventName onFailure:nil];
}

- (void)reportEventWithJsonApiKey:(NSString *)apiKey
                        eventName:(NSString *)eventName
                   attributesJson:(nullable NSString *)attributesJson
                            error:(FlutterError **)flutterError
{
    NSDictionary *attributes = nil;
    NSError *jsonValidationError = nil;
    if (attributesJson != nil) {
        attributes = [NSJSONSerialization JSONObjectWithData:[attributesJson dataUsingEncoding:NSUTF8StringEncoding]
                                                     options:kNilOptions
                                                       error:&jsonValidationError];
    }
    if (jsonValidationError == nil && (attributes == nil || [attributes isKindOfClass:[NSDictionary class]])) {
        [[YMMYandexMetrica reporterForApiKey:apiKey] reportEvent:eventName
                                                      parameters:attributes
                                                       onFailure:nil];
    }
    else {
        NSLog(@"Invalid attributesJson to report to AppMetrica %@", attributesJson);
    }
}

- (void)reportErrorApiKey:(NSString *)apiKey
                    error:(YMMFErrorDetailsPigeon *)error
                  message:(nullable NSString *)message
                    error:(FlutterError **)flutterError
{
    [[[YMMYandexMetrica reporterForApiKey:apiKey] getPluginExtension] reportError:[YMMFPluginErrorDetailsConverter convert:error]
                                                                          message:message
                                                                        onFailure:nil];
}

- (void)reportErrorWithGroupApiKey:(NSString *)apiKey
                           groupId:(NSString *)groupId
                             error:(nullable YMMFErrorDetailsPigeon *)error
                           message:(nullable NSString *)message
                             error:(FlutterError **)flutterError
{
    [[[YMMYandexMetrica reporterForApiKey:apiKey] getPluginExtension] reportErrorWithIdentifier:groupId
                                                                                        message:message
                                                                                        details:[YMMFPluginErrorDetailsConverter convert:error]
                                                                                      onFailure:nil];
}

- (void)reportUnhandledExceptionApiKey:(NSString *)apiKey
                                 error:(YMMFErrorDetailsPigeon *)error
                                 error:(FlutterError **)flutterError
{
    [[[YMMYandexMetrica reporterForApiKey:apiKey] getPluginExtension] reportUnhandledException:[YMMFPluginErrorDetailsConverter convert:error]
                                                                                     onFailure:nil];
}

- (void)resumeSessionApiKey:(NSString *)apiKey error:(FlutterError **)flutterError
{
    [[YMMYandexMetrica reporterForApiKey:apiKey] resumeSession];
}

- (void)pauseSessionApiKey:(NSString *)apiKey error:(FlutterError **)flutterError
{
    [[YMMYandexMetrica reporterForApiKey:apiKey] pauseSession];
}

- (void)setStatisticsSendingApiKey:(NSString *)apiKey enabled:(NSNumber *)enabled error:(FlutterError **)flutterError
{
    [[YMMYandexMetrica reporterForApiKey:apiKey] setStatisticsSending:enabled.boolValue];
}

- (void)setUserProfileIDApiKey:(NSString *)apiKey
                 userProfileID:(nullable NSString *)userProfileID
                         error:(FlutterError **)flutterError
{
    [[YMMYandexMetrica reporterForApiKey:apiKey] setUserProfileID:userProfileID];
}

- (void)reportUserProfileApiKey:(NSString *)apiKey
                    userProfile:(YMMFUserProfilePigeon *)userProfile
                          error:(FlutterError **)flutterError {
    [[YMMYandexMetrica reporterForApiKey:apiKey] reportUserProfile:[YMMFUserProfileConverter convert:userProfile] onFailure:nil];
}

- (void)reportRevenueApiKey:(NSString *)apiKey revenue:(YMMFRevenuePigeon *)revenue error:(FlutterError **)flutterError
{
    [[YMMYandexMetrica reporterForApiKey:apiKey] reportRevenue:[YMMFRevenueInfoConverter convert:revenue] onFailure:nil];
}

- (void)reportECommerceApiKey:(NSString *)apiKey event:(YMMFECommerceEventPigeon *)event error:(FlutterError **)flutterError
{
    [[YMMYandexMetrica reporterForApiKey:apiKey] reportECommerce:[YMMFECommerceConverter convert:event] onFailure:nil];
}

@end
