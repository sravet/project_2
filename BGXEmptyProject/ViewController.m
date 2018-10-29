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


#import "ViewController.h"
#import "AppDelegate.h"
#import "TabBarControllerViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.busMode = UNKNOWN_MODE;
    self.textMode = INVALID_MODE;
    self.lineEndings = CRLF;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [[AppDelegate sharedAppDelegate].bgxManager addObserver:self forKeyPath:@"busMode" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:nil];
    
    [[AppDelegate sharedAppDelegate].bgxManager addObserver:self forKeyPath:@"connectionState" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataReceived:) name:DataReceivedNotificationName object:nil];
    
    [super viewWillAppear:animated];
  
  
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [[AppDelegate sharedAppDelegate].bgxManager removeObserver:self forKeyPath:@"busMode"];
    [[AppDelegate sharedAppDelegate].bgxManager removeObserver:self forKeyPath:@"connectionState"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DataReceivedNotificationName object:nil];
    
    [[AppDelegate sharedAppDelegate].bgxManager disconnect];
    
    [super viewWillDisappear:animated];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"obserer key path: %@", keyPath);
    
    if ([keyPath isEqualToString:@"connectionState"])
    {
        switch([AppDelegate sharedAppDelegate].bgxManager.connectionState) {
            case DISCONNECTED:
                [self.navigationController popViewControllerAnimated:YES];
                break;
            default:
                NSLog(@"Detected a connectionState change.");
                break;
        }
    }
    else if ([keyPath isEqualToString:@"busMode"])
    {
        
        if (self.busMode != [AppDelegate sharedAppDelegate].bgxManager.busMode)
        {
            
            self.textMode = BUS_MODE_CHANGE_MODE;
            
            self.busMode = [AppDelegate sharedAppDelegate].bgxManager.busMode;
            NSString * modeName = @"?";
            
            switch([AppDelegate sharedAppDelegate].bgxManager.busMode) {
                case STREAM_MODE:
                    modeName = @"STREAM_MODE";
              
                    break;
                case LOCAL_COMMAND_MODE: /// This case ordinarily wouldn't happen while you are connected.
                    modeName = @"LOCAL_COMMAND_MODE";
  
                    break;
                case REMOTE_COMMAND_MODE:
                {
                    modeName = @"REMOTE_COMMAND_MODE";
            
                }
                    
                    break;
                default:
                    modeName = @"SOME_OTHER_MODE";
                    break;
            }
            
            
        }
    }
}

/** Data received from the BGX device is passed to the BGXCommanderDelegate which
 in this app is the AppDelegate. Then the app delegate posts it as a notification
 which we pick up here. You may wish to do this differently.
 */
- (void)dataReceived:(NSNotification *)n
{
    NSString * plainString;
    
    NSData * data = [n object];
    
    if ( RECEIVE_MODE != self.textMode) {
        plainString = [NSString stringWithFormat: @"\n> %@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] ];
        self.textMode = RECEIVE_MODE;
    } else {
        plainString = [NSString stringWithFormat: @"%@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] ];
    }

    NSLog(@"plainString data receieved: %@", plainString);
}

-(void)sendData:(NSInteger)buttonTag
{
    NSString *cmd;
  NSLog(@"");
    if (STREAM_MODE == self.busMode)
    {
        if ([[AppDelegate sharedAppDelegate].bgxManager canWrite])
        {
          switch(buttonTag) {
            case 6:  cmd = @"7"; break; // Murrica!
            case 7:  cmd = @"1"; break; // red
            case 8:  cmd = @"2"; break; // green
            case 9:  cmd = @"3"; break; // blue
            case 10: cmd = @"h"; break; // yellow
            case 11: cmd = @"4"; break; // pink
            case 12: cmd = @"5"; break; // dodgers
            case 13: cmd = @"6"; break; // longhorns
            case 14: cmd = @"0"; break; // off
            default:
              NSLog(@"Invalid button tag %ld", buttonTag);
              break;
          }
          bool result = [[AppDelegate sharedAppDelegate].bgxManager writeString:(cmd)];
          NSLog(@"Writing %@: %s\n", cmd, result ? "Success" : "Failed");
        }
        else
        {
            NSLog(@"Can't write data, canWrite is false");
            self.textMode = ERROR_MODE;
        }
    }
    else if (REMOTE_COMMAND_MODE == self.busMode)
    {
      NSLog(@"Problem -- BGX is in command mode, not stream mode");
        //[[AppDelegate sharedAppDelegate].bgxManager sendCommand:@"Test string send" args:@""];
    } else {
      NSLog(@"not in stream mode");
    }
}

- (IBAction)buttonPress:(id)sender {

  NSLog(@"Button press: %ld", [sender tag]);
  [self sendData:[sender tag]];
}



- (IBAction)connectRemote:(id)sender {
  
  printf("%s\n",__func__);
  bool result = [[AppDelegate sharedAppDelegate].bgxManager writeBusMode: REMOTE_COMMAND_MODE];
  if (result) {
    printf("writeBusMode success\n");
  } else {
    printf("writeBusMode failed\n");
  }
}


- (IBAction)connectDevice:(id)sender {
  
  printf("%s\n",__func__);
  NSString *device_name = @"BGX-8D0A";
  bool result = [[AppDelegate sharedAppDelegate].bgxManager connectToDevice: device_name];
  NSLog(@"Tried to connect to %@: %s\n", device_name, result ? "Success" : "Failed");
}

//- (IBAction)sendEvent:(id)sender
//{
//  printf("%s\n",__func__);
//    [self sendData];
//}


@end
