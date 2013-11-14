//
//  ShapeAddition.m
//  OpenGLTest
//
//  Created by Наталья Дидковская on 29.08.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import "ASMath.h"


@implementation ASVector

- (id)initWithX:(CGFloat) X y:(CGFloat) Y z:(CGFloat) Z;
{
    self = [super init];
    if (self) {
        
        x = X;
        y = Y;
        z = Z;
        
    }
    return self;
}

+ (ASVector*) x:(CGFloat) x y:(CGFloat)y
{
    
    return [[ASVector alloc] initWithX:x y:y z:0];
    
}
+ (ASVector*) x:(CGFloat) x y:(CGFloat)y z:(CGFloat)z
{
    
    return [[ASVector alloc] initWithX:x y:y z:z];
    
}

- (CGFloat) dotProduct:(ASVector*) vector
{
    
    return x*vector->x + y*vector->y + z*vector->z;
    
}

- (void) normalize
{
    
    CGFloat l = sqrtf(powf(x, 2) + powf(y, 2));
    
    x = x/l;
    y = y/l;
    
}

- (ASVector*) plus:(ASVector *)vector {
    
    return [ASVector x: self->x + vector->x
                     y: self->y + vector->y];
    
}

- (ASVector*) minus:(ASVector *)vector {
    
    return [ASVector x: self->x - vector->x
                     y: self->y - vector->y];
    
}

- (CGFloat) lenght {
    
    return sqrtf(powf(x, 2) + powf(y, 2));
    
}

- (CGFloat) angel {
    
    CGFloat lenght = [self lenght];
    
    if(lenght == 0){
        
        return 0;
        
    }
    
    CGFloat cosA = x/lenght;
    CGFloat sinA = y/lenght;
    
    BOOL up = sinA > 0;
    
    CGFloat angel = acosf(cosA);
    
    if(up){
        
        return   RadiansToDegrees(angel);
        
    } else {
        
        return   (360 - RadiansToDegrees(angel));
        
    }
}

@end

@implementation ASProjection

- (id)initWithMin:(CGFloat) MIN max:(CGFloat) MAX
{
    self = [super init];
    if (self) {
        
        min = MIN;
        max = MAX;
        
    }
    return self;
}

+ (ASProjection*) min:(CGFloat) min max:(CGFloat) max
{
    return [[ASProjection alloc] initWithMin:min max:max];
}

- (BOOL) isOverlapWith:(ASProjection*) projection
{
    
    CGFloat interval = 0;
    
    if (projection->min < min) {
        interval = min - projection->max;
    } else {
        interval = projection->min - max;
    }
    
    if(interval > 0){
        
        return NO;
    }
    
    return YES;
}

@end

@implementation AS3Point

- (id) initWithX:(CGFloat) theX withY:(CGFloat) theY withZ:(CGFloat) theZ
    {
        self = [super init];
        
        if(self){
            
            x = theX;
            y = theY;
            z = theZ;
        
            
        }
        
        return self;
    }
    
- (id) copyWithZone:(NSZone *)zone {
    
    AS5Point *copy = [AS5Point x:x
                               y:y
                               z:z ];
    
    return copy;
    
}
    
+ (AS3Point*) x:(CGFloat) x y:(CGFloat) y z:(CGFloat)z
    {
        
        return [[AS3Point alloc] initWithX:x withY:y withZ:z] ;
        
    }
    
+ (AS3Point*) x:(CGFloat) x y:(CGFloat) y
    {
        
        return [[AS3Point alloc] initWithX:x withY:y withZ:0 ];
        
    }

@end

@implementation ASMatrix

- (id)initOrthoWithFrustumLeft: (GLfloat) left
                 andRight: (GLfloat) right
                andBottom: (GLfloat) bottom
                   andTop: (GLfloat) top
                  andNear: (GLfloat) near
                   andFar: (GLfloat) far
{
    self = [super init];
    if (self) {
        
        glMatrix[0]  = 2.0 / (right - left);
        glMatrix[1]  = 0.0;
        glMatrix[2]  = 0.0;
        glMatrix[3] = 0.0;
        
        glMatrix[4]  = 0.0;
        glMatrix[5]  = 2.0 / (top - bottom);
        glMatrix[6]  = 0.0;
        glMatrix[7] = 0.0;
        
        glMatrix[8]  = 0.0;
        glMatrix[9]  = 0.0;
        glMatrix[10]  = -2.0 / (far - near);
        glMatrix[11] = 0.0;
        
        glMatrix[12]  = -(right + left) / (right - left);
        glMatrix[13]  = -(top + bottom) / (top - bottom);
        glMatrix[14] = -(far + near) / (far - near);
        glMatrix[15] = 1.0;
        
    }
    return self;
}

