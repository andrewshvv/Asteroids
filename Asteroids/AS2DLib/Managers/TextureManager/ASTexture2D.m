//
//  ASTexture2D.m
//  OpenGLTest
//
//  Created by Наталья Дидковская on 29.08.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import "ASTexture2D.h"

@implementation ASTexture2D


@synthesize inverted = _inverted;

- (id)initWithQuad:(TextureQuad) theQuad name:(GLuint) theName unit:(int) theUnit theCoefficient:(CGFloat) theCoef {
    self = [super init];
    if (self) {
        
        unit = theUnit;
        name = theName;
        _quad = theQuad;
        
        _inverted = NO;
        k = theCoef;
        width = _quad.br.x - _quad.bl.x;
        
        /*
                
            (0,0)-----------> x
             | tl           tr
             |
             |
             v bl           br
            y
         
         */
        
        height = _quad.br.y - _quad.tr.y;
        
        offsetX = _quad.tl.x;
        offsetY = _quad.tl.y;
        
    }
    return self;
}

+ (ASTexture2D*) textureWithQuad:(TextureQuad)quad  name:(GLuint) name unit:(int) unit coefficient:(CGFloat) k
{
    
    return [[ASTexture2D alloc] initWithQuad:quad name:name unit:unit theCoefficient:k];
    
}


TextureQuad invert(TextureQuad tquad){
    
    TextureQuad inverted;
    
    inverted.bl = tquad.br;
    inverted.br = tquad.bl;
    inverted.tl = tquad.tr;
    inverted.tr = tquad.tl;
    
    return inverted;
    
}

- (TextureQuad) quad {
    
    if(_inverted == NO){
    
        return _quad;
        
    } else {
    
        return invert(_quad);
        
    }
}

- (void) setQuad:(TextureQuad) quad {
    
    _quad = quad;
    
}

@end
