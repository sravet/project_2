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


#import "AppDelegate.h"

const NSTimeInterval kScanInterval = 8.0f;

@implementation AppDelegate

+ (AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    self.temporary_observer_reference = nil;
    self.bluetoothReady = NO;
    self.isScanning = NO;
    self.lastScan = [NSDate distantPast];
    self.bgxManager = [[BGXpressManager alloc] init];
    self.bgxManager.delegate = self;
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ConnectedToDeviceNotitficationName object:nil queue:nil usingBlock:^(NSNotification * n){
        
    }];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/** Called to begin scanning for devices.
 @Returns bool to indicate whether the scan call was successful.
 */
- (BOOL)scan
{
    BOOL fResult = NO;
    if (self.bluetoothReady) {
        
        if (!self.isScanning) {
            [[NSNotificationCenter defaultCenter] postNotificationName:DeviceListChangedNotificationName object: @[]];
            [self.bgxManager startScan];
            self.isScanning = YES;
            fResult = YES;
            self.lastScan = [NSDate date];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kScanInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.bgxManager stopScan];
                self.isScanning = NO;
            });
        }
    }
    return fResult;
}

#pragma mark BGXpressDelegate

- (void)deviceDiscovered
{
    NSLog(@"device discovered");
    
    NSMutableArray * devices = [self.bgxManager.devicesDiscovered mutableCopy];
    
    
    [devices sortUsingComparator:^(NSDictionary * d1, NSDictionary * d2)
     {
         return [[d2 objectForKey:@"RSSI"] compare: [d1 objectForKey:@"RSSI"]];
     }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DeviceListChangedNotificationName object: devices];
}

- (void)bluetoothStateChanged:(CBManagerState)state
{
    NSString * stateName = @"?";
    
    switch (state) {
        case CBManagerStateUnknown:
            stateName = @"CBManagerStateUnknown";
            self.bluetoothReady = NO;
            break;
        case CBManagerStateResetting:
            stateName = @"CBManagerStateResetting";
            self.bluetoothReady = NO;
            break;
        case CBManagerStateUnsupported:
            stateName = @"CBManagerStateUnsupported";
            self.bluetoothReady = NO;
            break;
        case CBManagerStateUnauthorized:
            stateName = @"CBManagerStateUnauthorized";
            self.bluetoothReady = NO;
            break;
        case CBManagerStatePoweredOff:
            stateName = @"CBManagerStatePoweredOff";
            self.bluetoothReady = NO;
            break;
        case CBManagerStatePoweredOn:
            stateName = @"CBManagerStatePoweredOn";
            self.bluetoothReady = YES;
            
            if (!self.isScanning) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self scan];
                });
            }
            
            break;
    }
    
    (void)(stateName);
  printf("%s: State: %s\n",__func__, stateName);
    NSLog(@"%@", stateName);
}

- (void)connectionStateChanged:(ConnectionState)newConnectionState
{
    NSString * cs = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:ConnectionStateChangedNotificationName object: [NSNumber numberWithInt:newConnectionState]];
    
    switch (newConnectionState) {
        case DISCONNECTED:
            cs = @"DISCONNECTED";
            [[NSNotificationCenter defaultCenter] postNotificationName:DisableFirmwareUpdateNotificationName object:nil];
            break;
        case SCANNING:
            cs = @"SCANNING";
            break;
        case CONNECTING:
            cs = @"CONNECTING";
            break;
        case INTERROGATING:
            cs = @"INTERROGATING";
            break;
        case CONNECTED:
            cs = @"CONNECTED";
            break;
        case DISCONNECTING:
            cs = @"DISCONNECTING";
            break;
        case CONNECTIONTIMEDOUT:
            cs = @"CONNECTIONTIMEDOUT";
            break;
    }
    NSLog(@"New ConnectionState %@", cs);
    if (CONNECTED == newConnectionState) {
        // you are now connected.
        [[NSNotificationCenter defaultCenter] postNotificationName:EnableFirmwareUpdateNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:ConnectedToDeviceNotitficationName object:nil];
    }
}

- (void)dataRead:(NSData *) newData
{
    // this is called when data is received.
    [[NSNotificationCenter defaultCenter] postNotificationName:DataReceivedNotificationName object:newData];
}

- (void)busModeChanged:(BusMode)newBusMode {
    char * nameNewBusMode = "?";
    switch (newBusMode) {
        case UNKNOWN_MODE:
            nameNewBusMode = "UNKNOWN_MODE";
            break;
        case STREAM_MODE:
            nameNewBusMode = "STREAM_MODE";
            break;
        case LOCAL_COMMAND_MODE:
            nameNewBusMode = "LOCAL_COMMAND_MODE";
            break;
        case REMOTE_COMMAND_MODE:
            nameNewBusMode = "REMOTE_COMMAND_MODE";
            break;
        case UNSUPPORTED_MODE:
            nameNewBusMode = "UNSUPPORTED_MODE";
            break;
    }
    NSLog(@"NewBusMode: %s", nameNewBusMode);
}

- (void)dataWritten {
    NSLog(@"dataWritten");
}

@end
