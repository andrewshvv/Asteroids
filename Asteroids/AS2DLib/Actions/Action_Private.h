//
//  Action_ActionPrivate.h
//  OpenGLTest
//
//  Created by Наталья Дидковская on 03.09.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import "ASAction.h"

@interface Move ()

@property CGFloat time;
@property CGFloat vX;
@property CGFloat vY;
@property CGPoint point;

@end


@interface DirectionMove ()

@property CGFloat time;

@property CGFloat vX;
@property CGFloat vY;

@end

@interface Frame ()

@property BOOL shouldInverted;

@property BOOL loop;
@property NSMutableArray *frames;
@property ASImage *beginImage;

@property CFTimeInterval allInterval;
@property CFTimeInterval dt;

@property NSEnumerator *textureEnumerator;

@end


@interface Rotation ()

@property CGFloat time;
@property CGFloat wA;

@property CGFloat angle;

@end

@interface DirectionRotation ()

@property CGFloat time;
@property CGFloat wA;

@property CGFloat angle;

@end

@class GradientLinear;
@interface Degradation () {
    
    GradientLinear *_gl;
    
    @public
    
     CFTimeInterval interval;
     CGFloat velocity;
    
     CGFloat startDegradation;
     CGFloat finishDegradation;
     CGFloat offset;
     CFTimeInterval time;
     CGFloat passed;
    
}

@end


@interface Pulsation ()

@property GradientCircle *gc;

@property STATE state;

@property CFTimeInterval time;
@property CFTimeInterval countTime;
@property CFTimeInterval interval;

@property CGFloat startRadiusVelocity;
@property CGFloat finishRadiusVelocity;

@property int count;
@property int passedPulsation;

@property CGFloat alpha;

@property CGFloat fromStartRadius;
@property CGFloat toStartRadius;
@property CGFloat fromFinishRadius;
@property CGFloat toFinishRadius;

@end