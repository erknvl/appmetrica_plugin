/*
 * Version for Flutter
 * © 2022 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import "YMMFPigeon.h"

@interface YMMFAppMetricaImplementation : NSObject <YMMFAppMetricaPigeon>

- (void)activateConfig:(YMMFAppMetricaConfigPigeon *)config error:(FlutterError **)flutterError;
- (void)activateReporterConfig:(YMMFReporterConfigPigeon *)config error:(FlutterError **)flutterError;
- (void)touchReporterApiKey:(NSString *)apiKey error:(FlutterError **)flutterError;
- (NSNumber *)getLibraryApiLevelWithError:(FlutterError **)flutterError;
- (NSString *)getLibraryVersionWithError:(FlutterError **)flutterError;
- (void)resumeSessionWithError:(FlutterError **)flutterError;
- (void)pauseSessionWithError:(FlutterError **)flutterError;
- (void)reportAppOpenDeeplink:(NSString *)deeplink error:(FlutterError **)flutterError;
- (void)reportErrorError:(YMMFErrorDetailsPigeon *)error message:(NSString *)message error:(FlutterError **)flutterError;
- (void)reportErrorWithGroupGroupId:(NSString *)groupId error:(YMMFErrorDetailsPigeon *)error message:(NSString *)message error:(FlutterError **)flutterError;
- (void)reportUnhandledExceptionError:(YMMFErrorDetailsPigeon *)error error:(FlutterError **)flutterError;
- (void)reportEventWithJsonEventName:(NSString *)eventName attributesJson:(NSString *)attributesJson error:(FlutterError **)flutterError;
- (void)reportEventEventName:(NSString *)eventName error:(FlutterError **)flutterError;
- (void)reportReferralUrlReferralUrl:(NSString *)referralUrl error:(FlutterError **)flutterError;
- (void)requestDeferredDeeplinkWithCompletion:(void(^)(YMMFAppMetricaDeferredDeeplinkPigeon *, FlutterError *))flutterCompletion;
- (void)requestDeferredDeeplinkParametersWithCompletion:(void(^)(YMMFAppMetricaDeferredDeeplinkParametersPigeon *, FlutterError *))flutterCompletion;
- (void)requestAppMetricaDeviceIDWithCompletion:(void(^)(YMMFAppMetricaDeviceIdPigeon *, FlutterError *))flutterCompletion;
- (void)sendEventsBufferWithError:(FlutterError **)flutterError;
- (void)setLocationLocation:(YMMFLocationPigeon *)location error:(FlutterError **)flutterError;
- (void)setLocationTrackingEnabled:(NSNumber *)enabled error:(FlutterError **)flutterError;
- (void)setStatisticsSendingEnabled:(NSNumber *)enabled error:(FlutterError **)flutterError;
- (void)setUserProfileIDUserProfileID:(NSString *)userProfileID error:(FlutterError **)flutterError;
- (void)reportUserProfileUserProfile:(YMMFUserProfilePigeon *)userProfile error:(FlutterError **)flutterError;
- (void)putErrorEnvironmentValueKey:(NSString *)key value:(NSString *)value error:(FlutterError **)flutterError;
- (void)reportRevenueRevenue:(YMMFRevenuePigeon *)revenue error:(FlutterError **)flutterError;
- (void)reportECommerceEvent:(YMMFECommerceEventPigeon *)event error:(FlutterError **)flutterError;
- (void)handlePluginInitFinishedWithError:(FlutterError **)flutterError;
- (void)reportAdRevenueAdRevenue:(YMMFAdRevenuePigeon *)adRevenue error:(FlutterError **)flutterError;

@end
