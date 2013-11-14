
//  ASObject.h
//  OpenGLTest
//
//  Created by Наталья Дидковская on 16.09.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ASProjection;
@class ASVector;

@interface ASContactListner : NSObject

@property BOOL remove;
@property NSMutableArray *bodies;

- (void) collision;
- (void) outsideTheWorld;
- (void) update:(CFTimeInterval) dt;

@end

typedef enum {
  
    PS_CIRCLE = 0,
    PS_POLYGON,
    
} PHYSIC_SHAPE_TYPE ;

@protocol ASWorldShape <NSObject>

@optional

@property int type;
@property CGPoint center;
@property CGFloat angel;
@property CGFloat r;

- (ASProjection*) projectOn:(ASVector*) axis;
- (void) reCalculate;

@end

@interface ASCircle : NSObject <ASWorldShape>

+ (ASCircle*) circleWithRadius:(CGFloat) radius position:(CGPoint) position;


@end

@interface ASPolygon : NSObject <ASWorldShape> {

    NSArray *_startPoints;

}
    
@property NSMutableArray *points;
@property CGFloat angel;

- (NSArray*) points;


+ (ASPolygon*) polygonWithPoints:(NSArray*) points position:(CGPoint) position;

@end

@interface ASBody : NSObject 

@property (getter = isActive) BOOL active;
@property __weak id object;
@property id<ASWorldShape> shape;

+ (ASBody*) bodyWithData:(id) object
                   shape:(id<ASWorldShape>) shape;


@end
