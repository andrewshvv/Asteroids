//
//  States.m
//  OpenGLTest
//
//  Created by Наталья Дидковская on 24.07.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//
#import "States.h"

#import "ASLayerManager.h"


#import "GameLayer.h"
#import "PauseLayer.h"
#import "RepeatLayer.h"

#import "Constants.h"


#define mustOverride() @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil]


@implementation StateMachine


- (id) initWithState:(NSInteger)state {

    self = [super init];
    if (self) {
        
        self.states = [NSMutableDictionary dictionary];
        
        [self addState:[[Game alloc] initWithMachine:self] name: STATE_GAME];
        [self addState:[[Pause alloc] initWithMachine:self] name:STATE_PAUSE];
        
        self.generalState = [self state: state];
        
        
        _gameLayer = [[GameLayer alloc] init];
        _pauseLayer = [[PauseLayer alloc] init];
        _repeatLayer = [[RepeatLayer alloc] init];
        
        
        [_gameLayer setPause:NO];
        [_gameLayer setHidden:NO];
        
        [_pauseLayer setPause:YES];
        [_pauseLayer setHidden:YES];
        
        [_repeatLayer setPause:YES];
        [_repeatLayer setHidden:YES];
        

        
        __block StateMachine *sm = self;
        _gameLayer.pauseButton.beganBlock = ^(NSSet *touhes,UIEvent *event){
            
            [sm.generalState pause];
            
        };
        
        __block RepeatLayer *blockRepeatLayer = _repeatLayer;
        __block GameLayer *blockGameLayer = _gameLayer;
        _gameLayer.plane.death = ^(){
            
            [blockGameLayer setPause:YES];
            
            [blockRepeatLayer setPause:NO];
            [blockRepeatLayer setHidden:NO];
            
        };
        
        _repeatLayer.yes.beganBlock = ^(NSSet *touhes,UIEvent *event){
            
            [blockGameLayer.plane alive];
            [blockRepeatLayer setPause:YES];
            [blockRepeatLayer setHidden:YES];
            
            [blockGameLayer setPause:NO];
            
        };
        
        
        _pauseLayer.gameButton.beganBlock = ^(NSSet *touhes,UIEvent *event){
            
            [sm.generalState play];

        };

        
    }
    return self;
}

- (void) addState:(State*)object name:(StateName) name {
    
    [self.states setObject: object forKey:[NSNumber numberWithInteger:name]];
    
}

- (State*) state:(StateName) name {
    
    return [self.states objectForKey:[NSNumber numberWithInteger:name]];
    
}

@end

@implementation State

@synthesize machine = _machine;

- (id)initWithMachine:(StateMachine*) machine
{
    self = [super init];
    if (self) {
        
        self.machine = machine;
        
    }
    return self;
}

- (void) play   { NSLog(@"State: %@ method: play   do: Nothing",[self class]);   ;}
- (void) pause  { NSLog(@"State: %@ method: pause  do: Nothing",[self class]);   ;}
- (void) rating { NSLog(@"State: %@ method: rating do: Nothing",[self class]);   ;}
- (void) load   { NSLog(@"State: %@ method: load   do: Nothing",[self class]);   ;}
- (void) menu   { NSLog(@"State: %@ method: menu   do: Nothing",[self class]);   ;}
    

@end

@implementation Game

- (void) pause {
    
    [self.machine.gameLayer setPause:YES];
    [self.machine.gameLayer setHidden:NO];
    [self.machine.gameLayer.pauseButton setHidden:YES];
    
    
    [self.machine.pauseLayer setPause:NO];
    [self.machine.pauseLayer setHidden:NO ];
    
    self.machine.generalState = [self.machine state: STATE_PAUSE];
    
}
@end

@implementation Pause


- (void) play {
    
    [self.machine.gameLayer setPause:NO];
    [self.machine.gameLayer setHidden:NO ];
    
    
    [self.machine.pauseLayer setPause:YES];
    [self.machine.pauseLayer setHidden:YES ];
    
    self.machine.generalState = [self.machine state: STATE_GAME];
    
}
@end

@implementation Menu

- (void) play {
    
    [self.machine.gameLayer     setPause:NO];
    [self.machine.gameLayer     setHidden:NO ];
    
    
    [self.machine.pauseLayer    setPause:YES];
    [self.machine.pauseLayer    setHidden:YES ];
    
    self.machine.generalState = [self.machine state: STATE_GAME];
    
}
- (void) rating {
    
    self.machine.generalState = [self.machine state: STATE_RATING];
    
}

@end

