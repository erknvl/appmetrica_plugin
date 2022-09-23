/*
 * Version for Flutter
 * © 2022
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

import 'package:appmetrica_plugin/src/ecommerce.dart';
import 'package:appmetrica_plugin/src/ecommerce_event.dart';
import 'package:appmetrica_plugin/src/appmetrica_api_pigeon.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'ecommerce_test.mocks.dart';

class EventConverter extends Mock {
  ECommerceEventPigeon call(ECommerceEvent event);
}

class ScreenConverter extends Mock {
  ECommerceScreenPigeon call(ECommerceScreen screen);
}

class ProductConverter extends Mock {
  ECommerceProductPigeon call(ECommerceProduct product);
}

class ReferrerConverter extends Mock {
  ECommerceReferrerPigeon call(ECommerceReferrer referrer);
}

class CartItemConverter extends Mock {
  ECommerceCartItemPigeon call(ECommerceCartItem cartItem);
}

class OrderConverter extends Mock {
  ECommerceOrderPigeon call(ECommerceOrder order);
}

class PriceConverter extends Mock {
  ECommercePricePigeon call(ECommercePrice price);
}

class AmountConverter extends Mock {
  ECommerceAmountPigeon call(ECommerceAmount amount);
}

@GenerateMocks(
  [
    EventConverter,
    ScreenConverter,
    ProductConverter,
    ReferrerConverter,
    CartItemConverter,
    OrderConverter,
    PriceConverter,
    AmountConverter
  ],
)
void main() {
  final screen = ECommerceScreen();
  final product = ECommerceProduct(sku: "sku");
  final referrer = ECommerceReferrer();
  final amount = ECommerceAmount(amount: Decimal.fromInt(100), currency: "USD");
  final price = ECommercePrice(fiat: amount);
  final cartItem = ECommerceCartItem(
      product: product, quantity: Decimal.fromInt(10), revenue: price);
  final order = ECommerceOrder(identifier: "identifier", items: [cartItem]);
  final event = ECommerce.showScreenEvent(screen);

  final eventConverter = MockEventConverter();
  final screenConverter = MockScreenConverter();
  final productConverter = MockProductConverter();
  final referrerConverter = MockReferrerConverter();
  final cartItemConverter = MockCartItemConverter();
  final orderConverter = MockOrderConverter();
  final priceConverter = MockPriceConverter();
  final amountConverter = MockAmountConverter();

  final eCommerceEventPigeon = ECommerceEventPigeon(eventType: "eventType");
  final eCommerceScreenPigeon = ECommerceScreenPigeon();
  final eCommerceProductPigeon = ECommerceProductPigeon(sku: "sku");
  final eCommerceReferrerPigeon = ECommerceReferrerPigeon();
  final eCommerceAmountPigeon =
      ECommerceAmountPigeon(amount: "100", currency: "USD");
  final eCommercePricePigeon =
      ECommercePricePigeon(fiat: eCommerceAmountPigeon);
  final eCommerceCartItemPigeon = ECommerceCartItemPigeon(
      product: eCommerceProductPigeon,
      quantity: "10",
      revenue: eCommercePricePigeon);
  final eCommerceOrderPigeon =
      ECommerceOrderPigeon(identifier: "id", items: [eCommerceCartItemPigeon]);

  Map<Type, Function> backUpConverters = {};

  setUp(() {
    backUpConverters = Map.from(eCommerceConverters);

    when(screenConverter.call(any)).thenReturn(eCommerceScreenPigeon);
    when(productConverter.call(any)).thenReturn(eCommerceProductPigeon);
    when(referrerConverter.call(any)).thenReturn(eCommerceReferrerPigeon);
    when(orderConverter.call(any)).thenReturn(eCommerceOrderPigeon);
    when(priceConverter.call(any)).thenReturn(eCommercePricePigeon);
    when(amountConverter.call(any)).thenReturn(eCommerceAmountPigeon);
  });

  tearDown(() {
    eCommerceConverters.addAll(backUpConverters);
  });

  test("ECommerce Screen Event", () {
    eCommerceConverters[ECommerceScreen] = screenConverter;

    final pigeon = ECommerce.showScreenEvent(screen).toPigeon();

    verify(screenConverter.call(screen));
    expect(pigeon.eventType, "show_screen_event");
    expect(pigeon.screen, eCommerceScreenPigeon);
  });

  test("ECommerce Product Card Event", () {
    eCommerceConverters[ECommerceScreen] = screenConverter;
    eCommerceConverters[ECommerceProduct] = productConverter;

    final pigeon = ECommerce.showProductCardEvent(product, screen).toPigeon();

    verify(screenConverter.call(screen));
    verify(productConverter.call(product));
    expect(pigeon.eventType, "show_product_card_event");
    expect(pigeon.screen, eCommerceScreenPigeon);
    expect(pigeon.product, eCommerceProductPigeon);
  });

  test("ECommerce Product Details Event", () {
    eCommerceConverters[ECommerceProduct] = productConverter;
    eCommerceConverters[ECommerceReferrer] = referrerConverter;

    final pigeon =
        ECommerce.showProductDetailsEvent(product, referrer).toPigeon();

    verify(productConverter.call(product));
    verify(referrerConverter.call(referrer));
    expect(pigeon.eventType, "show_product_details_event");
    expect(pigeon.product, eCommerceProductPigeon);
    expect(pigeon.referrer, eCommerceReferrerPigeon);
  });

  test("ECommerce Add Cart Item Event", () {
    eCommerceConverters[ECommerceCartItem] = cartItemConverter;

    when(cartItemConverter.call(any)).thenReturn(eCommerceCartItemPigeon);

    final pigeon = ECommerce.addCartItemEvent(cartItem).toPigeon();

    verify(cartItemConverter.call(cartItem));
    expect(pigeon.eventType, "add_cart_item_event");
    expect(pigeon.cartItem, eCommerceCartItemPigeon);
  });

  test("ECommerce Remove Cart Item Event", () {
    eCommerceConverters[ECommerceCartItem] = cartItemConverter;

    when(cartItemConverter.call(any)).thenReturn(eCommerceCartItemPigeon);

    final pigeon = ECommerce.removeCartItemEvent(cartItem).toPigeon();

    verify(cartItemConverter.call(cartItem));
    expect(pigeon.eventType, "remove_cart_item_event");
    expect(pigeon.cartItem, eCommerceCartItemPigeon);
  });

  test("ECommerce Begin Checkout Event", () {
    eCommerceConverters[ECommerceOrder] = orderConverter;

    final pigeon = ECommerce.beginCheckoutEvent(order).toPigeon();

    verify(orderConverter.call(order));
    expect(pigeon.eventType, "begin_checkout_event");
    expect(pigeon.order, eCommerceOrderPigeon);
  });

  test("ECommerce Purchase Event Event", () {
    eCommerceConverters[ECommerceOrder] = orderConverter;

    final pigeon = ECommerce.purchaseEvent(order).toPigeon();

    verify(orderConverter.call(order));
    expect(pigeon.eventType, "purchase_event");
    expect(pigeon.order, eCommerceOrderPigeon);
  });

  test("ECommerce Amount Conversion", () {
    eCommerceConverters[ECommerceAmount] = amountConverter;

    final pigeon = price.toPigeon();

    verify(amountConverter.call(amount));
    expect(pigeon.fiat, eCommerceAmountPigeon);
  });

  test("ECommerce Price Conversion", () {
    eCommerceConverters[ECommercePrice] = priceConverter;

    final pigeon = cartItem.toPigeon();

    verify(priceConverter.call(price));
    expect(pigeon.revenue, eCommercePricePigeon);
  });

  test("ECommerce Event Conversion", () {
    eCommerceConverters[ECommerceEvent] = eventConverter;
    when(eventConverter.call(event)).thenReturn(eCommerceEventPigeon);

    final pigeon = event.toPigeon();

    verify(eventConverter.call(event));
    expect(pigeon, eCommerceEventPigeon);
  });
}
