//
//  BufferManager.h
//  OpenGLTest
//
//  Created by Наталья Дидковская on 28.07.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import <Foundation/Foundation.h>

BOOL CheckForExtension(NSString *searchName);

typedef void (^VAOSettings)(void);

typedef struct {
    
    GLint size;
    GLint usage;
    GLint access;
    GLint mapped;
    
} BuffParam ;

@class GLView;
@interface ASBufferManager : NSObject {
    
    /* context that contains all the information about the OpenGL ES state */
    EAGLContext *_context;
    
    @public
    
    GLuint frameBuffer;
    GLuint colorRenderBuffer;
    GLuint stencilRenderBuffer;
    GLuint depthRenderBuffer;
    
}

+ (ASBufferManager*)bufferManager ;

- (void) initBuffers:(GLView*) view ;
- (void) presentRenderBuffer ;

- (GLuint) createVAO:(VAOSettings) block ;

- (void) changeData:(GLuint) buffer type:(GLenum) type size:(GLsizeiptr) size data:(const GLvoid*) data ;
- (GLuint) createBufferObjectWithType:(GLenum) type withSize: (GLsizeiptr) size andPointerToData: (const GLvoid *) data ;

- (void) delBuffer:(GLuint) buffer ;
- (BuffParam) getVBOParam:(GLuint) buffID ;
@end
