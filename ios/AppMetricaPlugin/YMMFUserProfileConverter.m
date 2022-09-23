/*
 * Version for Flutter
 * © 2022 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import "YMMFUserProfileConverter.h"
#import <YandexMobileMetrica/YandexMobileMetrica.h>

@implementation YMMFUserProfileConverter

+ (YMMUserProfile *)convert:(YMMFUserProfilePigeon *)userProfile
{

    YMMMutableUserProfile *convertedUserProfile = [[YMMMutableUserProfile alloc] init];

    for (YMMFUserProfileAttributePigeon* attribute in userProfile.attributes) {
        YMMUserProfileUpdate *profileUpdate = nil;
        switch (attribute.type) {
            case YMMFUserProfileAttributeTypeNAME: {
                if (attribute.reset.boolValue) {
                    profileUpdate = [[YMMProfileAttribute name] withValueReset];
                } else {
                    profileUpdate = [[YMMProfileAttribute name] withValue:attribute.stringValue];
                }
                break;
            }
            case YMMFUserProfileAttributeTypeBIRTH_DATE: {
                id<YMMBirthDateAttribute> birthdateAttribute = [YMMProfileAttribute birthDate];
                if (attribute.reset.boolValue) {
                    profileUpdate = [birthdateAttribute withValueReset];
                } else {
                    NSNumber *year = attribute.year;
                    NSNumber *month = attribute.month;
                    NSNumber *day = attribute.day;
                    NSNumber *age = attribute.age;
                    if (year == nil) {
                        if (age != nil) {
                            profileUpdate = [birthdateAttribute withAge:age.unsignedIntegerValue];
                        } else {
                            profileUpdate = nil;
                        }
                    } else {
                        if (month == nil) {
                            profileUpdate = [birthdateAttribute withYear:year.unsignedIntegerValue];
                        } else {
                            if (day == nil) {
                                profileUpdate = [birthdateAttribute withYear:year.unsignedIntegerValue
                                                                       month:month.unsignedIntegerValue];
                            } else {
                                profileUpdate = [birthdateAttribute withYear:year.unsignedIntegerValue
                                                                       month:month.unsignedIntegerValue
                                                                         day:day.unsignedIntegerValue];
                            }
                        }
                    }
                }
                break;
            }
            case YMMFUserProfileAttributeTypeBOOLEAN: {
                id<YMMCustomBoolAttribute> booleanAttribute = [YMMProfileAttribute customBool:attribute.key];
                if (attribute.reset.boolValue) {
                    profileUpdate = [booleanAttribute withValueReset];
                } else {
                    if (attribute.ifUndefined.boolValue) {
                        profileUpdate = [booleanAttribute withValueIfUndefined:attribute.boolValue.boolValue];
                    } else {
                        profileUpdate = [booleanAttribute withValue:attribute.boolValue.boolValue];
                    }
                }
                break;
            }
            case YMMFUserProfileAttributeTypeCOUNTER: {
                profileUpdate = [[YMMProfileAttribute customCounter:attribute.key] withDelta:attribute.doubleValue.doubleValue];
                break;
            }
            case YMMFUserProfileAttributeTypeGENDER: {
                if (attribute.reset.boolValue) {
                    profileUpdate = [[YMMProfileAttribute gender] withValueReset];
                } else {
                    profileUpdate = [[YMMProfileAttribute gender] withValue:[self convertGender:attribute.genderValue]];
                }
                break;
            }
            case YMMFUserProfileAttributeTypeNOTIFICATION_ENABLED: {
                if (attribute.reset.boolValue) {
                    profileUpdate = [[YMMProfileAttribute notificationsEnabled] withValueReset];
                } else {
                    profileUpdate = [[YMMProfileAttribute notificationsEnabled] withValue:attribute.boolValue.boolValue];
                }
                break;
            }
            case YMMFUserProfileAttributeTypeNUMBER: {
                id<YMMCustomNumberAttribute> numberAttribute = [YMMProfileAttribute customNumber:attribute.key];
                if (attribute.reset.boolValue) {
                    profileUpdate = [numberAttribute withValueReset];
                } else {
                    if (attribute.ifUndefined.boolValue) {
                        profileUpdate = [numberAttribute withValueIfUndefined:attribute.doubleValue.doubleValue];
                    } else {
                        profileUpdate = [numberAttribute withValue:attribute.doubleValue.doubleValue];
                    }
                }
                break;
            }
            case YMMFUserProfileAttributeTypeSTRING: {
                id<YMMCustomStringAttribute> stringAttribute = [YMMProfileAttribute customString:attribute.key];
                if (attribute.reset.boolValue) {
                    profileUpdate = [stringAttribute withValueReset];
                } else {
                    if (attribute.ifUndefined.boolValue) {
                        profileUpdate = [stringAttribute withValueIfUndefined:attribute.stringValue];
                    } else {
                        profileUpdate = [stringAttribute withValue:attribute.stringValue];
                    }
                }
                break;
            }
        }

        if (profileUpdate != nil) {
            [convertedUserProfile apply:profileUpdate];
        }
    }
    return [convertedUserProfile copy];
}

+ (YMMGenderType)convertGender:(YMMFGenderPigeon)gender
{
    switch (gender) {
        case YMMFGenderPigeonMALE:
            return YMMGenderTypeMale;
        case YMMFGenderPigeonOTHER:
            return YMMGenderTypeOther;
        case YMMFGenderPigeonFEMALE:
            return YMMGenderTypeFemale;
        case YMMFGenderPigeonUNDEFINED:
        default:
            return YMMGenderTypeOther;
    }
}

@end
