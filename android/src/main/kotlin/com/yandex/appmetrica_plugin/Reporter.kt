/*
 * Version for Flutter
 * © 2022
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

package com.yandex.appmetrica_plugin

import android.content.Context
import com.yandex.android.metrica.flutter.pigeon.Pigeon
import com.yandex.metrica.YandexMetrica

class Reporter(private val context: Context): Pigeon.ReporterPigeon {

    override fun sendEventsBuffer(apiKey: String) = YandexMetrica.getReporter(context, apiKey).sendEventsBuffer()

    override fun reportEvent(apiKey: String, eventName: String) =
        YandexMetrica.getReporter(context, apiKey).reportEvent(eventName)

    override fun reportEventWithJson(apiKey: String, eventName: String, attributesJson: String?) =
        YandexMetrica.getReporter(context, apiKey).reportEvent(eventName, attributesJson)

    override fun reportError(apiKey: String, error: Pigeon.ErrorDetailsPigeon, message: String?) {
        YandexMetrica.getReporter(context, apiKey).pluginExtension.reportError(error.toNative(), message)
    }

    override fun reportErrorWithGroup(apiKey: String, groupId: String, error: Pigeon.ErrorDetailsPigeon?, message: String?) {
        YandexMetrica.getReporter(context, apiKey).pluginExtension.reportError(groupId, message, error?.toNative())
    }

    override fun reportUnhandledException(apiKey: String, error: Pigeon.ErrorDetailsPigeon) {
        YandexMetrica.getReporter(context, apiKey).pluginExtension.reportUnhandledException(error.toNative())
    }

    override fun resumeSession(apiKey: String) = YandexMetrica.getReporter(context, apiKey).resumeSession()

    override fun pauseSession(apiKey: String) = YandexMetrica.getReporter(context, apiKey).pauseSession()

    override fun setStatisticsSending(apiKey: String, enabled: Boolean) =
        YandexMetrica.getReporter(context, apiKey).setStatisticsSending(enabled)

    override fun setUserProfileID(apiKey: String, userProfileID: String?) =
        YandexMetrica.getReporter(context, apiKey).setUserProfileID(userProfileID)

    override fun reportUserProfile(apiKey: String, userProfile: Pigeon.UserProfilePigeon) {
        YandexMetrica.getReporter(context, apiKey).reportUserProfile(userProfile.toNative())
    }

//    override fun putErrorEnvironmentValue(apiKey: String, key: String, value: String?) =
//        YandexMetrica.getReporter(context, apiKey).

    override fun reportRevenue(apiKey: String, revenue: Pigeon.RevenuePigeon) =
        YandexMetrica.getReporter(context, apiKey).reportRevenue(revenue.toNative())

    override fun reportECommerce(apiKey: String, event: Pigeon.ECommerceEventPigeon) {
        event.toNative()?.let(YandexMetrica.getReporter(context, apiKey)::reportECommerce)
    }

    override fun reportAdRevenue(apiKey: String, adRevenue: Pigeon.AdRevenuePigeon) {
        YandexMetrica.getReporter(context, apiKey).reportAdRevenue(adRevenue.toNative())
    }
}
