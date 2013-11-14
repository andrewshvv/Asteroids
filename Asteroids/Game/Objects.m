//
//  Objects.m
//  OpenGLTest
//
//  Created by Наталья Дидковская on 13.09.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import "Objects.h"

#import "GameLayer.h"

#import "ASLayer.h"
#import "ASAnimation.h"

#import "Constants.h"

@implementation Plane

- (id)initWithLayer:(GameLayer*) layer
                velocity:(CGFloat) velocity

{
    self = [super init];
    if (self) {
        _layer = layer;
    
        
        /* create plane */
        CGPoint beginPoint = CGPointMake(400, 300);
        _plane = [ASSprite spriteWithName:askPLANE_IMAGE center:beginPoint];
        
        CGFloat radius = 0.50;
        CGFloat sraduis = radius/2;
        CGFloat fraduis = 4*radius/5;
        
        ASTailSprite *firejet1 = [ASTailSprite tailSpriteWithSprite:[ASSprite  spriteWithName:askFIREJET_IMAGE center:beginPoint]
                                           startRadius:0.0
                                          finishRadius:0.7
                                                lenght:20
                                                 alpha:0.5];
        [_plane setAnimation:[GradientCircle animationStartRadius:sraduis finishRadius:fraduis alpha:1]];
        
        _cplane = [ASCompositeSprite compositeSpriteWithGeneralSprite:_plane];
        [_cplane addNode:firejet1 translationVector:[ASVector x:  _plane.width/6
                                                              y:  0 ]];
        [_layer addNode:_cplane];
    
        
        /* create HP bar */
        _hp = [ASSprite spriteWithName:askHP_IMAGE];
        [_hp setPosition:CGPointMake(150, 50)];
        _hpAnimation = [Degradation actionWithStartDegradation:0.95 finishDegradation:1.00];
        [_hp doAction:_hpAnimation];
        [_layer addNode:_hp];
        

        
        /* apply actions  */
        _moveAction = [DirectionMove actionWithVelocity:0 direction:[ASVector x:0 y:0]];
        _rotationAction = [DirectionRotation actionWithRotationVelocity:0];
        
        [_cplane doAction:_moveAction];
        [_cplane doAction:_rotationAction];

        
        _HP = 100;
        _velocity = 300;
        _armor = 100;
        
        
        /* create world body */
        CGFloat planeRadius = sqrtf(powf(_plane.shape.width/2, 2) + powf(_plane.shape.height/2, 2));
        
         _planeBody = [ASBody bodyWithData:_plane
                                    shape:[ASCircle circleWithRadius:planeRadius*fraduis
                                                            position:_plane.center]];
        
        [self.bodies addObject:_planeBody];
        
        [[World world] addObject:self inGroup:askPLANE];
        
    }
    return self;
}

- (void) collision {
    
    [self damage:5];
    
}
- (void) update:(CFTimeInterval)dt {
    
    [_planeBody.shape setCenter:_plane.shape.center];
    
}

- (void) alive {

    [_cplane setHidden:NO];
    [_planeBody setActive:YES];

    [_cplane setPosition:CGPointMake(400, 200)];
    [_hpAnimation degradationWithOffset: 1.0 time:1.0];

    _HP = 100;
    
    
}
- (void) damage:(int) damage {
    
    if(_HP - damage < 0){
        
        [_hpAnimation degradationWithOffset: -(CGFloat)_HP/100 time:0.5];
        _HP = 0;
        
        
        self.death();
        
        [_cplane setHidden:YES];
        [_planeBody setActive:NO];
        [_cplane setCenter:CGPointMake(400, 300)];
        _layer->score = 0;
        
        
        
    } else {
        
        _HP -= damage;
        [_hpAnimation degradationWithOffset: -(CGFloat)damage/100 time:0.5];
        
    }
    
}

- (void) move:(CGFloat) deviation  direction:(ASVector*) theDirection {
    
    [_moveAction setDirection: theDirection];
    [_moveAction setVelocity:  deviation * _velocity];
    
    dif =  _angel - _plane.angel;
    if([theDirection lenght] != 0){
        
        _angel = 180 + [theDirection angel];
        if(_angel > 360){
            _angel = _angel  - 360;
        }
    
        CGFloat velocity = 360;
        if(dif > 0){
            
            if(dif > 180){
                [_rotationAction setRotationVelocity: - velocity];
            } else {
                [_rotationAction setRotationVelocity:  velocity];
            }
            
        } else {
            if(dif < -180){
                [_rotationAction setRotationVelocity:  velocity];
            } else {
                [_rotationAction setRotationVelocity: - velocity];
            }
            
            prevDif  = dif;
        }
    }
    
    if(abs(dif) < 4){
        
        [_rotationAction setRotationVelocity:0];
        
        
    }
    
    prevDif = dif;
}


- (void) attack {

    CGFloat planeAngel = 180 + _angel;
    
    [FireBall fireBallWithDirection:[ASVector x:cosf(DegreesToRadians(planeAngel)) y:sinf(DegreesToRadians(planeAngel))]
                           velocity:600
                             center:_plane.center
                              layer:_layer];
    

}
@end



@implementation Asteroid

