//
//  Shape.h
//  OpenGLTest
//
//  Created by Наталья Дидковская on 29.08.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASMath.h"

typedef enum {

    RANDOM_POLYGON = 0,
    SQUARE,
    

} SHAPE_TYPE;

@class ASImage;
@class CC3GLMatrix;

@interface ASShape : NSObject <NSCopying>

@property CGFloat r;
@property  CGPoint center;

@property (nonatomic) CGFloat angel;

@property CGFloat width;
@property CGFloat height;


@property  NSMutableArray *points;
@property  NSMutableArray *indixes;

- (CGPoint) position;
- (void) setPosition:(CGPoint) position;

- (void) applyImage:(ASImage*) image;

+ (ASShape*) shapeWithWidth:(CGFloat) width height:(CGFloat) height type:(int) type;

@end

