//
//  BufferManager.m
//  OpenGLTest
//
//  Created by Наталья Дидковская on 28.07.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import "ASBufferManager.h"
#import "GLView.h"
#import <OpenGLES/ES3/glext.h>

static ASBufferManager *_bufferManager = nil;

@implementation ASBufferManager

+ (ASBufferManager*)bufferManager {
    
    @synchronized(self) {
        if (!_bufferManager) {
            _bufferManager = [[ASBufferManager alloc] init];
            
            
        }
        
        
    }
    return _bufferManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
        [EAGLContext setCurrentContext: _context];
        
        
        
    }
    return self;
}




- (void) initBuffers:(GLView*) view {

    glViewport(0, 0, view.bounds.size.width, view.bounds.size.height);
    
    
    [self setupFrameBuffer];
    [self setupColorRenderBuffer:view ];
    
    [self checkFrameBufferStatus];
    
}

- (GLuint) createVAO:(VAOSettings) block  {
    
    GLuint vao;
    
    glGenVertexArraysOES(1, &vao);
    glBindVertexArrayOES(vao);
    
    block();
    
    glBindVertexArrayOES(0);
    
    return vao;
    
    
}
- (void) delBuffer:(GLuint) buffer {
    
    GLuint buf[1] = {buffer};
    
    glDeleteBuffers(1, buf);
    
}
- (BuffParam) getVBOParam:(GLuint) buffID {
    
    BuffParam param;
    glIsBuffer(buffID)?:NSLog(@"It's not buffer!");
    
    glBindBuffer(GL_ARRAY_BUFFER, buffID);
    
    glGetBufferParameteriv(GL_ARRAY_BUFFER,GL_BUFFER_SIZE, &(param.size));
    glGetBufferParameteriv(GL_ARRAY_BUFFER,GL_BUFFER_USAGE,&(param.usage));
    glGetBufferParameteriv(GL_ARRAY_BUFFER,GL_BUFFER_ACCESS_OES,&(param.access));
    glGetBufferParameteriv(GL_ARRAY_BUFFER,GL_BUFFER_MAPPED_OES,&(param.mapped));
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    
    
    return param;
}
- (void) changeData:(GLuint) buffer type:(GLenum) type size:(GLsizeiptr) size data:(const GLvoid*) data {
    
    glBindBuffer(type, buffer);
    glBufferSubData(type, 0, size, data);

    glBindBuffer(type, 0);
    
}

- (GLuint) createBufferObjectWithType:(GLenum) type
                             withSize: (GLsizeiptr) size
                     andPointerToData: (const GLvoid *) data
{
	GLuint buffer;
	
	glGenBuffers(1, &buffer);
	
	glBindBuffer(type, buffer);
    
	glBufferData(type, size, data, GL_DYNAMIC_DRAW);
    
    glBindBuffer(type, 0);
	
	return buffer;
}


- (void) setupFrameBuffer {
    
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    
}
- (void) setupColorRenderBuffer:(GLView*) view {
    
    glGenRenderbuffers(1, &colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable: (CAEAGLLayer*)view.layer];
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderBuffer);
    
}
- (void) setupDepthRenderBuffer:(GLView*) view {
    
    glGenRenderbuffers(1, &depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, view.bounds.size.width, view.bounds.size.height);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderBuffer);
    
    glEnable(GL_DEPTH_TEST);
    
}
- (void) setupStencilRenderBuffer {
    
    glGenRenderbuffers(1, &stencilRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, stencilRenderBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_STENCIL_ATTACHMENT, GL_RENDERBUFFER, stencilRenderBuffer);
    glEnable(GL_STENCIL_TEST);
    
}
- (void) checkFrameBufferStatus {
    
    
    switch (glCheckFramebufferStatus(GL_FRAMEBUFFER))
	{
		case GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT:
			printf("Error creating FrameBuffer: Incomplete Attachment.\n");
			break;
		case GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT:
			printf("Error creating FrameBuffer: Missing Attachment.\n");
			break;
		case GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS:
			printf("Error creating FrameBuffer: Incomplete Dimensions.\n");
			break;
		case GL_FRAMEBUFFER_UNSUPPORTED:
			printf("Error creating FrameBuffer: Unsupported Buffers.\n");
			break;
	}
}


- (void) presentRenderBuffer {
    
    const GLenum attachments[] = {GL_COLOR_ATTACHMENT0};
    glDiscardFramebufferEXT(GL_FRAMEBUFFER , 1, attachments);
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
    
    glClear(GL_COLOR_BUFFER_BIT );
    
    
}

@end
