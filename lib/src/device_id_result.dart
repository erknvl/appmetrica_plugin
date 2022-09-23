/*
 * Version for Flutter
 * © 2022
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

/// Exception when requesting a unique AppMetrica ID.
class DeviceIdRequestException implements Exception {
  final DeviceIdErrorReason reason;
  DeviceIdRequestException(this.reason);
}

/// Contains possible error values when requesting a unique AppMetrica identifier:
/// * [unknown] - unknown error.
/// * [network] - internet connection problem.
/// * [invalidResponse] - server response parsing error.
enum DeviceIdErrorReason {
  unknown,
  network,
  invalidResponse,
}
