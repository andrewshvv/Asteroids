//
//  GeneralMeneger.m
//  OpenGLTest
//
//  Created by Наталья Дидковская on 15.07.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import "ASLayerManager.h"

#import "GLView.h"
#import "ASLayer.h"

static ASLayerManager *_layerManager = nil;

@implementation ASLayerManager

+ (ASLayerManager*)layerManager {
    
    @synchronized(self) {
        if (!_layerManager) {
            
            _layerManager = [[ASLayerManager alloc] init];
        }
        
        
    }
    return _layerManager;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        
        _lastTimestamp = CACurrentMediaTime();


        _layers = [NSMutableArray array];
        
        _bufferManager = [ASBufferManager bufferManager];
        _programManager = [ASProgramManager programManager];
        _world = [World world];
        
        
        
    }
    return self;
}

- (void) initManagers:(GLView*) glView {
    
    _glView = glView;
    
    [_bufferManager initBuffers:_glView];
    [_programManager createPrograms];
    
    [self start];
    
}

- (CGFloat) height {
    
    return _glView.frame.size.height;
    
}
- (CGFloat) width {
    
    return _glView.frame.size.width;
    
}
- (void) addLayer:(ASLayer*) layer
{
    
    [_layers addObject:layer];
    
    layer.glView = _glView;
    
}

- (void) start {
    
    CADisplayLink *dl = [CADisplayLink displayLinkWithTarget:self selector:@selector(processing:)];
    [ dl addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
}



- (void) processing:(CADisplayLink*) displayLink {

    /* calculate interval */
    CFTimeInterval dt = displayLink.timestamp - _lastTimestamp;
    _lastTimestamp = displayLink.timestamp;
    
    /* update shapes and handle collisions */
    [_world update:dt];
    [_world handleCollisions];

    
    /* update all nodes */
    for (ASLayer *layer in _layers) {
        if(!layer.isPaused){
            [layer update:dt];
        }
    }
    
    [_programManager createBuffers];
    [_programManager draw];
    
    [_bufferManager presentRenderBuffer];
    
}

@end
