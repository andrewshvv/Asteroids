//
//  ASTexture2D.h
//  OpenGLTest
//
//  Created by Наталья Дидковская on 29.08.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    
    CGPoint br; // buttom right
    CGPoint bl; // buttom left
    CGPoint tr; // top right
    CGPoint tl; // top left
    
} TextureQuad;


@interface ASTexture2D : NSObject {
    
    /* quad of texture coordinates */
    TextureQuad _quad;
    
    @public
    
    /* coefficient of uneven texture  */
    /* for example if globalTexture have width - 512 height 1024 k = 2 */
    CGFloat k;
    
    /* opengl texture unit */
    int unit;
    
    /* GLuint id of texture */
    GLuint name;
    
    /* values in texture coordinates */
    CGFloat width;
    CGFloat height;
    CGFloat offsetX;
    CGFloat offsetY;

}

@property BOOL inverted;

+ (ASTexture2D*) textureWithQuad:(TextureQuad)quad
                            name:(GLuint) name
                            unit:(int) unit
                     coefficient:(CGFloat) k;

- (TextureQuad) quad ;

@end
