//
//  GameLayer.m
//  OpenGLTest
//
//  Created by Наталья Дидковская on 23.07.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import "GameLayer.h"
#import "Objects.h"
#import "ASButton.h"

#import "Constants.h"


@implementation GameLayer

- (id)init
{
    self = [super init];
    if (self) {
        
        score = 0;
        
        width = [[ASLayerManager layerManager] width];
        height = [[ASLayerManager layerManager] height];
        
        World *world = [World world];
        
        [world addGroup:askPLANE];
        [world addGroup:askASTEROIDS];
        [world addGroup:askROCKET];
        
        [world doCollisionFor:askPLANE and:askASTEROIDS];
        [world doCollisionFor:askROCKET and:askASTEROIDS];
        
        CGFloat worldRadius = sqrtf(powf(width, 2) + powf(height, 2));
        [world setBound:[ASCircle circleWithRadius:worldRadius position:CGPointMake(width/2 , height/2 )]];
        
        
        _pauseButton = [ASButton buttonWithImage: askPAUSE_BUTTON_IMAGE];
        _joystick = [Joystick joystick:askJOISTICK_TAP_IMAGE
                                      area:askJOISTICK_AREA_IMAGE];
        _attackButton = [ASButton buttonWithImage:askATTACK_BUTTON_IMAGE];
        
        
        CGPoint PAUSE_BUTTON_POSITION = CGPointMake(0 , 0);
        CGPoint JOYSTICK_POSITION = CGPointMake(40, height - _joystick.area.height - 40);
        CGPoint ATTACK_BUTTON_POSITION = CGPointMake(width - _joystick.area.width - 40 , height - _joystick.area.height - 40 );
        
        [_pauseButton setPosition:PAUSE_BUTTON_POSITION];
        [_joystick setPosition:JOYSTICK_POSITION];
        [_attackButton setPosition:ATTACK_BUTTON_POSITION];
    
        
         _plane = [[Plane alloc] initWithLayer:self
                                          velocity:150];
        
    
        [self addButton:_joystick];
        [self addButton:_attackButton];
        [self addButton:_pauseButton];
        
        _label = [TextLabel labelWithString:@"Score:" position:CGPointMake(150, 10)];
        
        [self addButton:_label];
        
        
        Pulsation *pulsation = [Pulsation actionWithStartRadius:0.45 finishRadius:0.55 alpha:0.8];
    
        [_attackButton.sprite doAction:pulsation];
        
        [_joystick.area setAnimation:[GradientCircle animationStartRadius:0.50 finishRadius:0.7 alpha:0.8]];
        [_joystick.joystick setAnimation:[GradientCircle animationStartRadius:0.50 finishRadius:0.7 alpha:0.8]];
        
        __block Plane *blockPlane = _plane;
        [_attackButton setBeganBlock:^(NSSet *touhes,UIEvent *event){
            
            [blockPlane attack];
            [pulsation pulsationToStartRadius:0.45 toFinishRadius:0.65 time:0.4 count:1];
            
        }];
    
        durationAsteroids = 0.3;
    
    }

    return self;
}



- (void) update:(CFTimeInterval)dt {
    
    [_plane move:_joystick.deviation direction:_joystick.direction];
    [_label setString:[NSString stringWithFormat:@"Score:%i",score]];
    
    dtAsteroids += dt;
    if(dtAsteroids > durationAsteroids){
        
        dtAsteroids = 0;
        CGFloat r = sqrtf( powf(height/2, 2) + powf(width/2, 2));
        
        CGFloat angel = randomFloat(0, 360);
        
        
        /* центр координат в центре экрана */
        CGPoint position = CGPointMake(r * cosf(DegreesToRadians(angel)) + width/2, r*sinf(DegreesToRadians(angel)) + height/2);
        CGPoint center = CGPointMake(width/2, height/2);
        
        CGFloat dx = center.x - position.x;
        CGFloat dy = center.y - position.y;
        
        CGFloat l = sqrtf(powf(dx, 2) + powf(dy, 2));
        
        CGFloat centerRadius = 150;
        CGFloat sector = 2 * RadiansToDegrees(asinf(centerRadius/l));
        
        CGFloat alpha = 180 + angel;
        
        CGFloat vectorAlpha = randomFloat(alpha - sector/2, alpha + sector/2);
        
        int type = arc4random() % 3;
        
        [Asteroid asteroidWithType:type
                             layer:self
                         direction:[ASVector x:cosf(DegreesToRadians(vectorAlpha))	
                                                    y:sinf(DegreesToRadians(vectorAlpha))]
                          position:position];
        
    }
    
    [super update:dt];
}

@end
