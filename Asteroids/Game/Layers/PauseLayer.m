//
//  PauseLayer.m
//  OpenGLTest
//
//  Created by Наталья Дидковская on 11.08.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import "PauseLayer.h"
#import "ASButton.h"
#import "Constants.h"

@implementation PauseLayer

@synthesize menuButton = _menuButton;
@synthesize gameButton = _gameButton;


- (id)init
{
    self = [super init];
    if (self) {
        
        _gameButton = [ASButton buttonWithImage:askGAME_BUTTON_IMAGE position:CGPointMake(0, 0)];
        [self addButton:_gameButton];
        
        
    }
    return self;
}

@end
