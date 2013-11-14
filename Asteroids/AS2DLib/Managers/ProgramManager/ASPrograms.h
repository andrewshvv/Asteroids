//
//  Programs.h
//  OpenGLTest
//
//  Created by Наталья Дидковская on 22.08.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASAnimation;
@interface ASProgram : NSObject {
    
    dispatch_group_t _program_group;
    dispatch_queue_t _program_queue;
    
    NSArray *_attributsValues;
    NSMutableArray *_removeAnimations;
    
    int _indixesBufferDataSize;
    int _arrayBufferDataSize;
    
    @public
    
    GLuint program;
    int count;
    
    
    GLuint vao;
    GLuint arrayBuffer;
    GLuint indixesBuffer;
    
    GLuint locTexture;
    
    int type;
    int stride;
    
    
}

@property   NSDictionary *attributs;
@property   NSHashTable *animations;

/* if active == NO then sprites related to the program are not drawn */
@property (getter = isActive) BOOL active;

    
- (id) initWithAttributs:(NSDictionary *)attributs
        vertexShaderName:(NSString*) vsName
      fragmentShaderName:(NSString*) fsName;


- (void) addAnimation:(ASAnimation*) animation;
- (void) removeAnimation:(ASAnimation*) animation;

- (void) createBuffer;
- (NSDictionary*) copyAttributs;
// ===================================================
//   METHOD NAME:  draw
// ===================================================

/*
 + ---------------- +-------------------------------
 |                  |Used for
 |   Purpose:       |
 |                  |
 + ---------------- + ------------------------------
 |                  |void
 |   Inputs:        |
 |                  |
 + ---------------- + ------------------------------
 |                  |void
 |   Output:        |
 |                  |
 + ---------------- + ------------------------------ */

- (void) draw;

// ===================================================
//   METHOD NAME:  disable/enable
// ===================================================

/*
 + ---------------- + ------------------------------
 |                  |Used for enable/disable OpenGL
 |   Purpose:       |states
 |                  |
 + ---------------- + ------------------------------
 |                  |void
 |   Inputs:        |
 |                  |
 + ---------------- + ------------------------------
 |                  |void
 |   Output:        |
 |                  |
 + ---------------- + ------------------------------ */

- (void) disable;
- (void) enable;


@end

#pragma mark -
#pragma mark ProgramNone
// ===================================================
//   INTERFACE NAME:  ProgramNone
// ===================================================

/*
 + ---------------- + ------------------------------
 |                  | Used for simple drawing with
 |   Purpose:       | no effects 
 |                  |
 + ---------------- + ------------------------------ */

@interface ProgramNone : ASProgram
@end

#pragma mark -
#pragma mark ProgramGradiateCircle
// ===================================================
//   INTERFACE NAME:  ProgramGradiateCircle
// ===================================================

/*
 + ---------------- + ------------------------------
 |                  |  Used for drawing with
 |   Purpose:       |  circle alpa distribution
 |                  |
 + ---------------- + ------------------------------ */

@interface ProgramGradiateCircle : ASProgram
@end


#pragma mark -
#pragma mark ProgramGradiateLinear
// ===================================================
//   INTERFACE NAME:  ProgramGradiateLinear
// ===================================================

/*
 + ---------------- + ------------------------------
 |                  |Used for drawing with
 |   Purpose:       |linear alpa distribution
 |                  |
 + ---------------- + ------------------------------ */
@interface ProgramGradiateLinear : ASProgram
@end



