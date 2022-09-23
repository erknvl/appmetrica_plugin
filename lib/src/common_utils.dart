/*
 * Version for Flutter
 * © 2022
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

import 'dart:developer';
import 'package:appmetrica_plugin/src/appmetrica.dart';
import 'package:logging/logging.dart';

void setUpErrorHandling() {
  setUpErrorHandlingWithAppMetrica();
}

void setUpLogger(Logger logger) {
  hierarchicalLoggingEnabled = true;
  logger.level = Level.ALL;
  logger.onRecord.listen((event) {
    log(event.message,
        error: event.error,
        stackTrace: event.stackTrace,
        sequenceNumber: event.sequenceNumber,
        name: event.loggerName,
        time: event.time,
        zone: event.zone,
        level: event.level.value);
  });
}
