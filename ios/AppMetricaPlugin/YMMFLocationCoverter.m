/*
 * Version for Flutter
 * © 2022 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import <CoreLocation/CoreLocation.h>
#import "YMMFLocationConverter.h"

@implementation YMMFLocationConverter

+ (CLLocation *)convert:(YMMFLocationPigeon *)pigeon
{
    if (pigeon == nil) {
        return nil;
    }
    return [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(pigeon.latitude.doubleValue, pigeon.longitude.doubleValue)
                                         altitude:pigeon.altitude.doubleValue
                               horizontalAccuracy:pigeon.accuracy.doubleValue
                                 verticalAccuracy:pigeon.accuracy.doubleValue
                                           course:pigeon.course.doubleValue
                                            speed:pigeon.speed.doubleValue
                                        timestamp:[NSDate dateWithTimeIntervalSince1970: pigeon.timestamp.doubleValue]];
}

@end
