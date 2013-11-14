//
//  ASObject.m
//  OpenGLTest
//
//  Created by Наталья Дидковская on 16.09.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import "ASObject.h"
#import "ASMath.h"

@implementation ASContactListner

- (id)init
{
    self = [super init];
    if (self) {
        
        self.bodies = [NSMutableArray array];
        self.remove = NO;
        
    }
    return self;
}

- (void) collision {};
- (void) outsideTheWorld {};
- (void) update:(CFTimeInterval)dt {};



@end


@implementation ASCircle

@synthesize type = _type;
@synthesize center = _center;
@synthesize r = _r;

- (id)initWithRadius:(CGFloat) radius position:(CGPoint) position
{
    self = [super init];
    if (self) {
        
        _type = PS_CIRCLE;
        _center = position;
        _r = radius;
        
    }
    return self;
}
+ (ASCircle*) circleWithRadius:(CGFloat)radius position:(CGPoint)position {
    
    return [[ASCircle alloc] initWithRadius:radius position:position];
    
}

- (ASProjection*) projectOn:(ASVector *) axis {
    
    CGFloat dotProduct = [axis dotProduct: [ASVector x:_center.x y:_center.y]];
    
    return [ASProjection min:dotProduct - _r max:dotProduct + _r];
    
}

@end

@implementation ASPolygon

@synthesize angel = _angel;
@synthesize type = _type;
@synthesize center = _center;
@synthesize r = _r;

- (id)initWithPoints:(NSArray*) points position:(CGPoint) position
{
    self = [super init];
    if (self) {
        
        _type = PS_POLYGON;
        _startPoints = points;

        _points = [NSMutableArray array];
        for (AS3Point *point in points) {
            
            [_points addObject:[point copy]];
            
        }
        
        CGFloat rMax = 0;
        for (AS3Point *point in points) {
        
            
            CGFloat r = sqrtf(powf(point->x, 2) + powf(point->y, 2));
            
            if(r > rMax){
                
                rMax = r;
                
            }
            
        }
        _r = rMax;
        
        _center = position;
        _angel = 0;
        
        
        
    }
    return self;
}

+ (ASPolygon*) polygonWithPoints:(NSArray*) points position:(CGPoint) position
{
    return [[ASPolygon alloc] initWithPoints:points position:position];
}

- (void) reCalculate
{
    
    CGFloat angel = DegreesToRadians(_angel);
    
    CGFloat cosA = cosf(angel);
    CGFloat sinA = sinf(angel);
    
    CGFloat matrix[]= {
        
        cosA , -sinA , _center.x ,
        sinA , cosA , _center.y ,
        0    , 0    , 1  ,
        
    };
    
    AS3Point *worldPoint;
    NSEnumerator *worldPointEnum = [_points objectEnumerator];
    
    for (AS3Point *point in _startPoints) {
        
        worldPoint = [worldPointEnum nextObject];
        
        worldPoint->x = matrix[0] * point->x + matrix[1] * point->y + matrix[2];
        worldPoint->y = matrix[3] * point->x + matrix[4] * point->y + matrix[5];

        
    }
}


- (ASProjection*) projectOn:(ASVector *) axis {
    
    AS3Point *point = [_points objectAtIndex:0];
    CGFloat dotProduct = [axis dotProduct:[ASVector x:point->x y :point->y]];
    
    CGFloat min = dotProduct;
    CGFloat max = dotProduct;
    
    int count  = [_points count];
    
    for (int i = 1; i < count; i++) {
        
//        point = [[_worldPoints objectAtIndex:i] CGPointValue];
        point = [_points objectAtIndex:i];
        dotProduct = [axis dotProduct:[ASVector x:point->x y:point->y]];
        
        if (dotProduct < min) {
            
            min = dotProduct;
            
        } else if (dotProduct > max) {
            
            max = dotProduct;
            
        }
    }
    
    return [ASProjection min:min  max: max];
    
    
}
@end

@implementation ASBody


- (id)initWithData:(id) object
             shape:(id<ASWorldShape>) shape
{
    self = [super init];
    if (self) {
        
        _active = YES;
        self.object = object;
        self.shape = shape;
        
        
    }
    return self;
}

+ (ASBody*) bodyWithData:(id) object
                   shape:(id<ASWorldShape>) shape
{
    
    return [[ASBody alloc] initWithData:object shape:shape];
    
}

@end