+ (ASMatrix*) populateOrthoFromFrustumLeft: (GLfloat) left
                             andRight: (GLfloat) right
                            andBottom: (GLfloat) bottom
                               andTop: (GLfloat) top
                              andNear: (GLfloat) near
                               andFar: (GLfloat) far
{
                         
    return [[ASMatrix alloc] initOrthoWithFrustumLeft:left
                                        andRight:right
                                       andBottom:bottom
                                          andTop:top
                                         andNear:near
                                          andFar:far];

}

@end


@implementation AS5Point

- (id) initWithX:(CGFloat) theX withY:(CGFloat) theY withZ:(CGFloat) theZ withTX:(CGFloat) theTx withTY:(CGFloat) theTy
{
    self = [super init];
    
    if(self){
        
        x = theX;
        y = theY;
        z = theZ;
        
        tx = theTx;
        ty = theTy;
        
    }
    
    return self;
}

- (id) copyWithZone:(NSZone *)zone {
    
    AS5Point *copy = [AS5Point x:x
                               y:y
                               z:z
                              tx:tx
                              ty:ty];
    
    return copy;
    
}

+ (AS5Point*) x:(CGFloat) x y:(CGFloat) y z:(CGFloat)z tx:(CGFloat) tx ty:(CGFloat)ty
{
    
    return [[AS5Point alloc] initWithX:x withY:y withZ:z withTX:tx withTY:ty];
    
}

+ (AS5Point*) x:(CGFloat) x y:(CGFloat) y z:(CGFloat)z
{
    
    return [[AS5Point alloc] initWithX:x withY:y withZ:z withTX:0 withTY:0];
    
}
+ (AS5Point*) x:(CGFloat) x y:(CGFloat) y
{
    
    return [[AS5Point alloc] initWithX:x withY:y withZ:0 withTX:0 withTY:0];
    
}

@end

@implementation ASIndices

- (id)initWithFirst:(GLushort) theFirst withSecond:(GLushort) theSecond withThird:(GLushort) theThird
{
    self = [super init];
    if (self) {
        
        fisrt = theFirst;
        second = theSecond;
        third = theThird;
        
    }
    return self;
}

+(ASIndices*) first:(GLushort)first second:(GLushort)second third:(GLushort)third
{
    return [[ASIndices alloc] initWithFirst:first withSecond:second withThird:third];
}

@end

//
//ASIndices asi(GLshort first,GLshort second,GLshort third){
//    
//    ASIndices indices;
//    
//    indices.fisrt = first;
//    indices.second = second;
//    indices.third = third;
//    
//    return indices;
//}

CGPoint intersectionLine(CGFloat k1 ,CGFloat k2,CGFloat m1,CGFloat m2){
    
    CGFloat x = ((m2 - m1)/(k1 - k2));
    CGFloat y = k1*x + m1;
    
    //    NSLog(@"x: %f y: %f",x,y);
    
    return CGPointMake(x, y);
}

float randomFloat(float smallNumber, float bigNumber) {
    
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
    
}


