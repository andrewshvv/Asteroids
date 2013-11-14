//
//  GameLayer.h
//  OpenGLTest
//
//  Created by Наталья Дидковская on 23.07.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import "ASLayer.h"
#import "Objects.h"

@interface GameLayer : ASLayer {
    
    @public
    
    CGFloat width;
    CGFloat height;
    
    CFTimeInterval durationAsteroids;
    CFTimeInterval dtAsteroids;
    
    BOOL createAsteroids;
    
    int score;
    
}



@property ASButton *pauseButton;
@property Joystick *joystick;
@property ASButton *attackButton;

@property TextLabel *label;
@property  Plane *plane;


@end
