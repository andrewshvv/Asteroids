//
//  Shape.m
//  OpenGLTest
//
//  Created by Наталья Дидковская on 29.08.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import "ASShape.h"
#import "ASTextureManager.h"

@interface RandomPolygon : ASShape {
    
    int _count;
    
}

+ (RandomPolygon*) randomPolygonWithWidth:(CGFloat) width height:(CGFloat) height count:(int) count;


@end

@interface Square : ASShape

+ (Square*) squareWithWidth:(CGFloat) width height:(CGFloat) height;

@end

@implementation ASShape

@synthesize angel = _angel;

@synthesize height = _height;
@synthesize width = _width;

@synthesize indixes = _indixes;
@synthesize points = _points;


- (id) copyWithZone:(NSZone *)zone {
    
    ASShape *shape = [[ASShape allocWithZone:zone] init];
    
    NSMutableArray *points = [NSMutableArray array];
    for (AS5Point *point in self.points) {
        
        [points addObject:[point copy]];
        
    }
    
    shape.points = points;
    
    shape.indixes = [self.indixes mutableCopy];
    
    shape.height = self.height;
    shape.width = self.width;
    
    shape.angel = self.angel;
    shape.position = self.position;
    
    return shape;
    
}

- (id)init
{
    self = [super init];
    if (self) {
        
        _points = [NSMutableArray array];
        _indixes = [NSMutableArray array];
        
        _center = CGPointMake(_width/2, _height/2);
    
    }
    return self;
}

- (void) setPosition:(CGPoint) position {
    
    _center = CGPointMake(position.x + _width/2, position.y + _height/2);
    
}

- (CGPoint) position {
    
    return CGPointMake(_center.x - _width/2, _center.y - _height/2);
    
}
- (void) applyImage:(ASImage *)image
{
    
    CGFloat textureWidth = image.texture->width;
    CGFloat textureHeight = image.texture->height;
    
    CGFloat textureOffsetX = image.texture.quad.tl.x;
    CGFloat textureOffsetY = image.texture.quad.tl.y;
    
    int count = [self.points count];
    for (int i = 0; i < count; i++) {

        AS5Point *point = [self.points objectAtIndex:i];

        /*0.5 так как 
         
            +-------+
            |       |
            |   +---|----> x
            |   |   |
            +-------+
                |
                v y
         
            (point->x + self.width/2)/self.width;
         
         */
        if(image.texture.inverted == YES){
            
            point->tx = textureOffsetX - textureWidth * (0.5 + point->x/self.width);
            
        } else {
            
            point->tx = textureOffsetX + textureWidth * (0.5 + point->x/self.width);
            
        }
        
        point->ty = textureOffsetY + textureHeight * (0.5 + point->y/self.height);

        
    }
}


+ (ASShape*) shapeWithWidth:(CGFloat)width height:(CGFloat)height type:(int)type {
    
    switch (type) {
            
        case RANDOM_POLYGON:
        {
            return [RandomPolygon randomPolygonWithWidth:width height:height count:15];
        }
            break;
            
        case SQUARE:
        {
            return [Square squareWithWidth:width height:height];
        }
            break;
            
        default:
            
            NSAssert(NO, @"Unknown type for shape");
            
            break;
    }
    
    return nil;
}



@end


@implementation RandomPolygon 


- (id)initWidth:(CGFloat) width height:(CGFloat) height count:(int) count
{
    self = [super init];
    if (self) {
        
        self.width = width;
        self.height = height;
        
        if(count > 2){
            
            CGFloat r;
            self.points = genCirclePoints(width, height, count,&r);//genPoints(width, height, count);
            self.r = r;
            self.indixes = (NSMutableArray*)genIndices(self.points);

            
        } else {
            
            NSLog(@" count must be > 2");
        }
        
        
    }
    return self;
}

+ (RandomPolygon*) randomPolygonWithWidth:(CGFloat)width height:(CGFloat)height count:(int)count
{
 
    return [[RandomPolygon alloc] initWidth:width height:height count:count];
    
}


@end

@implementation Square

- (id)initWithWidth:(CGFloat)width height:(CGFloat)height
{
    self = [super init];
    if (self) {
        
        self.width = width;
        self.height = height;
        
        /*
         
       (0,0) -----------> x
         | tl           tr
         |
         |
         |
         v bl           br
         
         y
         */
 
        AS5Point *bl = [AS5Point x:-width/2 y:height/2 ];
        AS5Point *br = [AS5Point x:width/2 y:height/2 ];
        AS5Point *tr = [AS5Point x:width/2 y:-height/2 ];
        AS5Point *tl = [AS5Point x:-width/2 y:-height/2 ];

        
        [self.points addObject:bl];
        [self.points addObject:br];
        [self.points addObject:tr];
        [self.points addObject:tl];
        
        ASIndices *firstTriangle = [ASIndices first:0 second:1 third:2];//asi(0, 1, 2);
        ASIndices *secondTriangle = [ASIndices first:2 second:0 third:3];//asi(2, 0, 3);
        
        [self.indixes addObject:firstTriangle];
        [self.indixes addObject:secondTriangle];
        
        self.r = sqrtf( powf(width - self.position.x, 2) + powf(height - self.position.y, 2) );
        
    }
    return self;
}

+ (Square*) squareWithWidth:(CGFloat)width height:(CGFloat)height
{
    
    return [[Square alloc] initWithWidth:width height:height];
}



@end
