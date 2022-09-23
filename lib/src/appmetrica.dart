/*
 * Version for Flutter
 * © 2022
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

import 'activation_config_holder.dart';
import 'appmetrica_config.dart';
import 'common_utils.dart';
import 'device_id_result.dart';
import 'deferred_deeplink_result.dart';
import 'ecommerce_event.dart';
import 'error_description.dart';
import 'location.dart';
import 'logging.dart';
import 'appmetrica_api_pigeon.dart';
import 'revenue.dart';
import 'pigeon_converter.dart';
import 'profile/attribute.dart';
import 'reporter/reporter.dart';
import 'reporter/reporter_config.dart';
import 'reporter/reporter_storage.dart';

const _deeplink_plugin_error =
    "Unable to retrieve deeplink from native library";

/// The class contains methods for working with the library.
class AppMetrica {
  AppMetrica._();

  static final _reporterStorage = ReporterStorage();

  static final AppMetricaPigeon _appMetrica = AppMetricaPigeon();

  static final _logger = Logger("$appMetricaRootLoggerName.MainFacade");

  /// Initializes the library in the application with the initial configuration [config].
  static Future<void> activate(AppMetricaConfig config) async {
    if (config.logs == true) {
      setUpLogger(appMetricaRootLogger);
    }
    setUpErrorHandlingWithAppMetrica();
    var activationCompleter = ActivationCompleter(config);
    return _appMetrica.activate(config.toPigeon()).then(
        activationCompleter.complete,
        onError: activationCompleter.onError);
  }

  /// Activates reporter with the [config] configuration.
  ///
  /// The reporter must be activated with a configuration that contains an API key different from the API key of the application.
  static Future<void> activateReporter(ReporterConfig config) =>
      _appMetrica.activateReporter(ReporterConfigPigeon(apiKey: config.apiKey)
        ..logs = config.logs
        ..statisticsSending = config.statisticsSending
        ..userProfileID = config.userProfileID
        ..maxReportsInDatabaseCount = config.maxReportsInDatabaseCount
        ..sessionTimeout = config.sessionTimeout);

  /// Returns an object that implements the Reporter interface for the specified [apiKey].
  ///
  /// Used to send statistics using an API key different from the app's API key.
  static Reporter getReporter(String apiKey) {
    _appMetrica.touchReporter(apiKey).ignore();
    return _reporterStorage.getReporter(apiKey);
  }

  /// Runs [callback] in its own error zone created by [runZonedGuarded](https://api.flutter.dev/flutter/dart-async/runZonedGuarded.html),
  /// and reports all exceptions to AppMetrica.
  static void runZoneGuarded(VoidCallback callback) {
    runZonedGuarded(() {
      WidgetsFlutterBinding.ensureInitialized();
      callback();
    }, (Object err, StackTrace stack) {
      _logger.warning("error caught by Zone", err, stack);
      if (ActivationConfigHolder.lastActivationConfig != null) {
        _appMetrica
            .reportUnhandledException(convertErrorDetails(
                err.runtimeType.toString(), err.toString(), stack))
            .ignore();
      }
    });
  }

  /// Returns the current version of the AppMetrica library.
  static Future<String> get libraryVersion => _appMetrica.getLibraryVersion();

  /// Returns the API level of the library (Android).
  static Future<int> get libraryApiLevel => _appMetrica.getLibraryApiLevel();

  /// Resumes the foreground session or creates a new one if the session timeout has expired.
  ///
  /// Use the method only when session auto-tracking is disabled [AppMetricaConfig.sessionsAutoTracking].
  static Future<void> resumeSession() => _appMetrica.resumeSession();

  /// Suspends the current foreground session.
  ///
  /// Use the method only when session auto-tracking is disabled [AppMetricaConfig.sessionsAutoTracking].
  static Future<void> pauseSession() => _appMetrica.pauseSession();

  /// Sends a message about opening the application using [deeplink].
  static Future<void> reportAppOpen(String deeplink) =>
      _appMetrica.reportAppOpen(deeplink);

  /// Sends an error message [message] with the description [errorDescription].
  /// If there is no [errorDescription] description, the current stacktrace will be automatically added.
  static Future<void> reportError(
          {String? message, AppMetricaErrorDescription? errorDescription}) =>
      _appMetrica.reportError(
          errorDescription.tryToAddCurrentTrace().toPigeon(), message);

  /// Sends an error message with its own identifier [groupId]. Errors in reports are grouped by it.
  static Future<void> reportErrorWithGroup(String groupId,
          {AppMetricaErrorDescription? errorDescription, String? message}) =>
      _appMetrica.reportErrorWithGroup(
          groupId, errorDescription?.toPigeon(), message);

  /// Sends an event with an unhandled exception [errorDescription].
  static Future<void> reportUnhandledException(
          AppMetricaErrorDescription errorDescription) =>
      _appMetrica.reportUnhandledException(errorDescription.toPigeon());

  /// Sends an event message with a short name or description of the event [eventName].
  static Future<void> reportEvent(String eventName) =>
      _appMetrica.reportEvent(eventName);

  /// Sends an event message as a set of attributes [attributes] Map and a short name or description of the event [eventName].
  static Future<void> reportEventWithMap(
          String eventName, Map<String, Object>? attributes) =>
      _appMetrica.reportEventWithJson(eventName, jsonEncode(attributes));

  /// Sends an event message in JSON format [attributesJson] as a string and a short name or description of the event [eventName].
  static Future<void> reportEventWithJson(
          String eventName, String? attributesJson) =>
      _appMetrica.reportEventWithJson(eventName, attributesJson);

  /// Sets the [referralUrl] of the application installation.
  ///
  /// The method can be used to track some traffic sources.
  static Future<void> reportReferralUrl(String referralUrl) =>
      _appMetrica.reportReferralUrl(referralUrl);

  /// Requests a deferred deeplink.
  ///
  /// Relevant only for Android. For iOS, it returns the unknown error.
  static Future<String> requestDeferredDeeplink() =>
      _appMetrica.requestDeferredDeeplink().then((value) {
        final error = value.error;
        if (error != null &&
            error.reason != AppMetricaDeferredDeeplinkReasonPigeon.NO_ERROR) {
          throw DeferredDeeplinkRequestException(
              _deferredDeeplinkErrorFromPigeon(error.reason),
              error.description,
              error.message);
        } else if (value.deeplink == null) {
          throw DeferredDeeplinkRequestException(
              DeferredDeeplinkErrorReason.unknown,
              _deeplink_plugin_error,
              error?.message);
        } else {
          return value.deeplink!;
        }
      });

  /// Requests deferred deeplink parameters.
  ///
  /// Relevant only for Android. For iOS, it returns the unknown error.
  static Future<Map<String, String>> requestDeferredDeeplinkParameters() =>
      _appMetrica.requestDeferredDeeplinkParameters().then((value) {
        final error = value.error;
        if (error != null &&
            error.reason != AppMetricaDeferredDeeplinkReasonPigeon.NO_ERROR) {
          throw DeferredDeeplinkRequestException(
              _deferredDeeplinkErrorFromPigeon(error.reason),
              error.description,
              error.message);
        } else if (value.parameters == null) {
          throw DeferredDeeplinkRequestException(
              DeferredDeeplinkErrorReason.unknown,
              _deeplink_plugin_error,
              error?.message);
        } else {
          return value.parameters!
              .map((key, value) => MapEntry(key as String, value as String));
        }
      });

  /// Requests an unique AppMetrica identifier (DeviceID).
  static Future<String> requestAppMetricaDeviceID() =>
      _appMetrica.requestAppMetricaDeviceID().then((value) {
        if (value.errorReason != AppMetricaDeviceIdReasonPigeon.NO_ERROR) {
          throw DeviceIdRequestException(
              _deviceIdErrorFromPigeon(value.errorReason));
        } else if (value.deviceId == null) {
          throw DeviceIdRequestException(DeviceIdErrorReason.unknown);
        } else {
          return value.deviceId!;
        }
      });

  /// Sends saved events from the buffer.
  static Future<void> sendEventsBuffer() => _appMetrica.sendEventsBuffer();

  /// Sets its own device location information using the [location] parameter.
  static Future<void> setLocation(Location? location) =>
      _appMetrica.setLocation(location?.toPigeon());

  /// Enables/disables sending device location information using the [enabled].
  /// The default value for Android is false, for iOS is true.
  static Future<void> setLocationTracking(bool enabled) =>
      _appMetrica.setLocationTracking(enabled);

  /// Enables/disables sending statistics to the AppMetrica server.
  ///
  /// Disabling sending for the main API key also disables sending data from all reporters
  /// that were initialized with another API key.
  static Future<void> setStatisticsSending(bool enabled) =>
      _appMetrica.setStatisticsSending(enabled);

  /// Sets the ID for the user profile using the [userProfileID] parameter.
  ///
  /// If Profile Id sending is not configured, predefined attributes are not displayed in the web interface.
  static Future<void> setUserProfileID(String? userProfileID) =>
      _appMetrica.setUserProfileID(userProfileID);

  /// Sends information about updating the user profile using the [userProfile] parameter.
  static Future<void> reportUserProfile(UserProfile userProfile) =>
      _appMetrica.reportUserProfile(userProfile.toPigeon());

  /// Adds a [key]-[value] pair to or deletes it from the application error environment. The environment is shown in the crash and error report.
  ///
  /// * The maximum length of the [key] key is 50 characters. If the length is exceeded, the key is truncated to 50 characters.
  /// * The maximum length of the [value] value is 4000 characters. If the length is exceeded, the value is truncated to 4000 characters.
  /// * A maximum of 30 environment pairs of the form {key, value} are allowed. If you try to add the 31st pair, it will be ignored.
  /// * Total size (sum {len(key) + len(value)} for (key, value) in error_environment) - 4500 characters.
  /// * If a new pair exceeds the total size, it will be ignored.
  static Future<void> putErrorEnvironmentValue(String key, String? value) =>
      _appMetrica.putErrorEnvironmentValue(key, value);

  /// Sends the purchase information to the AppMetrica server.
  static Future<void> reportRevenue(Revenue revenue) =>
      _appMetrica.reportRevenue(revenue.toPigeon());

  /// Sends a message about an e-commerce event.
  static Future<void> reportECommerce(ECommerceEvent event) =>
      _appMetrica.reportECommerce(event.toPigeon());
}

var _crashHandlingActivated = false;

void setUpErrorHandlingWithAppMetrica() {
  if (!_crashHandlingActivated) {
    _crashHandlingActivated = true;
    final prev = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) async {
      AppMetrica._logger.warning("error caught by handler ${details.summary}",
          details.exception, details.stack);
      await AppMetrica._appMetrica.reportUnhandledException(convertErrorDetails(
          details.exception.runtimeType.toString(),
          details.summary.toString(),
          details.stack));
      if (prev != null) {
        prev(details);
      }
    };
  }
}

DeviceIdErrorReason _deviceIdErrorFromPigeon(
    AppMetricaDeviceIdReasonPigeon? error) {
  switch (error) {
    case AppMetricaDeviceIdReasonPigeon.INVALID_RESPONSE:
      return DeviceIdErrorReason.invalidResponse;
    case AppMetricaDeviceIdReasonPigeon.NETWORK:
      return DeviceIdErrorReason.network;
    case AppMetricaDeviceIdReasonPigeon.UNKNOWN:
      return DeviceIdErrorReason.unknown;
    default:
      return DeviceIdErrorReason.unknown;
  }
}

DeferredDeeplinkErrorReason _deferredDeeplinkErrorFromPigeon(
    AppMetricaDeferredDeeplinkReasonPigeon error) {
  switch (error) {
    case AppMetricaDeferredDeeplinkReasonPigeon.NOT_A_FIRST_LAUNCH:
      return DeferredDeeplinkErrorReason.notAFirstLaunch;
    case AppMetricaDeferredDeeplinkReasonPigeon.PARSE_ERROR:
      return DeferredDeeplinkErrorReason.parseError;
    case AppMetricaDeferredDeeplinkReasonPigeon.UNKNOWN:
      return DeferredDeeplinkErrorReason.unknown;
    case AppMetricaDeferredDeeplinkReasonPigeon.NO_REFERRER:
      return DeferredDeeplinkErrorReason.noReferrer;
    default:
      return DeferredDeeplinkErrorReason.unknown;
  }
}
