/*
 * Version for Flutter
 * © 2022
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

import 'package:appmetrica_plugin/src/appmetrica_api_pigeon.dart';
import '../appmetrica_plugin.dart';

class ActivationConfigHolder {
  ActivationConfigHolder._();

  static bool _isActivated = false;
  static bool get activated => _isActivated;

  static AppMetricaConfig? _lastActivationConfig;
  static AppMetricaConfig? get lastActivationConfig => _lastActivationConfig;
  static set lastActivationConfig(AppMetricaConfig? value) {
    if (!_isActivated) {
      _isActivated = true;
    }
    activationListener?.call(value);
    _lastActivationConfig = value;
  }

  static Function(AppMetricaConfig?)? activationListener;
}

class ActivationCompleter {
  final AppMetricaConfig config;

  ActivationCompleter(this.config);

  Future<dynamic> complete(dynamic value) {
    _startFirstAutoTrackedSession(config.sessionsAutoTracking);
    ActivationConfigHolder.lastActivationConfig = config;
    return Future.value(value);
  }

  void onError(Object? error, StackTrace stackTrace) {
    ActivationConfigHolder.lastActivationConfig = null;
    if (error != null) {
      throw error;
    }
  }

  Future<void> _startFirstAutoTrackedSession(bool? sessionsAutoTracking) {
    if (ActivationConfigHolder.activated || false == sessionsAutoTracking) {
      return Future.value();
    } else {
      return AppMetricaPigeon().handlePluginInitFinished();
    }
  }
}
