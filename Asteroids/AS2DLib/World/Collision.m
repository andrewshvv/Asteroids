
//  Collision.m
//  OpenGLTest
//
//  Created by Наталья Дидковская on 15.08.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import "Collision.h"
#import "ASObject.h"
#import "ASMath.h"

NSUInteger getQuarter(CGPoint polygonPoint,CGPoint hitPoint){
    
    return (polygonPoint.x > hitPoint.x) ? ( polygonPoint.y > hitPoint.y ? 3:2 ) : ( polygonPoint.y > hitPoint.y  ? 4:1);
    
}

BOOL clockwise(CGPoint previousPoint,CGPoint nextPoint,CGPoint hitPoint){
    
//    CGFloat x = (nextPoint.x - ( ((nextPoint.y - hitPoint.y )*(previousPoint.x - nextPoint.x))/(previousPoint.x - nextPoint.y) ));
    
    /*
        
        (X - Xo) / ( X1 - Xo) = (Y - Yo) / (Y1 - YO) - уравнение прямой по двум точкам
     
        Y = K*X + M
     
        K = (Y1 - Yo) / (X1 - Xo)
        M = (Yo*X1 - Y1*Xo) / (X1 - Xo)
     
        k1*k2 = -1 - перпендикулярные прямые
     */
    CGFloat xo = previousPoint.x;
    CGFloat yo = previousPoint.y;
    CGFloat x1 = nextPoint.x;
    CGFloat y1 = nextPoint.y;
    
    CGFloat k1,k2,m1,m2 = 0;
    
    m1 = (yo * x1 - y1 * xo) / (x1 - xo);
    k1 = (y1 - yo)/(x1 - xo);
    
    // далее на основе 1ого коэфициэнта прямой #1 и точки hitPoint
    // строим новую прямую перпендикулярной #1ой и ищем пересечение прямой #1 и #2
    // в данном случае нам необходимо только значение x точки пересечения
    
    k2 = -1 / k1;
    m2 = hitPoint.y - k2*hitPoint.x;
    
    CGFloat x = ((m2 - m1)/(k1 - k2));
//    CGFloat y = k1*x + m1;
    
    return (x > hitPoint.x) ? YES : NO;
    
}

BOOL hitPointTest(ASPolygon *polygon,CGPoint hitPoint)
{
    
    /* получаем экранный точки объекта */
    
    CGPoint previousPoint , nextPoint;
    
    NSUInteger previousQuarter = 0;
    NSUInteger nextQuarter = 0;
    int delta = 0;
    int counter = 0;
    
    
    //    previousPoint = [[points objectAtIndex:0] CGPointValue];
    
    /* получаем крайнюю правую точку */
    previousPoint = [[polygon.points objectAtIndex:0] CGPointValue];
    
    /* четверть крайней правой точки относительно hitPoint */
    previousQuarter = getQuarter(previousPoint, hitPoint);
    
    //    NSLog(@"point {%f , %f} quarter: %i",previousPoint.x,previousPoint.y,previousQuarter);
    
    for (int i = 1; i <= [polygon.points count] ; i++) {
        
        if(i == [polygon.points count]){
            nextPoint = [[polygon.points objectAtIndex:0] CGPointValue];
        } else {
            nextPoint = [[polygon.points objectAtIndex:i] CGPointValue];
        }
        
        nextQuarter = getQuarter(nextPoint, hitPoint);
        
        //        NSLog(@"number:%i point {%f , %f} quarter: %i",i,nextPoint.x,nextPoint.y,nextQuarter);
        
        delta = nextQuarter - previousQuarter;
        
        
        switch (delta) {
                
            case -2:
            case  2: {
                if(!clockwise(previousPoint, nextPoint, hitPoint)){
                    
                    delta = -delta;
                    
                }
            }
                break;
                
                
            case -3: {
                delta = 1;
            }
                break;
                
                
            case 3: {
                delta = -1;
            }
                break;
        }
        
        counter += delta;
        
        previousQuarter = nextQuarter;
        previousPoint = nextPoint;
        
    }
    
    //    NSLog(@"return: %i",(counter == 4 || counter == -4) ? YES : NO);
    //    NSLog(@"===================");
    return (counter == 4 || counter == -4) ? YES : NO;
    
}

