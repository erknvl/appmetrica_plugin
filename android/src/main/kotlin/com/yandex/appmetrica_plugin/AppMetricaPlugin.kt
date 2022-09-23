/*
 * Version for Flutter
 * © 2022
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

package com.yandex.appmetrica_plugin

import androidx.annotation.NonNull
import com.yandex.android.metrica.flutter.pigeon.Pigeon
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** AppMetricaPlugin */
class AppMetricaPlugin: FlutterPlugin, ActivityAware {

    private lateinit var implementation: AppMetricaImplementation

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
      implementation = AppMetricaImplementation(flutterPluginBinding.applicationContext)
      Pigeon.AppMetricaPigeon.setup(flutterPluginBinding.binaryMessenger, implementation)
      Pigeon.ReporterPigeon.setup(flutterPluginBinding.binaryMessenger, Reporter(flutterPluginBinding.applicationContext))
      Pigeon.AppMetricaConfigConverterPigeon.setup(flutterPluginBinding.binaryMessenger, AppMetricaConfigConverterImpl())
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
  }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        implementation.activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        implementation.activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        implementation.activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        implementation.activity = null
    }
}
