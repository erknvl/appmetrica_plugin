/*
 * Version for Flutter
 * © 2022
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

import 'package:appmetrica_plugin/src/appmetrica_api_pigeon.dart';
import 'package:appmetrica_plugin/src/profile/attribute.dart';
import 'package:flutter_test/flutter_test.dart';

class _UserProfileMatcher extends Matcher {
  final UserProfileAttributePigeon expected;

  _UserProfileMatcher(this.expected);

  @override
  Description describe(Description description) =>
      description.add("profile matcher");

  @override
  bool matches(covariant UserProfileAttributePigeon actual,
          Map<dynamic, dynamic> matchState) =>
      actual.day == expected.day &&
      actual.month == expected.month &&
      actual.year == expected.year &&
      actual.age == expected.age &&
      actual.ifUndefined == expected.ifUndefined &&
      actual.reset == expected.reset &&
      actual.genderValue == expected.genderValue &&
      actual.key == expected.key &&
      actual.doubleValue == expected.doubleValue &&
      actual.boolValue == expected.boolValue &&
      actual.stringValue == expected.stringValue;
}

UserProfileAttributePigeon? _convert(UserProfileAttribute attribute) =>
    UserProfile([attribute]).toPigeon().attributes.first;

UserProfileAttributePigeon _template(UserProfileAttributeType type,
        {bool reset = false, bool ifUndefined = false}) =>
    UserProfileAttributePigeon(
        key: "",
        genderValue: GenderPigeon.UNDEFINED,
        type: type,
        reset: reset,
        ifUndefined: ifUndefined);

void main() {
  group("BirthDateAttribute", () {
    test('birthDateWithAge', () async {
      expect(
          _convert(BirthDateAttribute.withAge(20)),
          _UserProfileMatcher(_template(UserProfileAttributeType.BIRTH_DATE)
            ..type = UserProfileAttributeType.BIRTH_DATE
            ..age = 20));
    });
    test('birthDateWithAgeIfUndefinde', () async {
      expect(
          _convert(BirthDateAttribute.withAge(20)),
          _UserProfileMatcher(
              _template(UserProfileAttributeType.BIRTH_DATE, ifUndefined: false)
                ..type = UserProfileAttributeType.BIRTH_DATE
                ..age = 20));
    });
    test('birthDateWithDate', () async {
      final now = DateTime.now();
      expect(
          _convert(BirthDateAttribute.withDate(now)),
          _UserProfileMatcher(_template(UserProfileAttributeType.BIRTH_DATE)
            ..type = UserProfileAttributeType.BIRTH_DATE
            ..year = now.year
            ..month = now.month
            ..day = now.day));
    });
    test('birthDateWithAgeIfUndefinde', () async {
      final now = DateTime.now();
      expect(
          _convert(BirthDateAttribute.withDate(now)),
          _UserProfileMatcher(
              _template(UserProfileAttributeType.BIRTH_DATE, ifUndefined: false)
                ..type = UserProfileAttributeType.BIRTH_DATE
                ..year = now.year
                ..month = now.month
                ..day = now.day));
    });
    test('birthDateWithYear', () async {
      expect(
          _convert(BirthDateAttribute.withYear(20)),
          _UserProfileMatcher(_template(UserProfileAttributeType.BIRTH_DATE)
            ..type = UserProfileAttributeType.BIRTH_DATE
            ..year = 20));
    });
    test('birthDateWithYearIfUndefined', () async {
      expect(
          _convert(BirthDateAttribute.withYear(20)),
          _UserProfileMatcher(
              _template(UserProfileAttributeType.BIRTH_DATE, ifUndefined: false)
                ..type = UserProfileAttributeType.BIRTH_DATE
                ..year = 20));
    });
    test('birthDateWithDateParts', () async {
      expect(
          _convert(BirthDateAttribute.withDateParts(20, 21)),
          _UserProfileMatcher(_template(UserProfileAttributeType.BIRTH_DATE)
            ..type = UserProfileAttributeType.BIRTH_DATE
            ..year = 20
            ..month = 21));
    });
    test('birthDateWithDatePartsIfUndefined', () async {
      expect(
          _convert(BirthDateAttribute.withDateParts(20, 21)),
          _UserProfileMatcher(
              _template(UserProfileAttributeType.BIRTH_DATE, ifUndefined: false)
                ..type = UserProfileAttributeType.BIRTH_DATE
                ..year = 20
                ..month = 21));
    });
    test('birthDateWithDatePartsAndDay', () async {
      expect(
          _convert(BirthDateAttribute.withDateParts(20, 21, day: 22)),
          _UserProfileMatcher(_template(UserProfileAttributeType.BIRTH_DATE)
            ..type = UserProfileAttributeType.BIRTH_DATE
            ..year = 20
            ..month = 21
            ..day = 22));
    });
    test('birthDateWithDatePartsAndDayIfUndefined', () async {
      expect(
          _convert(BirthDateAttribute.withDateParts(20, 21, day: 22)),
          _UserProfileMatcher(
              _template(UserProfileAttributeType.BIRTH_DATE, ifUndefined: false)
                ..type = UserProfileAttributeType.BIRTH_DATE
                ..year = 20
                ..month = 21
                ..day = 22));
    });
  });

  group("BooleanAttribute", () {
    test("withValue", () {
      var itemKey = "key";
      var value = false;
      expect(
          _convert(BooleanAttribute.withValue(itemKey, value)),
          _UserProfileMatcher(_template(UserProfileAttributeType.BOOLEAN)
            ..key = itemKey
            ..boolValue = value));
    });
    test("withValueIfUndefined", () {
      var itemKey = "key";
      var value = false;
      expect(
          _convert(
              BooleanAttribute.withValue(itemKey, value, ifUndefined: true)),
          _UserProfileMatcher(_template(UserProfileAttributeType.BOOLEAN)
            ..key = itemKey
            ..boolValue = value
            ..ifUndefined = true));
    });
    test("withValueReset", () {
      var itemKey = "key";
      expect(
          _convert(BooleanAttribute.withValueReset(itemKey)),
          _UserProfileMatcher(_template(UserProfileAttributeType.BOOLEAN)
            ..key = itemKey
            ..reset = true));
    });
  });

  group("CounterAttribute", () {
    test("withValue", () {
      var itemKey = "key";
      var value = 11.0;
      expect(
          _convert(CounterAttribute.withDelta(itemKey, value)),
          _UserProfileMatcher(_template(UserProfileAttributeType.COUNTER)
            ..key = itemKey
            ..doubleValue = value));
    });
  });

  group("GenderAttribute", () {
    test("withValue", () {
      expect(
          _convert(GenderAttribute.withValue(Gender.MALE)),
          _UserProfileMatcher(_template(UserProfileAttributeType.GENDER)
            ..genderValue = GenderPigeon.MALE));
    });
    test("withValueIfUndefined", () {
      expect(
          _convert(GenderAttribute.withValue(Gender.FEMALE)),
          _UserProfileMatcher(_template(UserProfileAttributeType.GENDER)
            ..genderValue = GenderPigeon.FEMALE
            ..ifUndefined = false));
    });
    test("withValueReset", () {
      expect(
          _convert(GenderAttribute.withValueReset()),
          _UserProfileMatcher(
              _template(UserProfileAttributeType.GENDER)..reset = true));
    });
  });

  group("NameAttribute", () {
    test("withValue", () {
      final val = "Some name";
      expect(
          _convert(NameAttribute.withValue(val)),
          _UserProfileMatcher(
              _template(UserProfileAttributeType.NAME)..stringValue = val));
    });
    test("withValueIfUndefined", () {
      final val = "Some name";
      expect(
          _convert(NameAttribute.withValue(val)),
          _UserProfileMatcher(_template(UserProfileAttributeType.NAME)
            ..stringValue = val
            ..ifUndefined = false));
    });
    test("withValueReset", () {
      expect(
          _convert(NameAttribute.withValueReset()),
          _UserProfileMatcher(
              _template(UserProfileAttributeType.NAME)..reset = true));
    });
  });

  group("NotificationEnabledAttribute", () {
    test("withValue", () {
      final val = true;
      expect(
          _convert(NotificationEnabledAttribute.withValue(val)),
          _UserProfileMatcher(
              _template(UserProfileAttributeType.NOTIFICATION_ENABLED)
                ..boolValue = val));
    });
    test("withValueIfUndefined", () {
      final val = true;
      expect(
          _convert(NotificationEnabledAttribute.withValue(val)),
          _UserProfileMatcher(
              _template(UserProfileAttributeType.NOTIFICATION_ENABLED)
                ..boolValue = val
                ..ifUndefined = false));
    });
    test("withValueReset", () {
      expect(
          _convert(NotificationEnabledAttribute.withValueReset()),
          _UserProfileMatcher(
              _template(UserProfileAttributeType.NOTIFICATION_ENABLED)
                ..reset = true));
    });
  });

  group("NumberAttribute", () {
    test("withValue", () {
      final key = "someKey";
      final val = 100.0;
      expect(
          _convert(NumberAttribute.withValue(key, val)),
          _UserProfileMatcher(_template(UserProfileAttributeType.NUMBER)
            ..key = key
            ..doubleValue = val));
    });
    test("withValueIfUndefined", () {
      final key = "someKey";
      final val = 100.0;
      expect(
          _convert(NumberAttribute.withValue(key, val, ifUndefined: true)),
          _UserProfileMatcher(_template(UserProfileAttributeType.NUMBER)
            ..key = key
            ..doubleValue = val
            ..ifUndefined = true));
    });
    test("withValueReset", () {
      final key = "someKey";
      expect(
          _convert(NumberAttribute.withValueReset(key)),
          _UserProfileMatcher(_template(UserProfileAttributeType.NUMBER)
            ..key = key
            ..reset = true));
    });
  });

  group("StringAttribute", () {
    test("withValue", () {
      final key = "someKey";
      final val = "Some name";
      expect(
          _convert(StringAttribute.withValue(key, val)),
          _UserProfileMatcher(_template(UserProfileAttributeType.STRING)
            ..key = key
            ..stringValue = val));
    });
    test("withValueIfUndefined", () {
      final key = "someKey";
      final val = "Some name";
      expect(
          _convert(StringAttribute.withValue(key, val, ifUndefined: true)),
          _UserProfileMatcher(_template(UserProfileAttributeType.STRING)
            ..key = key
            ..stringValue = val
            ..ifUndefined = true));
    });
    test("withValueReset", () {
      final key = "someKey";
      expect(
          _convert(StringAttribute.withValueReset(key)),
          _UserProfileMatcher(_template(UserProfileAttributeType.STRING)
            ..key = key
            ..reset = true));
    });
  });
}
