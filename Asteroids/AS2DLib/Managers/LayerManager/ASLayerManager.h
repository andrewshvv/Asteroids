//
//  GeneralMeneger.h
//  OpenGLTest
//
//  Created by Наталья Дидковская on 15.07.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AS2DConstants.h"

#import "ASBufferManager.h"
#import "ASProgramManager.h"
#import "World.h"


/* ASLayerManager    */
@class ASLayer;
@interface ASLayerManager : NSObject {
    
    /* main view */
    GLView *_glView;
    
    /* used for calculate interval */
    CFTimeInterval _lastTimestamp;
    
    /* all the layers that have been initialized */
    NSMutableArray* _layers;
    
    ASBufferManager *_bufferManager;
    ASProgramManager *_programManager;
    World *_world;
    
}

+ (ASLayerManager*)layerManager;

/* init managers and start run loop */
- (void) initManagers:(GLView*) glView;

- (CGFloat) height;
- (CGFloat) width;

/* used by layers */
- (void) addLayer:(ASLayer*) layer;


@end

