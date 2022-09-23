/*
 * Version for Flutter
 * © 2022 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import "YMMFRevenueInfoConverter.h"
#import <YandexMobileMetrica/YandexMobileMetrica.h>

@implementation YMMFRevenueInfoConverter

+ (YMMRevenueInfo *)convert:(YMMFRevenuePigeon *)pigeon
{
    YMMMutableRevenueInfo *revenueInfo = [[YMMMutableRevenueInfo alloc] initWithPriceDecimal:[NSDecimalNumber decimalNumberWithString:pigeon.price]
                                                                                    currency:pigeon.currency];
    if (pigeon.quantity != nil) {
        revenueInfo.quantity = pigeon.quantity.unsignedLongValue;
    }
    if (pigeon.productId != nil) {
        revenueInfo.productID = pigeon.productId;
    }
    if (pigeon.transactionId != nil) {
        revenueInfo.transactionID = pigeon.transactionId;
    }
    if (pigeon.receipt != nil && pigeon.receipt.data != nil) {
        revenueInfo.receiptData = [pigeon.receipt.data dataUsingEncoding:NSUTF8StringEncoding];
    }
    if (pigeon.payload != nil) {
        revenueInfo.payload = [self parsePayload:pigeon.payload];
    }

    return [revenueInfo copy];
}

+ (NSDictionary *)parsePayload:(NSString *)payload
{
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[payload dataUsingEncoding:NSUTF8StringEncoding]
                                                         options:kNilOptions
                                                           error:&error];
    if (error == nil && (dict == nil || [dict isKindOfClass:[NSDictionary class]])) {
        return dict;
    }
    else {
        NSLog(@"Invalid revenue payload to report to AppMetrica %@", payload);
        return nil;
    }
}

@end
