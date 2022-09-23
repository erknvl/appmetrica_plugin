/*
 * Version for Flutter
 * © 2022
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

library appmetrica;

export 'src/activation_config_holder.dart';
export 'src/appmetrica.dart' show AppMetrica;
export 'src/appmetrica_config.dart';
export 'src/common_utils.dart' show setUpErrorHandling, setUpLogger;
export 'src/deferred_deeplink_result.dart';
export 'src/device_id_result.dart';
export 'src/ecommerce.dart';
export 'src/ecommerce_event.dart' show ECommerceEvent;
export 'src/error_description.dart' show AppMetricaErrorDescription;
export 'src/location.dart';
export 'src/preload_info.dart';
export 'src/reporter/reporter_config.dart';
export 'src/revenue.dart';
export 'src/reporter/reporter.dart';

export 'src/profile/attribute.dart'
    show
        BirthDateAttribute,
        BooleanAttribute,
        CounterAttribute,
        GenderAttribute,
        Gender,
        NameAttribute,
        NotificationEnabledAttribute,
        NumberAttribute,
        StringAttribute,
        UserProfile;
