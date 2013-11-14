//
//  Action.h
//  OpenGLTest
//
//  Created by Наталья Дидковская on 15.07.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "IntMapTable.h"

#import "ASMath.h"

@class ASAnimation;
@class ASImage;

typedef void (^FinishBlock)(void);


typedef enum {
    
    RIGHT = 0,
    LEFT,
    
} DEGRADATION_DIRECTION;

@class ASSprite;

    
typedef enum {
    
    MOVE = 0,
    ROTATION,
    FRAME,
    DIRECTION_MOVE,
    TAIL,
    PULSATION,
    DEGRADATION,
    ALL
    
} ACTION_TYPE;

#pragma mark -
#pragma mark Action
@interface ASAction : NSObject <NSCopying>

@property (getter = isPaused) BOOL  pause;
@property (getter = isFinished) BOOL finish;
@property (getter = isRemoved) BOOL remove;
    
@property int type;
@property (nonatomic,copy) FinishBlock finishBlock;

- (void) start:(NSObject*) target;
- (void) finish:(NSObject*) target;
- (BOOL) valid:(NSObject*) target;

- (void) actionWithTarget:(NSObject*) sprite interval:(CFTimeInterval) interval;

@end

#pragma mark -
#pragma mark Move

@interface Move : ASAction 

+(Move*) actionWithTime:(CFTimeInterval) time position:(CGPoint) point finishBlock:(FinishBlock) finishBlock;
+(Move*) actionWithTime:(CFTimeInterval) time position:(CGPoint) point;

@end

#pragma mark -
#pragma mark DirectionMove

@interface DirectionMove : ASAction

@property  (nonatomic) CGFloat velocity;
@property  ASVector *direction;

- (void) setVelocity:(CGFloat) velocity;
+ (DirectionMove*) actionWithVelocity:(CGFloat) velocity direction:(ASVector*) direction;

@end


#pragma mark -
#pragma mark Frame


@interface Frame : ASAction 

+ (Frame*) actionWithTime:(CFTimeInterval)time
               withFrames:(NSArray *)framesNames
                     loop:(BOOL) shouldLoop
                 inverted:(BOOL) shouldInverted;

+ (Frame*) actionWithTime:(CFTimeInterval)time
               withFrames:(NSArray *)framesNames
                     loop:(BOOL) shouldLoop
                 inverted:(BOOL) shouldInverted
              finishBlock: (FinishBlock) block;

@end

#pragma mark -
#pragma mark Rotation

@interface Rotation : ASAction 

+(Rotation*) actionWithTime:(CFTimeInterval)time angle:(CGFloat) angle ;

@end


#pragma mark -
#pragma mark DirectionRotation

@interface DirectionRotation : ASAction

+(DirectionRotation*) actionWithRotationVelocity:(CGFloat) wA;

- (void) setRotationVelocity:(CGFloat) wA;

@end





#pragma mark -
#pragma mark Degradation

@interface Degradation : ASAction

+ (Degradation*) actionWithStartDegradation:(CGFloat)startDegradation
                      finishDegradation:(CGFloat)finishDegradation;

+ (Degradation*) actionWithTime:(CFTimeInterval)time
               startDegradation:(CGFloat)startDegradation
              finishDegradation:(CGFloat)finishDegradation
                         offset:(CGFloat) offset;

- (void) degradationWithOffset:(CGFloat)offset time:(CFTimeInterval) time;


@end

typedef enum {
  
    EXPANSION = 0,
    CONSTRACTION,
    
} STATE;

#pragma mark -
#pragma mark Pulsation

@class GradientCircle;
@interface Pulsation : ASAction 

+ (Pulsation*) actionWithInterval:(CFTimeInterval) time
                  fromStartRadius:(CGFloat) fromStartRadius
                    toStartRadius:(CGFloat) toStartRadius
                 fromFinishRadius:(CGFloat) fromFinishRadius
                   toFinishRadius:(CGFloat) toFinishRadius
                            alpha:(CGFloat) alpha
                            count:(int)count;

+ (Pulsation*) actionWithStartRadius:(CGFloat)startRadius
                        finishRadius:(CGFloat)finishRadius
                               alpha:(CGFloat)alpha;

- (void) pulsationToStartRadius:(CGFloat) toStartRadius
                 toFinishRadius:(CGFloat) toFinishRadius
                           time:(CFTimeInterval) time
                          count:(int) count;

@end
