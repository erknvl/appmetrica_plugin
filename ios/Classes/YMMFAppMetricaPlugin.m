/*
 * Version for Flutter
 * © 2022 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import "YMMFAppMetricaPlugin.h"
#import "YMMFPigeon.h"
#import "YMMFAppMetricaImplementation.h"
#import "YMMFReporterImplementation.h"
#import "YMMFAppMetricaConfigConverterImplementation.h"

@implementation YMMFAppMetricaPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar
{
    YMMFAppMetricaPigeonSetup(registrar.messenger, [[YMMFAppMetricaImplementation alloc] init]);
    YMMFReporterPigeonSetup(registrar.messenger, [[YMMFReporterImplementation alloc] init]);
    YMMFAppMetricaConfigConverterPigeonSetup(registrar.messenger, [[YMMFAppMetricaConfigConverterImplementation alloc] init]);
}

@end
