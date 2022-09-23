/*
 * Version for Flutter
 * © 2022 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import "YMMFPigeon.h"

@class YMMRevenueInfo;

@interface YMMFRevenueInfoConverter : NSObject

+ (YMMRevenueInfo *)convert:(YMMFRevenuePigeon *)pigeon;

@end
