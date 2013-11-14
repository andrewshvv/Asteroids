//
//  TextureManager.h
//  OpenGLTest
//
//  Created by Наталья Дидковская on 26.07.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASImage.h"
#import "ASTexture2D.h"


@interface ASTextureManager : NSObject {
    
    /* usually begin there are 32 available unit  */
    NSMutableIndexSet *_freeUnit;
    NSMutableIndexSet *_busyUnit;
    
    /* parent image */
    ASCompositeImage *_global;
    
}

+ (ASTextureManager*) textureManager;

- (void) createImagesWithPlist:(NSString*) plist;
- (ASImage*) returnImage:(NSString*) fileName ;

@end
