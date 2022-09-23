/*
 * Version for Flutter
 * © 2022 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import <YandexMobileMetrica/YandexMobileMetrica.h>
#import "YMMFPluginErrorDetailsConverter.h"
#import "YMMFStackTraceConverter.h"

@implementation YMMFPluginErrorDetailsConverter

+ (YMMPluginErrorDetails *)convert:(YMMFErrorDetailsPigeon *)error
{
    return [[YMMPluginErrorDetails alloc] initWithExceptionClass:error.exceptionClass
                                                         message:error.message
                                                       backtrace:[YMMFStackTraceConverter convert:error.backtrace]
                                                        platform:kYMMPlatformFlutter
                                           virtualMachineVersion:error.dartVersion
                                               pluginEnvironment:@{}];
}

@end
