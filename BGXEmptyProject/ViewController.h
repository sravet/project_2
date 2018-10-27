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

typedef enum {
    
    None
    ,CR
    ,LF
    ,CRLF
    ,LFCR
    ,Invalid
    
} LineEndings;

typedef enum {
    SEND_MODE
    ,RECEIVE_MODE
    ,BUS_MODE_CHANGE_MODE
    ,ERROR_MODE
    ,INVALID_MODE
} TextMode;

@interface ViewController : UIViewController
{
    
}

@property (nonatomic) BusMode busMode;

@property (nonatomic) LineEndings lineEndings;

@property (nonatomic) TextMode textMode;

@property (nonatomic, strong) NSArray * observerReferences;


@end