NSMutableArray* genCirclePoints(CGFloat width,CGFloat height,int count,CGFloat *rMax){
    
    NSMutableArray *points = [NSMutableArray array];
    
    CGPoint center = CGPointMake(0,0);//width/2, height/2);
    CGFloat dA = 360.0f / count;
    CGFloat angel = 0;
    
    *rMax = 0;
    CGFloat r;
    CGFloat previousR = width/4;
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    CGFloat bottomRestriction = 0.0;
    CGFloat topRestriction = 0.0;
    
    CGFloat fl = (width/2) / 10;
    
//    AS3Point centerPoint = as3p(center.x, center.y,0);
    AS5Point *centerPoint = [AS5Point x:center.x y:center.y ];
//    [points addObject:[NSValue value:&centerPoint withObjCType:@encode(AS3Point)]];
    [points addObject:centerPoint];
    
    
    
    for (int i = 0 ; i < count; i++) {
        
        if (previousR - fl > 0) {
            bottomRestriction = previousR - fl;
        } else {
            bottomRestriction = 0;
        }
        
        if (previousR + fl < width/2) {
            topRestriction = previousR + fl;
        } else {
            topRestriction = width/2;
        }
        
        r = randomFloat(bottomRestriction, topRestriction);
        
        if(r > *rMax){
            
            *rMax = r;
            
        }
        
        x = r * cosf(angel * (3.14159265359f/180));// + width/2;
        y = r * sinf(angel * (3.14159265359f/180));// + height/2;
    
        previousR = r;
        
//        AS3Point point = as3p(x, y , 0);
//        [points addObject:[NSValue value:&point withObjCType:@encode(AS3Point)]];
        AS5Point *point = [AS5Point x:x y:y];
        [points addObject:point];
        
        angel += dA;
        
    }
    
    
    
    return points;
}
NSMutableArray* genPoints(CGFloat width,CGFloat height,int count){
    
    NSMutableArray *points = [NSMutableArray array];
    
    CGPoint center = CGPointMake(width/2, height/2);
    CGFloat dA = 360 / count;
    CGFloat angel = 0;
    CGFloat k;
    
    CGFloat x;
    CGFloat y;
    CGFloat m;
    
//    AS3Point centerPoint = as3p(center.x, center.y , 0);
//    
//    [points addObject:[NSValue value:&centerPoint withObjCType:@encode(AS3Point)]];
    AS5Point *centerPoint = [AS5Point x:center.x y:center.y];
    
    [points addObject:centerPoint];
    
    for (int i = 0 ; i < count; i++) {
        
        /* инициализируем прямую */
        k = tanf(angel * (3.14159265359f/180));
        m = center.y - k*center.x;
        
        /*
         
         
         
         
         
         
         */
        
        if(angel == 90){
            
            x = center.x;
            y = randomFloat(center.y, height);
            
        } else if(angel == 270){
            
            x = center.x;
            y = randomFloat(0, center.y);
            
        } else if(angel >= 45 && angel < 135) {
            
            /* пересечение с y = height */
            
            CGFloat intersectionX = (intersectionLine(k, 0, m, height)).x;
            
            if(center.x > intersectionX){
                x = randomFloat(intersectionX, center.x);
            } else {
                x = randomFloat(center.x, intersectionX);
            };
            
            y = k*x + m;
            
        } else if (angel >= 135 && angel < 225) {
            
            x = randomFloat(0, center.x);
            y = k*x + m;
            
        } else if (angel >= 225 && angel < 315){
            
            /*пересечение  с y = 0 */
            CGFloat intersectionX = (intersectionLine(k, 0, m, 0)).x;
            
            if(center.x > intersectionX){
                x = randomFloat(intersectionX, center.x);
            } else {
                x = randomFloat(center.x, intersectionX);
            };
            y = k*x + m;
            
        } else {
            
            x = randomFloat(center.x , width);
            y = k*x + m;
            
        }
        
        /* добавляем точку принадлежащую этой прямой */
        
//        AS3Point point = as3p(x, y, 0);
//        
//        [points addObject:[NSValue value:&point withObjCType:@encode(AS3Point)]];
        AS5Point *point = [AS5Point x:x y:y];
        
        [points addObject:point];
        
        
        angel += dA;
    }
    
//    NSLog(@"%@",[points description]);
//    NSLog(@"====================");
    
    return points;
    
}

NSArray* genIndices(NSArray *points){
    
    NSMutableArray *indices = [NSMutableArray array];
    
    for (int i = 1; i < [points count]; i++) {
        
        ASIndices *triangleOfindices;
        if(i == [points count] - 1){
            
            triangleOfindices = [ASIndices first:0 second:i third:1];//asi(0, i, 1);
            
        } else {
            
            triangleOfindices = [ASIndices first:0 second:i third:i+1];//asi(0, i, i + 1);
        }
        
//        [indices addObject:[NSValue value:&triangleOfindices withObjCType:@encode(ASIndices)]];
                [indices addObject:triangleOfindices];
        
    }
    
    return indices;
}