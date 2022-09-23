/*
 * Version for Flutter
 * © 2022 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import "YMMFPigeon.h"

@class YMMYandexMetricaConfiguration;

@interface YMMFAppMetricaConfigConverter : NSObject

+ (YMMYandexMetricaConfiguration *)convert:(YMMFAppMetricaConfigPigeon *)pigeon;
+ (NSString *)toJson:(YMMFAppMetricaConfigPigeon *)pigeon;
// do not rename, used in push flutter plugin
+ (YMMYandexMetricaConfiguration *)fromJson:(NSString *)json;

@end
