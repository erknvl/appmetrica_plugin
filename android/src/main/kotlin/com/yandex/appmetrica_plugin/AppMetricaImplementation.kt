/*
 * Version for Flutter
 * © 2022
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

package com.yandex.appmetrica_plugin

import android.app.Activity
import android.content.Context
import android.os.Handler
import android.os.Looper
import com.yandex.android.metrica.flutter.pigeon.Pigeon
import com.yandex.metrica.AppMetricaDeviceIDListener
import com.yandex.metrica.DeferredDeeplinkListener
import com.yandex.metrica.DeferredDeeplinkParametersListener
import com.yandex.metrica.ReporterConfig
import com.yandex.metrica.YandexMetrica

class AppMetricaImplementation(private val context: Context): Pigeon.AppMetricaPigeon {

    private val mainHandler = Handler(Looper.getMainLooper())

    var activity: Activity? = null

    override fun activate(config: Pigeon.AppMetricaConfigPigeon) {
        YandexMetrica.activate(context, config.toNative())
    }

    override fun activateReporter(config: Pigeon.ReporterConfigPigeon) {
        YandexMetrica.activateReporter(context, ReporterConfig.newConfigBuilder(config.apiKey).apply {
            config.logs?.takeIf { it }?.let { withLogs() }
            config.maxReportsInDatabaseCount?.toInt()?.let(::withMaxReportsInDatabaseCount)
            config.sessionTimeout?.toInt()?.let(::withSessionTimeout)
            config.statisticsSending?.let(::withStatisticsSending)
            config.userProfileID?.let(::withUserProfileID)
        }.build())
    }

    override fun touchReporter(apiKey: String) {
        YandexMetrica.getReporter(context, apiKey)
    }

    override fun getLibraryApiLevel(): Long {
        return YandexMetrica.getLibraryApiLevel().toLong()
    }

    override fun getLibraryVersion(): String {
        return YandexMetrica.getLibraryVersion()
    }

    override fun resumeSession() {
        YandexMetrica.resumeSession(activity)
    }

    override fun pauseSession() {
        YandexMetrica.pauseSession(activity)
    }

    override fun reportAppOpen(deeplink: String) {
        YandexMetrica.reportAppOpen(deeplink)
    }

    override fun reportError(error: Pigeon.ErrorDetailsPigeon, message: String?) {
        YandexMetrica.getPluginExtension().reportError(error.toNative(), message)
    }

    override fun reportErrorWithGroup(groupId: String, error: Pigeon.ErrorDetailsPigeon?, message: String?) {
        YandexMetrica.getPluginExtension().reportError(groupId, message, error?.toNative())
    }

    override fun reportUnhandledException(error: Pigeon.ErrorDetailsPigeon) {
        YandexMetrica.getPluginExtension().reportUnhandledException(error.toNative())
    }

    override fun reportEventWithJson(eventName: String, attributesJson: String?) {
        YandexMetrica.reportEvent(eventName, attributesJson)
    }

    override fun reportEvent(eventName: String) {
        YandexMetrica.reportEvent(eventName)
    }

    override fun reportReferralUrl(referralUrl: String) {
        YandexMetrica.reportReferralUrl(referralUrl)
    }

    override fun requestDeferredDeeplink(result: Pigeon.Result<Pigeon.AppMetricaDeferredDeeplinkPigeon>) {
        YandexMetrica.requestDeferredDeeplink(object: DeferredDeeplinkListener {
            override fun onDeeplinkLoaded(deeplink: String) {
                mainHandler.post {
                    result.success(Pigeon.AppMetricaDeferredDeeplinkPigeon.Builder()
                        .setDeeplink(deeplink)
                        .build()
                    )
                }
            }

            override fun onError(error: DeferredDeeplinkListener.Error, messageArg: String?) {
                mainHandler.post {
                    result.success(Pigeon.AppMetricaDeferredDeeplinkPigeon.Builder()
                        .setDeeplink(null)
                        .setError(Pigeon.AppMetricaDeferredDeeplinkErrorPigeon.Builder()
                            .setReason(when (error) {
                                DeferredDeeplinkListener.Error.NOT_A_FIRST_LAUNCH -> Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.NOT_A_FIRST_LAUNCH
                                DeferredDeeplinkListener.Error.PARSE_ERROR -> Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.PARSE_ERROR
                                DeferredDeeplinkListener.Error.UNKNOWN -> Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.UNKNOWN
                                DeferredDeeplinkListener.Error.NO_REFERRER -> Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.NO_REFERRER
                            })
                            .setMessage(messageArg)
                            .setDescription(error.description)
                            .build()
                        )
                        .build()
                    )
                }
            }
        })
    }

    override fun requestDeferredDeeplinkParameters(result: Pigeon.Result<Pigeon.AppMetricaDeferredDeeplinkParametersPigeon>) {
        YandexMetrica.requestDeferredDeeplinkParameters(object: DeferredDeeplinkParametersListener {

            override fun onParametersLoaded(params: MutableMap<String, String>) {
                mainHandler.post {
                    result.success(Pigeon.AppMetricaDeferredDeeplinkParametersPigeon.Builder()
                        .setParameters(params.toMap())
                        .build()
                    )
                }
            }

            override fun onError(error: DeferredDeeplinkParametersListener.Error, messageArg: String) {
                mainHandler.post {
                    result.success(Pigeon.AppMetricaDeferredDeeplinkParametersPigeon.Builder()
                        .setParameters(null)
                        .setError(Pigeon.AppMetricaDeferredDeeplinkErrorPigeon.Builder()
                            .setReason(when (error) {
                                DeferredDeeplinkParametersListener.Error.NOT_A_FIRST_LAUNCH -> Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.NOT_A_FIRST_LAUNCH
                                DeferredDeeplinkParametersListener.Error.PARSE_ERROR -> Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.PARSE_ERROR
                                DeferredDeeplinkParametersListener.Error.UNKNOWN -> Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.UNKNOWN
                                DeferredDeeplinkParametersListener.Error.NO_REFERRER -> Pigeon.AppMetricaDeferredDeeplinkReasonPigeon.NO_REFERRER
                            })
                            .setMessage(messageArg)
                            .setDescription(error.description)
                            .build()
                        )
                        .build()
                    )
                }
            }
        })
    }

    override fun requestAppMetricaDeviceID(result: Pigeon.Result<Pigeon.AppMetricaDeviceIdPigeon>) {
        YandexMetrica.requestAppMetricaDeviceID(object: AppMetricaDeviceIDListener {
            override fun onLoaded(deviceIdResult: String?) {
                mainHandler.post {
                    result.success(Pigeon.AppMetricaDeviceIdPigeon.Builder()
                        .setDeviceId(deviceIdResult)
                        .setErrorReason(Pigeon.AppMetricaDeviceIdReasonPigeon.NO_ERROR)
                        .build()
                    )
                }
            }

            override fun onError(reason: AppMetricaDeviceIDListener.Reason) {
                mainHandler.post {
                    result.success(Pigeon.AppMetricaDeviceIdPigeon.Builder()
                        .setErrorReason(when (reason) {
                            AppMetricaDeviceIDListener.Reason.UNKNOWN -> Pigeon.AppMetricaDeviceIdReasonPigeon.UNKNOWN
                            AppMetricaDeviceIDListener.Reason.INVALID_RESPONSE -> Pigeon.AppMetricaDeviceIdReasonPigeon.INVALID_RESPONSE
                            AppMetricaDeviceIDListener.Reason.NETWORK -> Pigeon.AppMetricaDeviceIdReasonPigeon.NETWORK
                        })
                        .build()
                    )
                }
            }
        })
    }

    override fun sendEventsBuffer() {
        YandexMetrica.sendEventsBuffer()
    }

    override fun setLocation(location: Pigeon.LocationPigeon?) {
        YandexMetrica.setLocation(location?.toNative())
    }

    override fun setUserProfileID(userProfileID: String?) {
        YandexMetrica.setUserProfileID(userProfileID)
    }

    override fun reportUserProfile(userProfile: Pigeon.UserProfilePigeon) {
        YandexMetrica.reportUserProfile(userProfile.toNative())
    }

    override fun putErrorEnvironmentValue(key: String, value: String?) {
        YandexMetrica.putErrorEnvironmentValue(key, value)
    }

    override fun reportRevenue(revenue: Pigeon.RevenuePigeon) {
        YandexMetrica.reportRevenue(revenue.toNative())
    }

    override fun reportECommerce(event: Pigeon.ECommerceEventPigeon) {
        event.toNative()?.let(YandexMetrica::reportECommerce)
    }

    override fun handlePluginInitFinished() {
        YandexMetrica.resumeSession(activity)
    }

    override fun setLocationTracking(enabled: Boolean) {
        YandexMetrica.setLocationTracking(enabled)
    }

    override fun setStatisticsSending(enabled: Boolean) {
        YandexMetrica.setStatisticsSending(context, enabled)
    }
}