- (id)initWithSprite:(ASSprite*) sprite
                type:(int) type
               layer:(GameLayer*) layer
           direction:(ASVector*) direction
            position:(CGPoint) position
{
    self = [super init];
    if (self) {
        
        
        self.type = type;
        self.layer = layer;
        self.direction = direction;
        self.position = position;
        
        self.sprite = sprite;
        [_sprite setCenter:position];
        [_layer addNode:self.sprite];
        
        [_sprite doAction:[DirectionMove actionWithVelocity:180 direction:direction]];
        [_sprite doAction:[Rotation actionWithTime:20 angle:720]];
        
        
        NSMutableArray *points = [NSMutableArray array];
        AS5Point *point;
        
        int count = [sprite.shape.points count];
        for (int i = 1; i < count ; i++) {
            
            point = [sprite.shape.points objectAtIndex:i];
            [points addObject:[AS3Point x:point->x y:point->y]];
            
        }
        
        
        _asteroidBody = [ASBody bodyWithData:_sprite shape:[ASPolygon polygonWithPoints: points position:sprite.shape.center]];
        [self.bodies addObject:_asteroidBody];
                          
    }
    return self;
}

+ (Asteroid*) asteroidWithSprite:(ASSprite*) sprite
                           type:(int) type
                          layer:(GameLayer*) layer
                      direction:(ASVector*) direction
                       position:(CGPoint) position
{
    
    return [[Asteroid alloc] initWithSprite:sprite type:type layer:layer direction:direction position:position];
    
}

#pragma mark -
#pragma mark ASContactListner implementation

- (void) collision {
    
    if(self.type != ASTEROID_TYPE_SMALL){
        
        CGFloat leftX = _direction->x/2;
        CGFloat leftY = _direction->y;
        CGFloat rightX = _direction->x;
        CGFloat rightY = _direction->y/2;
        
        [Asteroid asteroidWithType:_type - 1
                             layer:_layer
                         direction:[ASVector x:leftX y:leftY]
                          position:_position];
        
        [Asteroid asteroidWithType:_type - 1
                             layer:_layer
                         direction:[ASVector x:rightX y:rightY]
                          position:_position];
        
    }
    
    [_layer removeNode:_sprite];
    self.remove = YES;
    
}

- (void) update:(CFTimeInterval) dt {
    
    _position = _sprite.shape.center;
    
    [_asteroidBody.shape setCenter:_sprite.center];
    [_asteroidBody.shape setAngel:_sprite.angel];
    
    [_asteroidBody.shape reCalculate];
    
}

- (void) outsideTheWorld {

    [_layer removeNode:_sprite];
    self.remove = YES;
    
}
#pragma mark -

+ (void) asteroidWithType:(int) type
                        layer:(GameLayer*) layer
                    direction:(ASVector*) direction
                     position:(CGPoint) position
{
    
    
    Asteroid *asteroid;
    
    switch (type) {
            
        case ASTEROID_TYPE_SMALL:
        {
            
            asteroid = [Asteroid asteroidWithSprite:[ASSprite spriteWithName:askSMALL_ASTEROID_IMAGE_BACKGROUND
                                                                shape:RANDOM_POLYGON]
                                        type:ASTEROID_TYPE_SMALL
                                       layer:layer
                                   direction:direction
                                    position:position];
            
            
        }
            break;
            
        case ASTEROID_TYPE_MIDDLE:
        {
           asteroid = [Asteroid asteroidWithSprite:[ASSprite spriteWithName:askMIDDLE_ASTEROID_IMAGE_BACKGROUND
                                                                              shape:RANDOM_POLYGON]
                                                      type:ASTEROID_TYPE_MIDDLE
                                                     layer:layer
                                                 direction:direction
                                                  position:position];

        }
            break;
            
        case ASTEROID_TYPE_LARGE:
        {
           asteroid = [Asteroid asteroidWithSprite:[ASSprite spriteWithName:askLARGE_ASTEROID_IMAGE_BACKGROUND
                                                                              shape:RANDOM_POLYGON]
                                                      type:ASTEROID_TYPE_LARGE
                                                     layer:layer
                                                 direction:direction
                                                  position:position];
        }
            break;
            
        default: {
            
            NSAssert(NO, @"Unknown asteroid type");
            
        }
            break;

    }
    
    [[World world] addObject:asteroid inGroup:askASTEROIDS];
    
    
}

@end

@implementation FireBall

- (id)initWithDirection:(ASVector*) direction velocity:(CGFloat) velocity center:(CGPoint) center layer:(ASLayer*) layer
{
    self = [super init];
    if (self) {
        
        _sprite = [ASSprite spriteWithName:askJOISTICK_TAP_IMAGE];
        _layer = (GameLayer*)layer;
        
        [_layer addNode:_sprite];
        
        [_sprite setCenter:center];
        [_sprite doAction:[DirectionMove actionWithVelocity:velocity direction:direction]];
        
        
        [_sprite setAnimation:[GradientCircle animationStartRadius:0.0 finishRadius:0.4 alpha:1.0]];
        
        _fireBallBody = [ASBody bodyWithData:_sprite shape:[ASCircle circleWithRadius:16 position:_sprite.position]];
        
        [self.bodies addObject:_fireBallBody];
        
        
        [[World world] addObject:self inGroup:askROCKET];
        
        
    }
    return self;
}

+ (FireBall*) fireBallWithDirection:(ASVector*) direction
                            velocity:(CGFloat) velocity
                            center:(CGPoint) center
                               layer:(ASLayer*) layer
{
    
    return [[FireBall alloc] initWithDirection:direction velocity:velocity center:center layer:layer];
    
}



- (void) update:(CFTimeInterval)dt {
    
    _position = _sprite.shape.center;
    [_fireBallBody.shape setCenter:_sprite.shape.center];
    
    
}
- (void) collision {

    [_layer removeNode:_sprite];
    _layer->score += 10;
    self.remove = YES;
    
}

- (void) outsideTheWorld {
    
    [_layer removeNode:_sprite];
    self.remove = YES;
    
}
@end