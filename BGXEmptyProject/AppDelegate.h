/*
 * Copyright 2018 Silicon Labs
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * {{ http://www.apache.org/licenses/LICENSE-2.0}}
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <UIKit/UIKit.h>

#import <bgxpress/bgxpress.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, BGXpressDelegate>


+ (AppDelegate *)sharedAppDelegate;

@property (strong, nonatomic) UIWindow *window;

- (BOOL)scan;

@property (strong, nonatomic) BGXpressManager * bgxManager;
@property (strong, nonatomic) CBCentralManager * centralManager;
@property (nonatomic) BOOL bluetoothReady;
@property (nonatomic) BOOL isScanning;
@property (strong, nonatomic) NSDate * lastScan;

@property (nonatomic, strong) id temporary_observer_reference;


@end

