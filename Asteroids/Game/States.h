//
//  States.h
//  OpenGLTest
//
//  Created by Наталья Дидковская on 24.07.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ASLayerManager;

@class GameLayer;
@class PauseLayer;
@class MenuLayer;
@class RepeatLayer;


typedef enum {
    
    STATE_GAME = 0,
    STATE_PAUSE,
    STATE_MENU,
    STATE_REPEAT,
    STATE_RATING,
    
} StateName;



@protocol State <NSObject>

- (void) play;
- (void) pause;
- (void) rating;
- (void) load;
- (void) menu;

@end

@class State;
@interface StateMachine : NSObject

    @property (retain) State *generalState;
    @property (retain) NSMutableDictionary *states;

    @property GameLayer *gameLayer;
    @property PauseLayer *pauseLayer;
    @property RepeatLayer *repeatLayer;

- (id) initWithState:(NSInteger) state;
- (void) addState:(State*)object name:(StateName) name ;
- (State*) state:(StateName) name;

@end

@interface State : NSObject <State>
@property StateMachine *machine;

- (id)initWithMachine:(StateMachine*) machine;

@end


@interface Game : State
@end

@interface Pause : State
@end

@interface Menu : State
@end

@interface Load: State
@end