BOOL polygonWithPolygon(ASPolygon *polygonOne , ASPolygon *polygonTwo){
    
    CGFloat dx = polygonOne.center.x - polygonTwo.center.x;
    CGFloat dy = polygonOne.center.y - polygonTwo.center.y;
    
    CGFloat d = sqrtf(powf(dx,2) + powf(dy, 2));
    
    if( (polygonOne.r + polygonTwo.r) < d ){
        
        return NO;
        
    }
    
    /* Create Axis Array */
    
    NSMutableArray *axis = [NSMutableArray array];
    NSArray *points = polygonOne.points;

    CGFloat A;
    CGFloat B;
    
    AS3Point *point = [points objectAtIndex:0];
    AS3Point *nextPoint;
    
    int count = [points count];
    for (int i = 1; i <= count; i++) {
        
        nextPoint = i == count ? [points objectAtIndex:0]:[points objectAtIndex:i];
        
        B = point->x - nextPoint->x;
        A = point->y - nextPoint->y;
        
        [axis addObject:[ASVector x: -B y: A]];
        
        point = nextPoint;
        
    }
    
    points = polygonTwo.points;
    
    point = [points objectAtIndex:0];

    
    count = [points count];
    for (int i = 1; i <= count; i++) {
        
        nextPoint = i == count ? [points objectAtIndex:0]:[points objectAtIndex:i];
        
        B = point->x - nextPoint->x;
        A = point->y - nextPoint->y;
        
        [axis addObject:[ASVector x: -B y: A]];
        
        point = nextPoint;
        
    }
    
    /* Collision Detection */
    
    
    ASProjection *firstProjection;
    ASProjection *secondProjection;
    
    for (ASVector *axisVector in axis) {
        
        [axisVector normalize];
        
        firstProjection = [polygonOne projectOn:axisVector];
        secondProjection = [polygonTwo projectOn:axisVector];
        
        if(![firstProjection isOverlapWith:secondProjection]){
            
            return NO;
            
        }
    }
    
    return YES;
    
}

BOOL circleWithPolygon(id objectOne, id objectTwo){
    
    ASCircle *circle;
    ASPolygon *polygon;
    
    if([objectOne isKindOfClass:[ASCircle class]]){
        
        circle = objectOne;
        polygon = objectTwo;
        
    } else {
        
        circle = objectTwo;
        polygon = objectOne;
        
    }
    
    CGFloat dx = polygon.center.x - circle.center.x;
    CGFloat dy = polygon.center.y - circle.center.y;
    
    CGFloat d = sqrtf(powf(dx,2) + powf(dy, 2));
    
    if( (polygon.r + circle.r) < d ){
        
        return NO;
        
    }
    
    /* Create Axis Array */
    
    NSMutableArray *axis = [NSMutableArray array];
    NSArray *points = polygon.points;
    
    CGFloat A;
    CGFloat B;
    
    CGPoint circleCenter = circle.center;
    
    for (AS3Point *point in points) {
        
        B = point->x - circleCenter.x;
        A = point->y - circleCenter.y;
        
        [axis addObject:[ASVector x:A y:B]];
        
    }
    
    AS3Point *point = [points objectAtIndex:0];
    AS3Point *nextPoint;
    
    int count = [points count];
    for (int i = 1; i <= count; i++) {
        
        nextPoint = i == count ? [points objectAtIndex:0]:[points objectAtIndex:i];
        
        B = point->x - nextPoint->x;
        A = point->y - nextPoint->y;
        
        [axis addObject:[ASVector x: -B y: A]];
        
        point = nextPoint;
        
    }
    
    ASProjection *firstProjection;
    ASProjection *secondProjection;
    
    for (ASVector *axisVector in axis) {
        
        [axisVector normalize];
        
        firstProjection = [polygon projectOn:axisVector];
        secondProjection = [circle projectOn:axisVector];
        
        if(![firstProjection isOverlapWith:secondProjection]){
            
            return NO;
            
        }
    }
    
    return YES;

    
}

BOOL circleWithCircle(ASCircle *circleOne,ASCircle *circleTwo){
    
    CGFloat dx = circleOne.center.x - circleTwo.center.x;
    CGFloat dy = circleOne.center.y - circleTwo.center.y;
    
    CGFloat d = sqrtf(powf(dx, 2) + powf(dy, 2));
    
    if(d < (circleOne.r + circleTwo.r)){
        
        return YES;
        
    }
    
    return NO;
    
}

ShapeHandleMethod getHandleMethod(int typeOne ,int typeTwo,NSDictionary *methods) {
    
    NSDictionary *shape = [methods objectForKey:[NSNumber numberWithInteger:typeOne]];
    NSValue *pointer = [shape objectForKey:[NSNumber numberWithInteger:typeTwo]];
    
    return [pointer pointerValue];
    
}



BOOL handleCollision(ASContactListner *firstObject,ASContactListner *secondObject,NSDictionary *methods){
    
    for (ASBody *firstBody in firstObject.bodies) {
        
        if(!firstBody.isActive){ continue ; }
        for (ASBody *secondBody in secondObject.bodies) {
            
            
                if(!secondBody.isActive){ continue ; }
                ShapeHandleMethod method = getHandleMethod(firstBody.shape.type, secondBody.shape.type ,methods);
                
                if( method(firstBody.shape,secondBody.shape) ){
                    
                    [firstObject collision];
                    [secondObject collision];
                    
                    return YES;
                }
            }
        }
    
    return NO;
    
}
