/*
 * Version for Flutter
 * © 2022
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

/// The class contains settings about the device location.
class Location {
  final double latitude;
  final double longitude;
  final String? provider;
  final double? altitude;
  final double? accuracy;
  final double? course;
  final double? speed;
  final int? timestamp;

  /// Creates an object of the [Location] class with the specified parameters. The parameters [latitude], [longitude] are required.
  const Location(this.latitude, this.longitude,
      {this.provider,
      this.altitude,
      this.accuracy,
      this.course,
      this.speed,
      this.timestamp});
}
