//
//  Define.h
//  OpenGLTest
//
//  Created by Наталья Дидковская on 07.08.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//


#define FLOAT_SIZE  sizeof(GLfloat)

typedef enum {
    
    TYPE_NONE = 0,
    TYPE_GRADIENT_LINEAR,
    TYPE_GRADIENT_CIRCLE,
    
} TYPE_PROGRAM;


/* SIZE */


static const int SIZE_VERTEX_COORD = 3;
static const int SIZE_TEXTURE_COORD = 2;
static const int SIZE_TRANSLATION_VECTOR = 3;
static const int SIZE_ANGEL = 1;              

static const int SIZE_CENTER_VECTOR = 2;         
static const int SIZE_ALPHA = 1;
static const int SIZE_COEFFICIENT = 1;
static const int SIZE_RADIUS = 1;

static const int SIZE_START_RADIUS = 1;
static const int SIZE_FINISH_RADIUS = 1;

static const int SIZE_START_DEGRADATION = 1;
static const int SIZE_FINISH_DEGRADATION = 1;

/* NAME */

static  NSString* NAME_NA_VS = @"VS_COMON";
static  NSString* NAME_NA_FS = @"FS_COMON";

static  NSString* NAME_GC_VS = @"VS_GRADIENT_CIRCLE";
static  NSString* NAME_GC_FS = @"FS_GRADIENT_CIRCLE";

static  NSString* NAME_GL_VS = @"VS_GRADIENT_LINEAR";
static  NSString* NAME_GL_FS = @"FS_GRADIENT_LINEAR";


static  const char NAME_PROJECTION[] = "uProjection";

static  NSString* NAME_TRANSLATION_VECTOR = @"aTranslateVector";
static  NSString* NAME_ANGEL = @"aAngel";
static  NSString* NAME_VERTEX_COORD = @"aVertexCoord";
static  NSString* NAME_TEXTURE_COORD = @"aTextureCoord";
static  NSString* NAME_MODEL_VIEW = @"aModelView";
static  NSString* NAME_MODEL_VIEW_TWO = @"aModelViewTwo";
static  NSString* NAME_ALPHA = @"aAlpha";
static  NSString* NAME_RADIUS = @"aRadius";
static  NSString* NAME_CENTER_VECTOR = @"aCenterVector";
static  NSString* NAME_COEFFICIENT = @"aCoefficient";
static  NSString* NAME_START_RADIUS = @"aStartRadius";
static  NSString* NAME_FINISH_RADIUS = @"aFinishRadius";
static  NSString* NAME_START_DEGRADATION = @"aStartDegradation";
static  NSString* NAME_FINISH_DEGRADATION = @"aFinishDegradation";

