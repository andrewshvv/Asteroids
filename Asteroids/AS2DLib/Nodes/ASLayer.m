//
//  Layer.m
//  OpenGLTest
//
//  Created by Наталья Дидковская on 15.07.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import "ASLayer.h"

#import "ASButton.h"
#import "GLView.h"
#import "ASAnimation.h"


@implementation ASLayer

@synthesize glView = _glView;

- (id) init {
    
    self = [super init];
    
    if(self){
        
        _subviews = [NSMutableArray array];
        
        [[ASLayerManager layerManager] addLayer:self];
    }
    
    return self;
    
}

- (void) setPause:(BOOL) isPaused {
    
    self->pause = isPaused;
    for (id<ASNode> node in self.nodes) {
        
        [node setPause:isPaused];
        
    }
    
}

- (void) setHidden:(BOOL)isHidden {
    
    self->hidden = isHidden;
    for (id<ASNode> node in self.nodes) {
        
        [node setHidden:isHidden];
        
    }
}

- (void) addButton:(Item *)item {
    
    [_glView addSubview:item.view];
    
    [self addNode:item];
    
    [item setHidden:self.isHidden];
    
}



@end

