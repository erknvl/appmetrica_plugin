/*
 * Version for Flutter
 * © 2022
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

import 'dart:io';

import 'package:appmetrica_plugin/src/appmetrica_api_pigeon.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';

extension ReceiptConverter on Receipt {
  ReceiptPigeon toPigeon() => ReceiptPigeon(data: data, signature: signature);
}

extension RevenueConverter on Revenue {
  RevenuePigeon toPigeon() => RevenuePigeon(
      price: price.toString(),
      currency: currency,
      productId: productId,
      quantity: quantity,
      payload: payload,
      transactionId: transactionId,
      receipt: receipt?.toPigeon());
}

List<StackTraceElementPigeon> convertErrorStackTrace(StackTrace stack) {
  final backtrace = Trace.from(stack).frames.map((element) {
    final firstDot = element.member?.indexOf(".") ?? -1;
    final className =
        firstDot >= 0 ? element.member?.substring(0, firstDot) : null;
    final methodName = element.member?.substring(firstDot + 1);
    return StackTraceElementPigeon(
        className: className ?? "",
        methodName: methodName ?? "",
        fileName: element.library,
        line: element.line ?? 0,
        column: element.column ?? 0);
  });
  return backtrace.toList(growable: false);
}

extension AppMetricaErrorDescriptionSubstitutor on AppMetricaErrorDescription? {
  AppMetricaErrorDescription tryToAddCurrentTrace() {
    if (this == null) {
      return AppMetricaErrorDescription.fromCurrentStackTrace();
    } else {
      return this!;
    }
  }
}

extension AppMetricaErrorDescriptionSerializer on AppMetricaErrorDescription {
  ErrorDetailsPigeon toPigeon() =>
      convertErrorDetails(type ?? "", message, stackTrace);
}

ErrorDetailsPigeon convertErrorDetails(
        String clazz, String? msg, StackTrace? stack) =>
    ErrorDetailsPigeon(
        exceptionClass: clazz,
        message: msg,
        dartVersion: Platform.version,
        backtrace: stack != null ? convertErrorStackTrace(stack) : []);

extension LocationConverter on Location {
  LocationPigeon toPigeon() => LocationPigeon(
      latitude: latitude,
      longitude: longitude,
      provider: provider,
      altitude: altitude,
      accuracy: accuracy,
      course: course,
      speed: speed,
      timestamp: timestamp);
}

extension PreloadInfoConverter on PreloadInfo {
  PreloadInfoPigeon toPigeon() =>
      PreloadInfoPigeon(trackingId: trackingId, additionalInfo: additionalInfo);
}

extension ConfigConverter on AppMetricaConfig {
  AppMetricaConfigPigeon toPigeon() => AppMetricaConfigPigeon(
      apiKey: apiKey,
      appVersion: appVersion,
      crashReporting: crashReporting,
      firstActivationAsUpdate: firstActivationAsUpdate,
      location: location?.toPigeon(),
      locationTracking: locationTracking,
      logs: logs,
      sessionTimeout: sessionTimeout,
      statisticsSending: statisticsSending,
      preloadInfo: preloadInfo?.toPigeon(),
      maxReportsInDatabaseCount: maxReportsInDatabaseCount,
      nativeCrashReporting: nativeCrashReporting,
      sessionsAutoTracking: sessionsAutoTracking,
      errorEnvironment: errorEnvironment,
      userProfileID: userProfileID,
      revenueAutoTracking: revenueAutoTracking);
}
