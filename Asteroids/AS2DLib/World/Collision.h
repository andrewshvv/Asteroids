//
//  Collision.h
//  OpenGLTest
//
//  Created by Наталья Дидковская on 15.08.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CM_CC = 0, //circle - circle
    CM_CP    , //circle - polygon
    CM_PP    , //polygon - polygon
    
} COLLISION_METHOD_TYPE ;


// ===================================================
//   METHOD NAME:  getQuarter
// ===================================================

/*
 + ---------------- + ------------------------------
 |                  |Определение четверти в которой
 |   Purpose:       |находится точка polygonPoint
 |                  |относительно hitPoint
 + ---------------- + ------------------------------
 |                  |polygonPoint - точка многоуго-
 |   Inputs:        |льника
 |                  |hitPoint - проверяемая точка
 + ---------------- + ------------------------------
 |                  |Четверть -> {1,2,3,4};
 |   Output:        |
 |                  |
 + ---------------- + ------------------------------ */

NSUInteger getQuarter(CGPoint polygonPoint,CGPoint hitPoint);

// ===================================================
//   METHOD NAME:  clockwise
// ===================================================

/*
 + ---------------- + ------------------------------
 |                  |определение по какому направлению
 |   Purpose:       |произошло изменение четверти
 |                  |
 + ---------------- + ------------------------------
 |                  |previousPoint - предыдущая точка
 |   Inputs:        |nextPoint - следующая точка
 |                  |hitPoint - центр
 + ---------------- + ------------------------------
 |                  |YES - по часовой
 |   Output:        |
 |                  |
 + ---------------- + ------------------------------ */
BOOL clockwise(CGPoint previousPoint,CGPoint nextPoint,CGPoint hitPoint);

// ===================================================
//   METHOD NAME:  hitPoint
// ===================================================

/*
 + ---------------- + ------------------------------
 |                  |Вхождение точки в область мно-
 |   Purpose:       |гоугольника
 |                  |
 + ---------------- + ------------------------------
 |                  |Shape - форма
 |   Inputs:        |hitPoint - проверяемая точка
 |                  |
 + ---------------- + ------------------------------
 |                  |YES - входит
 |   Output:        |
 |                  |
 + ---------------- + ------------------------------ */

@class ASPolygon;
BOOL hitPointTest(ASPolygon *polygon,CGPoint hitPoint);

// ===================================================
//   METHOD NAME:  polygonWithPolygon,
//                 circleWithPolygon,
//                 circleWithCircle
// ===================================================

/*
 + ---------------- + ------------------------------
 |                  |Обработка Коллизий
 |   Purpose:       |
 |                  |
 + ---------------- + ------------------------------
 |                  | Фигуры
 |   Inputs:        |
 |                  |
 + ---------------- + ------------------------------
 |                  |YES - пересечение обнаруженно
 |   Output:        |
 |                  |
 + ---------------- + ------------------------------ */
@class ASCircle;
BOOL polygonWithPolygon(ASPolygon *polygonOne , ASPolygon *polygonTwo);
BOOL circleWithPolygon(ASCircle *circle, ASPolygon *polygon);
BOOL circleWithCircle(ASCircle *circleOne,ASCircle *circleTwo);


// ===================================================
//   METHOD NAME: getHandleMethod
// ===================================================

/*
 + ---------------- + ------------------------------
 |                  |Выдать указатель на обрабаты -
 |   Purpose:       |вающую фукнцию
 |                  |
 + ---------------- + ------------------------------
 |                  | typeOne - тип первой фигуры
 |   Inputs:        | typeTwo - тип второй фигуры
 |                  | methods - мытоды обработки
 + ---------------- + ------------------------------
 |                  |указатель на фукнцию
 |   Output:        |
 |                  |
 + ---------------- + ------------------------------ */
@protocol ASWorldShape;
typedef BOOL (*ShapeHandleMethod)(id<ASWorldShape> shapeOne,id<ASWorldShape> shapeTwo);

ShapeHandleMethod getHandleMethod(int typeOne ,int typeTwo,NSDictionary *methods);

// ===================================================
//   METHOD NAME:  handleCollision
// ===================================================



@class ASContactListner;
BOOL handleCollision(ASContactListner *firstObject,ASContactListner *secondObject,NSDictionary *methods);


