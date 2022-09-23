/*
 * Version for Flutter
 * © 2022 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import "YMMFECommerceConverter.h"
#import <YandexMobileMetrica/YandexMobileMetrica.h>

@implementation YMMFECommerceConverter

NSString *const SHOW_SCREEN_EVENT = @"show_screen_event";
NSString *const SHOW_PRODUCT_CARD_EVENT = @"show_product_card_event";
NSString *const SHOW_PRODUCT_DETAILS_EVENT = @"show_product_details_event";
NSString *const ADD_CART_ITEM_EVENT = @"add_cart_item_event";
NSString *const REMOVE_CART_ITEM_EVENT = @"remove_cart_item_event";
NSString *const BEGIN_CHECKOUT_EVENT = @"begin_checkout_event";
NSString *const PURCHASE_EVENT = @"purchase_event";

+ (YMMECommerce *)convert:(YMMFECommerceEventPigeon *)pigeon
{
    if ([SHOW_SCREEN_EVENT isEqualToString:pigeon.eventType]) {
        return [YMMECommerce showScreenEventWithScreen:[self convertScreen:pigeon.screen]];
    }
    if ([SHOW_PRODUCT_CARD_EVENT isEqualToString:pigeon.eventType]) {
        return [YMMECommerce showProductCardEventWithProduct:[self convertProduct:pigeon.product]
                                                      screen:[self convertScreen:pigeon.screen]];
    }
    if ([SHOW_PRODUCT_DETAILS_EVENT isEqualToString:pigeon.eventType]) {
        return [YMMECommerce showProductDetailsEventWithProduct:[self convertProduct:pigeon.product]
                                                       referrer:[self convertReferrer:pigeon.referrer]];
    }
    if ([ADD_CART_ITEM_EVENT isEqualToString:pigeon.eventType]) {
        return [YMMECommerce addCartItemEventWithItem:[self convertCartItem:pigeon.cartItem]];
    }
    if ([REMOVE_CART_ITEM_EVENT isEqualToString:pigeon.eventType]) {
        return [YMMECommerce removeCartItemEventWithItem:[self convertCartItem:pigeon.cartItem]];
    }
    if ([BEGIN_CHECKOUT_EVENT isEqualToString:pigeon.eventType]) {
        return [YMMECommerce beginCheckoutEventWithOrder:[self convertOrder:pigeon.order]];
    }
    if ([PURCHASE_EVENT isEqualToString:pigeon.eventType]) {
        return [YMMECommerce purchaseEventWithOrder:[self convertOrder:pigeon.order]];
    }
    return nil;
}

+ (YMMECommerceScreen *)convertScreen:(YMMFECommerceScreenPigeon *)pigeon
{
    if (pigeon == nil) {
        return nil;
    }
    return [[YMMECommerceScreen alloc] initWithName:pigeon.name
                                 categoryComponents:pigeon.categoriesPath
                                        searchQuery:pigeon.searchQuery
                                            payload:pigeon.payload];
}

+ (YMMECommerceProduct *)convertProduct:(YMMFECommerceProductPigeon *)pigeon
{
    if (pigeon == nil) {
        return nil;
    }
    return [[YMMECommerceProduct alloc] initWithSKU:pigeon.sku
                                               name:pigeon.name
                                 categoryComponents:pigeon.categoriesPath
                                            payload:pigeon.payload
                                        actualPrice:[self convertPrice:pigeon.actualPrice]
                                      originalPrice:[self convertPrice:pigeon.originalPrice]
                                         promoCodes:pigeon.promocodes];
}

+ (YMMECommercePrice *)convertPrice:(YMMFECommercePricePigeon *)pigeon
{
    if (pigeon == nil) {
        return nil;
    }
    NSMutableArray<YMMECommerceAmount *> *internalComponents = [NSMutableArray arrayWithCapacity:[pigeon.internalComponents count]];
    [pigeon.internalComponents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [internalComponents addObject:[self convertAmount:obj]];
    }];
    return [[YMMECommercePrice alloc] initWithFiat:[self convertAmount:pigeon.fiat]
                                                    internalComponents:internalComponents];
}

+ (YMMECommerceAmount *)convertAmount:(YMMFECommerceAmountPigeon *)pigeon
{
    if (pigeon == nil) {
        return nil;
    }
    return [[YMMECommerceAmount alloc] initWithUnit:pigeon.currency
                                              value:[NSDecimalNumber decimalNumberWithString:pigeon.amount]];
}

+ (YMMECommerceReferrer *)convertReferrer:(YMMFECommerceReferrerPigeon *)pigeon
{
    if (pigeon == nil) {
        return nil;
    }
    return [[YMMECommerceReferrer alloc] initWithType:pigeon.type
                                           identifier:pigeon.identifier
                                               screen:[self convertScreen:pigeon.screen]];
}

+ (YMMECommerceCartItem *)convertCartItem:(YMMFECommerceCartItemPigeon *)pigeon
{
    if (pigeon == nil) {
        return nil;
    }
    return [[YMMECommerceCartItem alloc] initWithProduct:[self convertProduct:pigeon.product]
                                                quantity:[NSDecimalNumber decimalNumberWithString:pigeon.quantity]
                                                 revenue:[self convertPrice:pigeon.revenue]
                                                referrer:[self convertReferrer:pigeon.referrer]];
}

+ (YMMECommerceOrder *)convertOrder:(YMMFECommerceOrderPigeon *)pigeon
{
    if (pigeon == nil) {
        return nil;
    }
    NSMutableArray<YMMECommerceCartItem *> *cartItems = [NSMutableArray arrayWithCapacity:[pigeon.items count]];
    [pigeon.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [cartItems addObject:[self convertCartItem:obj]];
    }];
    return [[YMMECommerceOrder alloc] initWithIdentifier:pigeon.identifier
                                               cartItems:cartItems
                                                 payload:pigeon.payload];
}

@end
