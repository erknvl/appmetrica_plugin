/*
 * Version for Flutter
 * © 2022
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

import 'package:appmetrica_plugin/src/appmetrica_api_pigeon.dart';
import 'package:appmetrica_plugin/src/pigeon_converter.dart';

import 'location.dart';
import 'preload_info.dart';

/// The class contains the starting configuration of the library.
/// Configuration parameters are applied from the moment the library is initialized. You can set:
/// * [apiKey] — application API key;
/// * [appVersion] — application version;
/// * [crashReporting] — flag for sending information about unhandled exceptions in the application. The default value is true;
/// * [firstActivationAsUpdate] — flag that determines if the first launch of the application is an update. The default value is false;
///   If the first launch of the application is defined as an update, the installation will not be displayed in reports as a new installation and will not be attributed to partners;
/// * [location] — device location information;
/// * [locationTracking] — indicates whether the device location information is being collected and sent.
///   The default value for Android is false, for iOS is true.
/// * [logs] — indicates that logging of the library is enabled. The default value is false;
/// * [sessionTimeout] — session timeout in seconds. The default value is 10 (the minimum allowed value);
/// * [statisticsSending] — indicates whether sending statistics is enabled. The default value is true;
/// * [preloadInfo] — a [PreloadInfo] object for tracking preinstalled applications;
/// * [maxReportsInDatabaseCount] — is the maximum number of events that can be stored in the database on the device before being sent to AppMetrica. The default value is 1000.
///   Values in the range [100; 10000] are allowed. Values that do not fall within this interval will be automatically replaced with the value of the nearest interval boundary;
/// * [nativeCrashReporting] — flag for sending information about unhandled exceptions in the application. Exceptions are caused by C++ code in Android;
/// * [sessionsAutoTracking] — indicates automatic collection and sending of information about the sessions of the application user. The default value is true;
/// * [errorEnvironment] — the environment of the application error in the form of a key-value pair. The environment is displayed in the crashes and errors report;
/// * [userProfileID] — user profile ID;
/// * [revenueAutoTracking] — indicates automatic collection and sending of information about In-App purchases. The default value is true.
class AppMetricaConfig {
  static final _converter = AppMetricaConfigConverterPigeon();

  final String apiKey;
  final String? appVersion;
  final bool? crashReporting;
  final bool? firstActivationAsUpdate;
  final Location? location;
  final bool? locationTracking;
  final bool? logs;
  final int? sessionTimeout;
  final bool? statisticsSending;
  final PreloadInfo? preloadInfo;
  final int? maxReportsInDatabaseCount;
  final bool? nativeCrashReporting;
  final bool? sessionsAutoTracking;
  final Map<String, String>? errorEnvironment;
  final String? userProfileID;
  final bool? revenueAutoTracking;

  /// Creates an AppMetrica library configuration object. [apiKey] is a required parameter.
  const AppMetricaConfig(
    this.apiKey, {
    this.appVersion,
    this.crashReporting,
    this.firstActivationAsUpdate,
    this.location,
    this.locationTracking,
    this.logs,
    this.sessionTimeout,
    this.statisticsSending,
    this.preloadInfo,
    this.maxReportsInDatabaseCount,
    this.nativeCrashReporting,
    this.sessionsAutoTracking = true,
    this.errorEnvironment,
    this.userProfileID,
    this.revenueAutoTracking,
  });

  Future<String> toJson() => _converter.toJson(toPigeon());
}
