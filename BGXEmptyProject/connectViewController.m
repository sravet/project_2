//
//  SecondViewController.m
//  xyz
//
//  Created by Steve Ravet on 10/27/18.
//  Copyright © 2018 Steve Ravet. All rights reserved.
//

#import "connectViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "TabBarControllerViewController.h"

@interface connectViewController ()

@end

@implementation connectViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)connectToADevice:(id)sender {
  
  NSString *device_name = [[NSString alloc] initWithFormat:@"GC%ld", [sender tag]];
  NSLog(@"%s to button %@ %ld (%@)\n", __func__, sender, [sender tag], device_name);
  bool result = [[AppDelegate sharedAppDelegate].bgxManager connectToDevice: device_name];
  NSLog(@"Tried to connect to %@: %s\n", device_name, result ? "Success" : "Failed");
}

- (IBAction)disconnectEvent:(id)sender {
  
  printf("%s\n",__func__);
  bool result = [[AppDelegate sharedAppDelegate].bgxManager disconnect];
  if (result) {
    printf("writeBusMode success\n");
  } else {
    printf("writeBusMode failed\n");
  }
  
}


@end
