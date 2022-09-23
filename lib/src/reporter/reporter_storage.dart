/*
 * Version for Flutter
 * © 2022
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

import 'reporter.dart';
import 'reporter_impl.dart';

class ReporterStorage {
  final _map = <String, Reporter>{};

  Reporter getReporter(String apiKey) =>
      _map.putIfAbsent(apiKey, () => ReporterImpl(apiKey));
}
