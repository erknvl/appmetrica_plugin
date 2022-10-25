/*
 * Version for Flutter
 * © 2022
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

import '../appmetrica_api_pigeon.dart';

class BirthDateAttribute extends UserProfileAttribute {
  final int? _age;
  final int? _year;
  final int? _month;
  final int? _day;

  final bool _reset;

  BirthDateAttribute.withAge(int age)
      : _age = age,
        _year = null,
        _month = null,
        _day = null,
        _reset = false;

  BirthDateAttribute.withYear(int year)
      : _age = null,
        _year = year,
        _month = null,
        _day = null,
        _reset = false;

  BirthDateAttribute.withDateParts(int year, int month, {int? day})
      : _age = null,
        _year = year,
        _month = month,
        _day = day,
        _reset = false;

  BirthDateAttribute.withDate(DateTime date)
      : _age = null,
        _year = date.year,
        _month = date.month,
        _day = date.day,
        _reset = false;

  BirthDateAttribute.withValueReset()
      : _age = null,
        _year = null,
        _month = null,
        _day = null,
        _reset = true;

  @override
  UserProfileAttributeType _type() => UserProfileAttributeType.BIRTH_DATE;

  @override
  UserProfileAttributePigeon _toPigeon() => super._toPigeon()
    ..year = _year
    ..month = _month
    ..day = _day
    ..age = _age
    ..ifUndefined = false
    ..reset = _reset;
}

class BooleanAttribute extends _ValueAttribute<bool> {
  BooleanAttribute.withValue(key, value, {ifUndefined = false})
      : super(key, value, ifUndefined, false);

  BooleanAttribute.withValueReset(key) : super(key, null, false, true);

  @override
  UserProfileAttributeType _type() => UserProfileAttributeType.BOOLEAN;

  @override
  void _setPigeonValue(UserProfileAttributePigeon pigeon) {
    pigeon.boolValue = _value;
  }
}

class CounterAttribute extends UserProfileAttribute {
  final String key;
  final double _delta;

  CounterAttribute.withDelta(this.key, this._delta);

  @override
  UserProfileAttributePigeon _toPigeon() => super._toPigeon()
    ..key = key
    ..reset = false
    ..ifUndefined = false
    ..doubleValue = _delta;

  @override
  UserProfileAttributeType _type() => UserProfileAttributeType.COUNTER;
}

class GenderAttribute extends _ValueAttribute<Gender> {
  GenderAttribute.withValue(value) : super("", value, false, false);

  GenderAttribute.withValueReset() : super("", null, false, true);

  @override
  UserProfileAttributeType _type() => UserProfileAttributeType.GENDER;

  @override
  void _setPigeonValue(UserProfileAttributePigeon pigeon) {
    pigeon.genderValue =
        _value == null ? GenderPigeon.UNDEFINED : genderToPigeon[_value];
  }
}

enum Gender {
  MALE,
  FEMALE,
  OTHER,
}

class NameAttribute extends StringAttribute {
  NameAttribute.withValue(value)
      : super.withValue("", value, ifUndefined: false);

  NameAttribute.withValueReset() : super.withValueReset("");

  @override
  UserProfileAttributeType _type() => UserProfileAttributeType.NAME;
}

class NotificationEnabledAttribute extends BooleanAttribute {
  NotificationEnabledAttribute.withValue(value)
      : super.withValue("", value, ifUndefined: false);

  NotificationEnabledAttribute.withValueReset() : super.withValueReset("");

  @override
  UserProfileAttributeType _type() =>
      UserProfileAttributeType.NOTIFICATION_ENABLED;
}

class NumberAttribute extends _ValueAttribute<double> {
  NumberAttribute.withValue(key, value, {ifUndefined = false})
      : super(key, value, ifUndefined, false);

  NumberAttribute.withValueReset(key) : super(key, null, false, true);

  @override
  void _setPigeonValue(UserProfileAttributePigeon pigeon) {
    pigeon.doubleValue = _value;
  }

  @override
  UserProfileAttributeType _type() => UserProfileAttributeType.NUMBER;
}

class StringAttribute extends _ValueAttribute<String> {
  StringAttribute.withValue(key, value, {ifUndefined = false})
      : super(key, value, ifUndefined, false);

  StringAttribute.withValueReset(key) : super(key, null, false, true);

  @override
  void _setPigeonValue(UserProfileAttributePigeon pigeon) {
    pigeon.stringValue = _value;
  }

  @override
  UserProfileAttributeType _type() => UserProfileAttributeType.STRING;
}

class UserProfile {
  final List<UserProfileAttribute> _attributes;

  UserProfile(this._attributes);
}

abstract class UserProfileAttribute {
  UserProfileAttributePigeon _toPigeon() => UserProfileAttributePigeon(key: "")
    ..genderValue = GenderPigeon.UNDEFINED
    ..type = _type();

  UserProfileAttributeType _type();
}

abstract class _ValueAttribute<T> extends UserProfileAttribute {
  final String _key;
  final T? _value;
  final bool _ifUndefined;
  final bool _reset;

  _ValueAttribute(this._key, this._value, this._ifUndefined, this._reset);

  @override
  UserProfileAttributePigeon _toPigeon() {
    final result = super._toPigeon()
      ..key = _key
      ..ifUndefined = _ifUndefined
      ..reset = _reset;
    _setPigeonValue(result);
    return result;
  }

  void _setPigeonValue(UserProfileAttributePigeon pigeon);
}

final genderToPigeon = {
  Gender.MALE: GenderPigeon.MALE,
  Gender.FEMALE: GenderPigeon.FEMALE,
  Gender.OTHER: GenderPigeon.OTHER,
};

extension UserProfileConverter on UserProfile {
  UserProfilePigeon toPigeon() {
    final result = UserProfilePigeon(
        attributes:
            _attributes.map((e) => e._toPigeon()).toList(growable: false));

    return result;
  }
}
