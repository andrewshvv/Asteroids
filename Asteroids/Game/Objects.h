//
//  Objects.h
//  OpenGLTest
//
//  Created by Наталья Дидковская on 13.09.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASSprite.h"
#import "ASObject.h"
#import "ASButton.h"

@class GameLayer;
@class Frame;
@class Degradation;

@interface Plane : ASContactListner {
    
    CGFloat prevDif;
    CGFloat dif;
    
    GameLayer *_layer;
    
    CGPoint _position;
    
    ASCompositeSprite *_cplane;
    ASSprite *_plane;
    ASBody *_planeBody;
    
    ASSprite *_hp;
    Degradation *_hpAnimation;
    
    int _HP;
    int _armor;
    
    DirectionMove *_moveAction;
    DirectionRotation *_rotationAction;
    
    CGFloat _velocity;
    CGFloat _angel;
    
}

@property (copy) void (^death)(void);

- (id)initWithLayer:(GameLayer*) layer
           velocity:(CGFloat) velocity;

- (void) alive;
- (void) move:(CGFloat) joystickDeviation  direction:(ASVector*) direction;
- (void) attack;
- (void) damage:(int) damage;

@end


@class GameLayer;
typedef enum {
    
    ASTEROID_TYPE_SMALL = 0,
    ASTEROID_TYPE_MIDDLE ,
    ASTEROID_TYPE_LARGE,
    
    
} ASTEROID_TYPE;

@interface Asteroid : ASContactListner

@property GameLayer *layer;

@property DirectionMove *move;
@property Frame *explosion;

@property ASSprite* sprite;

@property ASBody *asteroidBody;

@property CGPoint position;
@property ASVector *direction;
@property int type;

+ (Asteroid*) asteroidWithSprite:(ASSprite*) sprite
                            type:(int) type
                           layer:(GameLayer*) layer
                       direction:(ASVector*) direction
                        position:(CGPoint) position;


+ (void) asteroidWithType:(int) type
                        layer:(GameLayer*) layer
                    direction:(ASVector*) direction
                     position:(CGPoint) position;
- (void) death;

@end

@interface FireBall : ASContactListner {
    
    GameLayer* _layer;
    
}

@property CGPoint position;
@property ASSprite *sprite;
@property ASBody *fireBallBody;

+ (FireBall*) fireBallWithDirection:(ASVector*) direction
                            velocity:(CGFloat) velocity
                            center:(CGPoint) position
                               layer:(GameLayer*) layer;

@end

