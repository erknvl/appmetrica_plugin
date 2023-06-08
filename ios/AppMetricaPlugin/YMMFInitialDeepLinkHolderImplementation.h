/*
 * Version for Flutter
 * © 2023 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import "YMMFPigeon.h"

@interface YMMFInitialDeepLinkHolderImplementation : NSObject <YMMFInitialDeepLinkHolderPigeon>

- (void)setInitialDeeplink:(NSString *)deeplink;
- (NSString *)getInitialDeeplinkWithError:(FlutterError **)error;

@end
