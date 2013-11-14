//
//  ShapeAddition.h
//  OpenGLTest
//
//  Created by Наталья Дидковская on 29.08.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import <Foundation/Foundation.h>

#define radian(x) x * (3.14/180)

#define DegreesToRadiansFactor  0.017453292519943f			// PI / 180
#define RadiansToDegreesFactor  57.29577951308232f			// 180 / PI
#define DegreesToRadians(D) ((D) * DegreesToRadiansFactor)
#define RadiansToDegrees(R) ((R) * RadiansToDegreesFactor)


@interface ASProjection : NSObject {
    
@public
    
    CGFloat min;
    CGFloat max;
    
}

+ (ASProjection*) min:(CGFloat) min max:(CGFloat) max;

- (BOOL) isOverlapWith:(ASProjection*) projection;


@end

@interface ASVector : NSObject {
    
@public
    
    CGFloat x;
    CGFloat y;
    CGFloat z;
    
}

+ (ASVector*) x:(CGFloat) x y:(CGFloat)y;
+ (ASVector*) x:(CGFloat) x y:(CGFloat)y z:(CGFloat)z;

- (ASVector*) minus:(ASVector*) vector ;
- (ASVector*) plus:(ASVector*) vector;
- (CGFloat) dotProduct:(ASVector*) vector;
//- (ASVector*) normal;
- (CGFloat) angel;
- (void) normalize;
- (CGFloat) lenght;

@end

@interface ASMatrix : NSObject {
    
    @public
    
    CGFloat glMatrix[16];
    
}

+ (ASMatrix*) populateOrthoFromFrustumLeft: (GLfloat) left
                             andRight: (GLfloat) right
                            andBottom: (GLfloat) bottom
                               andTop: (GLfloat) top
                              andNear: (GLfloat) near
                               andFar: (GLfloat) far;

@end


@interface AS3Point : NSObject <NSCopying> {
    
    @public
    
    CGFloat x;
    CGFloat y;
    CGFloat z;
    
}
    
+ (AS3Point*) x:(CGFloat) x y:(CGFloat) y z:(CGFloat)z ;
+ (AS3Point*) x:(CGFloat) x y:(CGFloat) y;
    
@end

@interface AS5Point : NSObject <NSCopying> {
    
    @public
    
    CGFloat x;
    CGFloat y;
    CGFloat z;
    
    CGFloat tx;
    CGFloat ty;
    
}

+ (AS5Point*) x:(CGFloat) x y:(CGFloat) y z:(CGFloat)z tx:(CGFloat) tx ty:(CGFloat)ty;
+ (AS5Point*) x:(CGFloat) x y:(CGFloat) y z:(CGFloat)z ;
+ (AS5Point*) x:(CGFloat) x y:(CGFloat) y;

@end

//typedef struct {
//    
//    GLushort fisrt;
//    GLushort second;
//    GLushort third;
//    
//} ASIndices;

@interface ASIndices : NSObject {
    
    @public
    
    GLushort fisrt;
    GLushort second;
    GLushort third;
    
}

+(ASIndices*) first:(GLushort)first second:(GLushort)second third:(GLushort)third;

@end

//ASIndices asi(GLshort first,GLshort second,GLshort third);
//AS3Point as3p(CGFloat x,CGFloat y,CGFloat z);


CGPoint intersectionLine(CGFloat k1 ,CGFloat k2,CGFloat m1,CGFloat m2);
float randomFloat(float smallNumber, float bigNumber) ;
NSMutableArray* genCirclePoints(CGFloat width,CGFloat height,int count,CGFloat *r);
NSMutableArray* genPoints(CGFloat width,CGFloat height,int count);
NSArray* genIndices(NSArray *points);