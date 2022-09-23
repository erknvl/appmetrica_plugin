/*
 * Version for Flutter
 * © 2022 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import <YandexMobileMetrica/YandexMobileMetrica.h>
#import "YMMFStackTraceConverter.h"

@implementation YMMFStackTraceConverter

+ (NSArray<YMMStackTraceElement *> *)convert:(NSArray<YMMFStackTraceElementPigeon *> *)backtracePigeon
{
    NSMutableArray<YMMStackTraceElement *> *elements = [NSMutableArray arrayWithCapacity:backtracePigeon.count];
    for (YMMFStackTraceElementPigeon *backtrace in backtracePigeon) {
        if (backtrace != nil) {
            [elements addObject:[self convertBacktrace:backtrace]];
        }
    }
    return [elements copy];
}

+ (YMMStackTraceElement *)convertBacktrace:(YMMFStackTraceElementPigeon *)backtrace
{
    return [[YMMStackTraceElement alloc] initWithClassName:backtrace.className
                                                  fileName:backtrace.fileName
                                                      line:backtrace.line
                                                    column:backtrace.column
                                                methodName:backtrace.methodName];
}

@end
