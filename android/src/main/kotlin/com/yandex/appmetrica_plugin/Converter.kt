/*
 * Version for Flutter
 * © 2022
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

package com.yandex.appmetrica_plugin

import android.location.Location
import com.yandex.android.metrica.flutter.pigeon.Pigeon
import com.yandex.metrica.AdRevenue
import com.yandex.metrica.AdType
import com.yandex.metrica.PreloadInfo
import com.yandex.metrica.Revenue
import com.yandex.metrica.YandexMetricaConfig
import com.yandex.metrica.plugins.PluginErrorDetails
import com.yandex.metrica.plugins.StackTraceItem
import com.yandex.metrica.profile.Attribute
import com.yandex.metrica.profile.GenderAttribute
import com.yandex.metrica.profile.UserProfile
import java.math.BigDecimal
import java.util.Currency

internal fun Pigeon.RevenuePigeon.toNative() = Revenue.newBuilderWithMicros(
    (BigDecimal(price) * BigDecimal(1_000_000)).toLong(),
    Currency.getInstance(currency)
).apply {
    productId?.let(::withProductID)
    payload?.let(::withPayload)
    quantity?.toInt()?.let(::withQuantity)
    receipt?.let { receipt ->
        withReceipt(Revenue.Receipt.newBuilder().apply {
            receipt.data?.let(::withData)
            receipt.signature?.let(::withSignature)
        }.build())
    }
}.build()

internal fun Pigeon.AppMetricaConfigPigeon.toNative() = YandexMetricaConfig.newConfigBuilder(apiKey)
    .apply {
        appVersion?.let(::withAppVersion)
        crashReporting?.let(::withCrashReporting)
        firstActivationAsUpdate?.let(::handleFirstActivationAsUpdate)
        location?.toNative()?.let(::withLocation)
        locationTracking?.let(::withLocationTracking)
        logs?.let { withLogs() }
        maxReportsInDatabaseCount?.toInt()?.let(::withMaxReportsInDatabaseCount)
        nativeCrashReporting?.let(::withNativeCrashReporting)
        sessionTimeout?.toInt()?.let(::withSessionTimeout)
        sessionsAutoTracking?.let(::withSessionsAutoTrackingEnabled)
        statisticsSending?.let(::withStatisticsSending)
        preloadInfo?.let { preload ->
            withPreloadInfo(
                PreloadInfo.newBuilder(preload.trackingId).apply {
                    preload.additionalInfo?.forEach { entry ->
                        setAdditionalParams(entry.key as String, entry.value as String)
                    }
                }.build()
            )
        }
        errorEnvironment?.forEach { (key, value) -> withErrorEnvironmentValue(key, value) }
        userProfileID?.let(::withUserProfileID)
        revenueAutoTracking?.let(::withRevenueAutoTrackingEnabled)
        withAppOpenTrackingEnabled(false)
    }.build()

internal fun Pigeon.LocationPigeon.toNative() = Location(provider).also { output ->
    output.longitude = longitude
    output.latitude = latitude
    altitude?.let(output::setAltitude)
    course?.toFloat()?.let(output::setBearing)
    timestamp?.let(output::setTime)
    accuracy?.toFloat()?.let(output::setAccuracy)
    speed?.toFloat()?.let(output::setSpeed)
}

internal fun Pigeon.UserProfilePigeon.toNative(): UserProfile {
    val builder = UserProfile.newBuilder()
    attributes.map { attribute ->
        when (attribute.type) {
            Pigeon.UserProfileAttributeType.BIRTH_DATE -> {
                val birthdate = Attribute.birthDate()
                if (attribute.reset == true) {
                    birthdate.withValueReset()
                } else {
                    val year = attribute.year
                    val month = attribute.month
                    val day = attribute.day
                    val age = attribute.age
                    return@map if (year == null) {
                        if (age != null) {
                            birthdate.withAge(age.toInt())
                        } else {
                            null
                        }
                    } else {
                        if (month == null) {
                            birthdate.withBirthDate(year.toInt())
                        } else {
                            if (day == null) {
                                birthdate.withBirthDate(year.toInt(), month.toInt())
                            } else {
                                birthdate.withBirthDate(year.toInt(), month.toInt(), day.toInt())
                            }
                        }
                    }

                }
            }
            Pigeon.UserProfileAttributeType.BOOLEAN -> {
                val boolean = Attribute.customBoolean(attribute.key)
                if (attribute.reset == true) {
                    boolean.withValueReset()
                } else {
                    if (attribute.ifUndefined == true) {
                        boolean.withValueIfUndefined(attribute.boolValue ?: false)
                    } else {
                        boolean.withValue(attribute.boolValue ?: false)
                    }
                }
            }
            Pigeon.UserProfileAttributeType.COUNTER -> {
                val counter = Attribute.customCounter(attribute.key)
                counter.withDelta(attribute.doubleValue ?: 0.0)
            }
            Pigeon.UserProfileAttributeType.GENDER -> {
                val gender = Attribute.gender()
                if (attribute.reset == true) {
                    gender.withValueReset()
                } else {
                    gender.withValue(genderToNative[attribute.genderValue] ?: GenderAttribute.Gender.OTHER)
                }
            }
            Pigeon.UserProfileAttributeType.NAME -> {
                val name = Attribute.name()
                if (attribute.reset == true) {
                    name.withValueReset()
                } else {
                    name.withValue(attribute.stringValue ?: "")
                }
            }
            Pigeon.UserProfileAttributeType.NOTIFICATION_ENABLED -> {
                val notification = Attribute.notificationsEnabled()
                if (attribute.reset == true) {
                    notification.withValueReset()
                } else {
                    notification.withValue(attribute.boolValue ?: false)
                }
            }
            Pigeon.UserProfileAttributeType.NUMBER -> {
                val number = Attribute.customNumber(attribute.key)
                if (attribute.reset == true) {
                    number.withValueReset()
                } else {
                    if (attribute.ifUndefined == true) {
                        number.withValueIfUndefined(attribute.doubleValue ?: 0.0)
                    } else {
                        number.withValue(attribute.doubleValue ?: 0.0)
                    }
                }
            }
            Pigeon.UserProfileAttributeType.STRING -> {
                val string = Attribute.customString(attribute.key)
                if (attribute.reset == true) {
                    string.withValueReset()
                } else {
                    if (attribute.ifUndefined == true) {
                        string.withValueIfUndefined(attribute.stringValue ?: "")
                    } else {
                        string.withValue(attribute.stringValue ?: "")
                    }
                }
            }
            null -> null
        }
    }.forEach { update ->
        update?.let(builder::apply)
    }
    return builder.build()
}

private val genderToNative = mapOf(
    Pigeon.GenderPigeon.MALE to GenderAttribute.Gender.MALE,
    Pigeon.GenderPigeon.FEMALE to GenderAttribute.Gender.FEMALE,
    Pigeon.GenderPigeon.OTHER to GenderAttribute.Gender.OTHER
)

internal fun Pigeon.StackTraceElementPigeon.toNative() = StackTraceItem.Builder()
    .withFileName(fileName)
    .withClassName(className)
    .withMethodName(methodName)
    .withLine(line.toInt())
    .withColumn(column.toInt())
    .build()

internal fun Pigeon.ErrorDetailsPigeon.toNative() = PluginErrorDetails.Builder()
    .withExceptionClass(exceptionClass)
    .withMessage(message)
    .withPlatform(PluginErrorDetails.Platform.FLUTTER)
    .withVirtualMachineVersion(dartVersion)
    .withStacktrace(backtrace?.map { it.toNative() })
    .build()

private val adTypeToNative = mapOf(
    Pigeon.AdTypePigeon.UNKNOWN to null,
    Pigeon.AdTypePigeon.NATIVE to AdType.NATIVE,
    Pigeon.AdTypePigeon.BANNER to AdType.BANNER,
    Pigeon.AdTypePigeon.REWARDED to AdType.REWARDED,
    Pigeon.AdTypePigeon.INTERSTITIAL to AdType.INTERSTITIAL,
    Pigeon.AdTypePigeon.MREC to AdType.MREC,
    Pigeon.AdTypePigeon.OTHER to AdType.OTHER
)

internal fun Pigeon.AdRevenuePigeon.toNative() = AdRevenue.newBuilder(
    BigDecimal(adRevenue),
    Currency.getInstance(currency)
).apply {
    adType?.let { adTypeToNative[it] }?.let(::withAdType)
    adNetwork?.let(::withAdNetwork)
    adUnitId?.let(::withAdUnitId)
    adUnitName?.let(::withAdUnitName)
    adPlacementId?.let(::withAdPlacementId)
    adPlacementName?.let(::withAdPlacementName)
    precision?.let(::withPrecision)
    payload?.let(::withPayload)
}.build()
