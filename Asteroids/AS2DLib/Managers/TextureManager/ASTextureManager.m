//
//  TextureManager.m
//  OpenGLTest
//
//  Created by Наталья Дидковская on 26.07.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import "ASTextureManager.h"
#import "Packer.h"

static ASTextureManager *_textureManager = nil;

@implementation ASTextureManager

const int MAX_TEXTURE_UNIT = 32;

+ (ASTextureManager*) textureManager {
    
    @synchronized(self) {
        
        if (!_textureManager) {
            
            _textureManager = [[ASTextureManager alloc] init];

        }
    }
    return _textureManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        glEnable(GL_BLEND);
        glBlendEquation(GL_FUNC_ADD);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
        
        _freeUnit = [NSMutableIndexSet indexSet];
        _busyUnit = [NSMutableIndexSet indexSet];
        
        for(int i = 0; i < MAX_TEXTURE_UNIT ; i++){
            
            [_freeUnit addIndex:i];
            
        }
        
 
        [self createImagesWithPlist:@"Images"];
        
        
    }
    return self;
}

- (void) createImagesWithPlist:(NSString*) plist
{
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:plist ofType:@"plist"];
    NSDictionary *imagesDictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    NSMutableArray *spriteDataArray = [NSMutableArray array];
    NSMutableArray *rectArray = [NSMutableArray array];
    
    for (NSString *fileName in [imagesDictionary allKeys]) {
        
        CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
        
        if (!spriteImage) {
            
            NSString *errorString = [NSString stringWithFormat:@"Faile load image: %@" ,fileName];
            NSException *ex = [NSException exceptionWithName:@"Image Error" reason: errorString userInfo:nil];
            @throw ex;
            
        }
        
        float width = CGImageGetWidth(spriteImage);
        float height = CGImageGetHeight(spriteImage);
        
        CGRect rect = CGRectMake(0, 0, width, height);
        
        GLubyte *spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
        
        CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                           CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
        
        CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
        CGContextRelease(spriteContext);
        
        [spriteDataArray addObject:[NSValue valueWithPointer:spriteData]];
        [rectArray addObject:[NSValue valueWithCGRect:rect]];
        
    }
    
    NSArray *packedRect = [Packer packedBlocks:rectArray];
    
    
    
    
    GLuint newTexture;
    
    glGenTextures(1, &newTexture);
    
    NSInteger unit = 0;
    if([_freeUnit count] != 0) {
        
        unit = [_freeUnit firstIndex];
        [_freeUnit removeIndex:unit];
        [_busyUnit addIndex:unit];
        
        
    } else {
        
        
        
    }
    
    glActiveTexture(GL_TEXTURE0 + unit);
    glBindTexture(GL_TEXTURE_2D, newTexture);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    
    /* init global texture */
    CGFloat globalWidth = [Packer width];
    CGFloat globalHeight = [Packer height];
    
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, globalWidth , globalHeight , 0, GL_RGBA, GL_UNSIGNED_BYTE,nil);
    
    /* fill global texture */
    for (int i = 0; i < [spriteDataArray count]; i++) {
        
        CGRect rect = [[packedRect objectAtIndex:i] CGRectValue];
        GLubyte* spriteDataPointer = (GLubyte*)([[spriteDataArray objectAtIndex:i] pointerValue]);
        
        CGFloat x = rect.origin.x ;
        CGFloat y = rect.origin.y;
        CGFloat w = rect.size.width;
        CGFloat h = rect.size.height;
        
        glTexSubImage2D(GL_TEXTURE_2D, 0, x, y, w, h, GL_RGBA, GL_UNSIGNED_BYTE, spriteDataPointer);
        
        free(spriteDataPointer);
        
    }
    
    /* create image tree */
    
    /* create root image */
    TextureQuad quad;
    quad.br = CGPointMake(1 ,1);
    quad.tr = CGPointMake(1 ,0);
    quad.tl = CGPointMake(0 ,0);
    quad.bl = CGPointMake(0 ,1);
    
    CGFloat k = globalHeight/globalWidth;
    
    ASTexture2D *texture = [ASTexture2D textureWithQuad:quad name:newTexture unit:unit coefficient:k];
    _global = [[ASCompositeImage alloc] initWidth:globalWidth height:globalHeight name:@"Global" texture:texture];
    
    ASCompositeImage *parent = _global;
    
    /* create nodes */
    for (int i = 0; i < [rectArray count]; i++) {
        
        CGRect rect = [[packedRect objectAtIndex:i] CGRectValue];
        CGFloat x = rect.origin.x ;
        CGFloat y = rect.origin.y;
        CGFloat w = rect.size.width;
        CGFloat h = rect.size.height;
        
        CGFloat rx = ((x + w) / parent.width)*parent.texture->width  + parent.texture->offsetX;
        CGFloat lx = (x / parent.width)*parent.texture->width  + parent.texture->offsetX;
        
        CGFloat by = ((y + h)/parent.height)*parent.texture->height + parent.texture->offsetY;
        CGFloat ty = (y / parent.height)      *  parent.texture->height + parent.texture->offsetY;
        
        CGFloat fl = 0;//powf(10, -9); //fl - fluctuation
        
        TextureQuad quad;
        quad.br = CGPointMake(rx  - fl*w  , by - fl*h);
        quad.tr = CGPointMake(rx  - fl*w  , ty + fl*h);
        quad.tl = CGPointMake(lx  + fl*w  , ty + fl*h);
        quad.bl = CGPointMake(lx  + fl*w  , by - fl*h);
        
        ASTexture2D *texture = [ASTexture2D textureWithQuad:quad name:newTexture unit:unit coefficient:k];
        
        NSArray *imageNames = [imagesDictionary allKeys];
        NSString *imageName = [imageNames objectAtIndex:i];
        
        BOOL isCompositeImage = [[imagesDictionary objectForKey:imageName] boolValue];
        
        
        if(isCompositeImage){
            
            ASCompositeImage *node = [[ASCompositeImage alloc] initWidth:w height:h name:imageName texture:texture];
            
            [parent.nodes addObject:node];
            parent = node;
            
            NSString *compositePlist = [NSString stringWithFormat:@"Composite%@",plist];
            NSString *filePath = [[NSBundle mainBundle] pathForResource:compositePlist ofType:@"plist"];
            NSDictionary *internalImages = [[NSDictionary dictionaryWithContentsOfFile:filePath] objectForKey:imageName];
            
            for (NSString *internalImage in internalImages) {
                
                NSDictionary *info = [internalImages objectForKey:internalImage];
                
                x = [[info objectForKey:@"offsetX"] floatValue];
                y = [[info objectForKey:@"offsetY"] floatValue];
                w = [[info objectForKey:@"width"] floatValue];
                h = [[info objectForKey:@"height"] floatValue];
                
                CGFloat rx = ((x + w) / parent.width)*parent.texture->width  + parent.texture->offsetX;
                CGFloat lx = (x / parent.width)*parent.texture->width  + parent.texture->offsetX;
                
                CGFloat by = ((y + h)/parent.height)*parent.texture->height + parent.texture->offsetY;
                CGFloat ty = (y / parent.height)*parent.texture->height + parent.texture->offsetY;
                
                CGFloat fl = 0;//powf(10, -5); //fl - fluctuation
     
                TextureQuad quad;
                quad.br = CGPointMake(rx  - fl*w  , by - fl*h);
                quad.tr = CGPointMake(rx  - fl*w  , ty + fl*h);
                quad.tl = CGPointMake(lx  + fl*w  , ty + fl*h);
                quad.bl = CGPointMake(lx  + fl*w  , by - fl*h);
                ASTexture2D *texture = [ASTexture2D textureWithQuad:quad
                                                               name:newTexture
                                                               unit:unit
                                                        coefficient:k];
                ASImage *image = [[ASImage alloc] initWidth:w height:h name:internalImage texture:texture];
                
                [parent.nodes addObject:image];
                
            }
            
            parent = _global;
            
            
        } else {
            
        [parent.nodes addObject:[[ASImage alloc] initWidth:w height:h name:imageName texture:texture]];
            
        }
    }
}

- (id<ASImageNode>) returnImage:(NSString*) fileName {
    
    return [_global image:fileName];
    
}


@end
