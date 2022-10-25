/*
 * Version for Flutter
 * © 2022 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import "YMMFAdRevenueConverter.h"
#import <YandexMobileMetrica/YandexMobileMetrica.h>

@implementation YMMFAdRevenueConverter

+ (YMMAdRevenueInfo *)convert:(YMMFAdRevenuePigeon *)pigeon
{
    if (pigeon == nil) {
        return nil;
    }
    YMMMutableAdRevenueInfo *adRevenueInfo = [[YMMMutableAdRevenueInfo alloc] initWithAdRevenue:[NSDecimalNumber decimalNumberWithString:pigeon.adRevenue]
                                                                                       currency:pigeon.currency];
    adRevenueInfo.adType = [self convertAdType:pigeon.adType];
    if (pigeon.adNetwork != nil) {
        adRevenueInfo.adNetwork = pigeon.adNetwork;
    }
    if (pigeon.adUnitId != nil) {
        adRevenueInfo.adUnitID = pigeon.adUnitId;
    }
    if (pigeon.adUnitName != nil) {
        adRevenueInfo.adUnitName = pigeon.adUnitName;
    }
    if (pigeon.adPlacementId != nil) {
        adRevenueInfo.adPlacementID = pigeon.adPlacementId;
    }
    if (pigeon.adPlacementName != nil) {
        adRevenueInfo.adPlacementName = pigeon.adPlacementName;
    }
    if (pigeon.precision != nil) {
        adRevenueInfo.precision = pigeon.precision;
    }
    if (pigeon.payload != nil) {
        adRevenueInfo.payload = pigeon.payload;
    }

    return [adRevenueInfo copy];
}

+ (YMMAdType)convertAdType:(YMMFAdTypePigeon)adType
{
    switch (adType) {
        case YMMFAdTypePigeonUNKNOWN:
            return YMMAdTypeUnknown;
        case YMMFAdTypePigeonNATIVE:
            return YMMAdTypeNative;
        case YMMFAdTypePigeonBANNER:
            return YMMAdTypeBanner;
        case YMMFAdTypePigeonREWARDED:
            return YMMAdTypeRewarded;
        case YMMFAdTypePigeonINTERSTITIAL:
            return YMMAdTypeInterstitial;
        case YMMFAdTypePigeonMREC:
            return YMMAdTypeMrec;
        case YMMFAdTypePigeonOTHER:
            return YMMAdTypeOther;
        default:
            return YMMAdTypeUnknown;
    }
}

@end
