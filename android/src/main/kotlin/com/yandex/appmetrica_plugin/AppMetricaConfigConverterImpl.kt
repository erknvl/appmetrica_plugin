/*
 * Version for Flutter
 * © 2022
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

package com.yandex.appmetrica_plugin

import com.yandex.android.metrica.flutter.pigeon.Pigeon

class AppMetricaConfigConverterImpl: Pigeon.AppMetricaConfigConverterPigeon {

    override fun toJson(config: Pigeon.AppMetricaConfigPigeon): String = config.toNative().toJson()
}
