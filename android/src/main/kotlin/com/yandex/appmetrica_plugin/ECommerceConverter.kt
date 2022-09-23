/*
 * Version for Flutter
 * © 2022
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

package com.yandex.appmetrica_plugin

import com.yandex.android.metrica.flutter.pigeon.Pigeon
import com.yandex.metrica.ecommerce.ECommerceAmount
import com.yandex.metrica.ecommerce.ECommerceCartItem
import com.yandex.metrica.ecommerce.ECommerceEvent
import com.yandex.metrica.ecommerce.ECommerceOrder
import com.yandex.metrica.ecommerce.ECommercePrice
import com.yandex.metrica.ecommerce.ECommerceProduct
import com.yandex.metrica.ecommerce.ECommerceReferrer
import com.yandex.metrica.ecommerce.ECommerceScreen
import java.math.BigDecimal

private const val SHOW_SCREEN_EVENT = "show_screen_event"
private const val SHOW_PRODUCT_CARD_EVENT = "show_product_card_event"
private const val SHOW_PRODUCT_DETAILS_EVENT = "show_product_details_event"
private const val ADD_CART_ITEM_EVENT = "add_cart_item_event"
private const val REMOVE_CART_ITEM_EVENT = "remove_cart_item_event"
private const val BEGIN_CHECKOUT_EVENT = "begin_checkout_event"
private const val PURCHASE_EVENT = "purchase_event"

internal fun Pigeon.ECommerceEventPigeon.toNative() = when (eventType) {
    SHOW_SCREEN_EVENT -> {
        screen?.let { screen ->
            ECommerceEvent.showScreenEvent(convertScreen(screen))
        }
    }
    SHOW_PRODUCT_CARD_EVENT -> {
        product?.let { product ->
            screen?.let { screen ->
                ECommerceEvent.showProductCardEvent(convertProduct(product), convertScreen(screen))
            }
        }
    }
    SHOW_PRODUCT_DETAILS_EVENT -> {
        product?.let { product ->
            val referrer = referrer?.let(::convertReferrer)
            ECommerceEvent.showProductDetailsEvent(convertProduct(product), referrer)
        }
    }
    ADD_CART_ITEM_EVENT -> {
        cartItem?.let { cartItem ->
            ECommerceEvent.addCartItemEvent(convertCartItem(cartItem))
        }
    }
    REMOVE_CART_ITEM_EVENT -> {
        cartItem?.let { cartItem ->
            ECommerceEvent.removeCartItemEvent(convertCartItem(cartItem))
        }
    }
    BEGIN_CHECKOUT_EVENT -> {
        order?.let { order ->
            ECommerceEvent.beginCheckoutEvent(convertOrder(order))
        }
    }
    PURCHASE_EVENT -> {
        order?.let { order ->
            ECommerceEvent.purchaseEvent(convertOrder(order))
        }
    }
    else -> null
}

private fun convertScreen(screen: Pigeon.ECommerceScreenPigeon) = ECommerceScreen().apply {
    name = screen.name
    searchQuery = screen.searchQuery
    categoriesPath = screen.categoriesPath?.toList()
    payload = screen.payload?.toMap()
}

private fun convertProduct(product: Pigeon.ECommerceProductPigeon) = ECommerceProduct(product.sku).apply {
    name = product.name
    categoriesPath = product.categoriesPath?.toList()
    payload = product.payload?.toMap()
    actualPrice = product.actualPrice?.let(::convertPrice)
    originalPrice = product.originalPrice?.let(::convertPrice)
    promocodes = product.promocodes?.toList()
}

private fun convertPrice(price: Pigeon.ECommercePricePigeon) = ECommercePrice(convertAmount(price.fiat)).apply {
    internalComponents = price.internalComponents?.map(::convertAmount)
}

private fun convertAmount(amount: Pigeon.ECommerceAmountPigeon) =
    ECommerceAmount(BigDecimal(amount.amount), amount.currency)

private fun convertReferrer(referrer: Pigeon.ECommerceReferrerPigeon) = ECommerceReferrer().apply {
    type = referrer.type
    identifier = referrer.identifier
    screen = referrer.screen?.let(::convertScreen)
}

private fun convertCartItem(cartItem: Pigeon.ECommerceCartItemPigeon) = ECommerceCartItem(
    convertProduct(cartItem.product), convertPrice(cartItem.revenue), BigDecimal(cartItem.quantity)
).apply {
    referrer = cartItem.referrer?.let(::convertReferrer)
}

private fun convertOrder(order: Pigeon.ECommerceOrderPigeon) = ECommerceOrder(
    order.identifier, order.items.map(::convertCartItem)
).apply {
    payload = order.payload?.toMap()
}
