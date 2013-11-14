//
//  GLView.m
//  OpenGLTest
//
//  Created by Наталья Дидковская on 09.07.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import "GLView.h"

@implementation GLView

+ (Class) layerClass {
    
    return [CAEAGLLayer class];
    
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Assign a variable to be our CAEAGLLayer temporary.
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)[self layer];
        
        // Construct a dictionary with our configurations.
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
                              kEAGLColorFormatRGB565, kEAGLDrawablePropertyColorFormat,
                              nil];
        
        // Set the properties to CAEALLayer.
        [eaglLayer setOpaque:YES];
        [eaglLayer setDrawableProperties:dict];
        
    }
    return self;
}

@end