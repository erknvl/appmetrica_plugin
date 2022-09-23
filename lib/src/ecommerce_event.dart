/*
 * Version for Flutter
 * © 2022
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

import 'ecommerce.dart';
import 'appmetrica_api_pigeon.dart';

class ECommerceEvent {
  static const String _SHOW_SCREEN_EVENT = "show_screen_event";
  static const String _SHOW_PRODUCT_CARD_EVENT = "show_product_card_event";
  static const String _SHOW_PRODUCT_DETAILS_EVENT =
      "show_product_details_event";
  static const String _ADD_CART_ITEM_EVENT = "add_cart_item_event";
  static const String _REMOVE_CART_ITEM_EVENT = "remove_cart_item_event";
  static const String _BEGIN_CHECKOUT_EVENT = "begin_checkout_event";
  static const String _PURCHASE_EVENT = "purchase_event";

  final String _eventType;

  final ECommerceCartItem? _cartItem;
  final ECommerceOrder? _order;
  final ECommerceProduct? _product;
  final ECommerceReferrer? _referrer;
  final ECommerceScreen? _screen;

  ECommerceEvent._(this._eventType, this._cartItem, this._order, this._product,
      this._referrer, this._screen);

  ECommerceEvent._showScreen(ECommerceScreen screen)
      : this._(_SHOW_SCREEN_EVENT, null, null, null, null, screen);

  ECommerceEvent._showProductCardEvent(
      ECommerceProduct product, ECommerceScreen screen)
      : this._(_SHOW_PRODUCT_CARD_EVENT, null, null, product, null, screen);

  ECommerceEvent._showProductDetailsEvent(
      ECommerceProduct product, ECommerceReferrer? referrer)
      : this._(
            _SHOW_PRODUCT_DETAILS_EVENT, null, null, product, referrer, null);

  ECommerceEvent._addCartItemEvent(ECommerceCartItem cartItem)
      : this._(_ADD_CART_ITEM_EVENT, cartItem, null, null, null, null);

  ECommerceEvent._removeCartItemEvent(ECommerceCartItem cartItem)
      : this._(_REMOVE_CART_ITEM_EVENT, cartItem, null, null, null, null);

  ECommerceEvent._beginCheckoutEvent(ECommerceOrder order)
      : this._(_BEGIN_CHECKOUT_EVENT, null, order, null, null, null);

  ECommerceEvent._purchaseEvent(ECommerceOrder order)
      : this._(_PURCHASE_EVENT, null, order, null, null, null);
}

class ECommerceConstructors {
  ECommerceConstructors._();

  static ECommerceEvent showScreenEvent(ECommerceScreen screen) =>
      ECommerceEvent._showScreen(screen);

  static ECommerceEvent showProductCardEvent(
          ECommerceProduct product, ECommerceScreen screen) =>
      ECommerceEvent._showProductCardEvent(product, screen);

  static ECommerceEvent showProductDetailsEvent(
          ECommerceProduct product, ECommerceReferrer? referrer) =>
      ECommerceEvent._showProductDetailsEvent(product, referrer);

  static ECommerceEvent addCartItemEvent(ECommerceCartItem cartItem) =>
      ECommerceEvent._addCartItemEvent(cartItem);

  static ECommerceEvent removeCartItemEvent(ECommerceCartItem cartItem) =>
      ECommerceEvent._removeCartItemEvent(cartItem);

  static ECommerceEvent beginCheckoutEvent(ECommerceOrder order) =>
      ECommerceEvent._beginCheckoutEvent(order);

  static ECommerceEvent purchaseEvent(ECommerceOrder order) =>
      ECommerceEvent._purchaseEvent(order);
}

extension ECommerceConverter on ECommerceEvent {
  ECommerceEventPigeon toPigeon() => _findConverter(ECommerceEvent)(this);
}

extension ECommerceScreenConverter on ECommerceScreen {
  ECommerceScreenPigeon toPigeon() => _findConverter(ECommerceScreen)(this);
}

extension ECommerceProductConverter on ECommerceProduct {
  ECommerceProductPigeon toPigeon() => _findConverter(ECommerceProduct)(this);
}

extension ECommerceReferrerConverter on ECommerceReferrer {
  ECommerceReferrerPigeon toPigeon() => _findConverter(ECommerceReferrer)(this);
}

extension ECommerceCartItemConverter on ECommerceCartItem {
  ECommerceCartItemPigeon toPigeon() => _findConverter(ECommerceCartItem)(this);
}

extension ECommerceOrderConverter on ECommerceOrder {
  ECommerceOrderPigeon toPigeon() => _findConverter(ECommerceOrder)(this);
}

extension ECommerceAmountConverter on ECommerceAmount {
  ECommerceAmountPigeon toPigeon() => _findConverter(ECommerceAmount)(this);
}

extension ECommercePriceConverter on ECommercePrice {
  ECommercePricePigeon toPigeon() => _findConverter(ECommercePrice)(this);
}

Function _findConverter<I, O>(type) => eCommerceConverters[type]!;

final eCommerceConverters = <Type, Function>{
  ECommerceEvent: (ECommerceEvent event) => ECommerceEventPigeon(
      eventType: event._eventType,
      cartItem: event._cartItem?.toPigeon(),
      order: event._order?.toPigeon(),
      product: event._product?.toPigeon(),
      referrer: event._referrer?.toPigeon(),
      screen: event._screen?.toPigeon()),
  ECommerceScreen: (ECommerceScreen screen) => ECommerceScreenPigeon(
      name: screen.name,
      categoriesPath: screen.categoriesPath,
      searchQuery: screen.searchQuery,
      payload: screen.payload),
  ECommerceProduct: (ECommerceProduct product) => ECommerceProductPigeon(
      sku: product.sku,
      name: product.name,
      categoriesPath: product.categoriesPath,
      payload: product.payload,
      actualPrice: product.actualPrice?.toPigeon(),
      originalPrice: product.originalPrice?.toPigeon(),
      promocodes: product.promocodes),
  ECommerceReferrer: (ECommerceReferrer referrer) => ECommerceReferrerPigeon(
      identifier: referrer.identifier,
      type: referrer.type,
      screen: referrer.screen?.toPigeon()),
  ECommerceCartItem: (ECommerceCartItem cartItem) => ECommerceCartItemPigeon(
      product: cartItem.product.toPigeon(),
      quantity: cartItem.quantity.toString(),
      revenue: cartItem.revenue.toPigeon(),
      referrer: cartItem.referrer?.toPigeon()),
  ECommerceOrder: (ECommerceOrder order) => ECommerceOrderPigeon(
      identifier: order.identifier,
      items: order.items.map((e) => e.toPigeon()).toList(),
      payload: order.payload),
  ECommerceAmount: (ECommerceAmount amount) => ECommerceAmountPigeon(
      amount: amount.amount.toString(), currency: amount.currency),
  ECommercePrice: (ECommercePrice price) => ECommercePricePigeon(
      fiat: price.fiat.toPigeon(),
      internalComponents:
          price.internalComponents?.map((e) => e.toPigeon()).toList())
};
