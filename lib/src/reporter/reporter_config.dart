/*
 * Version for Flutter
 * © 2022
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

/// Class contains the configuration of the reporter. You can set:
/// * [apiKey] - API key other than the API key of the application;
/// * [sessionTimeout] — session timeout in seconds. The default value is 10 (the minimum allowed value);
/// * [statisticsSending] - indicates whether sending statistics is enabled. The default value is true;
/// * [maxReportsInDatabaseCount] — the maximum number of events that can be stored in the database on the device before being sent to AppMetrica. The default value is 1000.
/// Values in the range [100; 10000] are allowed. Values that do not fall within this interval will be automatically replaced with the value of the nearest interval boundary;
/// * [userProfileID] - user profile identifier (profileId) upon activation;
/// * [logs] - a sign that determines whether logging of the reporter's work is enabled. The default value is false.
class ReporterConfig {
  final String apiKey;
  final int? sessionTimeout;
  final bool? statisticsSending;
  final int? maxReportsInDatabaseCount;
  final String? userProfileID;
  final bool? logs;

  /// Creates an object of the [ReporterConfig] class - the reporter configuration constructor. [apiKey] is a required parameter.
  const ReporterConfig(this.apiKey,
      {this.sessionTimeout,
      this.statisticsSending,
      this.maxReportsInDatabaseCount,
      this.userProfileID,
      this.logs});
}
