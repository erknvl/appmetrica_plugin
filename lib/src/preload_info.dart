/*
 * Version for Flutter
 * © 2022
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

/// The class contains information for tracking pre-installed applications.
class PreloadInfo {
  final String trackingId;
  final Map<String, String>? additionalInfo;

  /// Creates a [PreloadInfo] object with [trackingId] and a list of additional parameters [additionalInfo].
  /// [trackingId] is a required parameter.
  const PreloadInfo(this.trackingId, {this.additionalInfo});
}
