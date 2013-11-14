//
//  Animation.h
//  OpenGLTest
//
//  Created by Наталья Дидковская on 27.07.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark -
#pragma mark ASAnimation

/* ASAnimation is a wrapper around ASSprite, which creates and maintains the necessary data to OpenGL */

@class ASSprite;
@class ASProgram;
@interface ASAnimation : NSObject <NSCopying> {
    
    @public
    
    /* type of animation */
    int type;
    int pointCount;

    int indixesCount;
    
    /* stride in bytes */
    int stride;
    
    /* opengl data */
    CGFloat *data;
    
}

@property ASProgram *program;
@property __weak ASSprite *sprite;
@property NSArray *indixes;

/* each animations has the attributes that it receives from the program */
@property NSDictionary *attributs;
@property NSArray *attributesValue;


/* update data */
- (void) update;

- (void) wrap:(ASSprite*) sprite;

@end


#pragma mark -
#pragma mark NoneAnimation
@interface NoneAnimation : ASAnimation
@end

@class ASImage;

typedef struct {
 
    CGFloat data[2];
    
} sCenterVector;


#pragma mark -
#pragma mark GradientCircle
@interface GradientCircle : ASAnimation {
    
    sCenterVector _centerVector;
    CGFloat _textureRadius;
    CGFloat _k;
    CGFloat _textureStartRadius;
    CGFloat _textureFinishRadius;
    
    @public
    CGFloat alpha;
    CGFloat startRadius ;
    CGFloat finishRadius ;
    
    
}



+ (GradientCircle*) animationStartRadius:(float) theSRadius
                            finishRadius:(float) theFRadius
                                   alpha:(float) theAlpha;


@end


#pragma mark -
#pragma mark CragientLinear
@interface GradientLinear : ASAnimation {
 
    CGFloat _textureStartDegradation;
    CGFloat _textureFinishDegradation;
    CGFloat _textureWidth;
    
    @public
    
    CGFloat startDegradation;
    CGFloat finishDegradation;
    
}




+ (GradientLinear*) animationWithStartDegradation:(CGFloat)startDegradation
                                      finishDegradation:(CGFloat)finishDegradation;


@end
