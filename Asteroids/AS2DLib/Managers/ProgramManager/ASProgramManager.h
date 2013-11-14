//
//  ShaderManager.h
//  OpenGLTest
//
//  Created by Наталья Дидковская on 26.07.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASPrograms.h"

#import "ASAnimation.h"
#import "ASAttribute.h"

@interface ASProgramManager : NSObject {

    NSMutableDictionary *_programs;
    
}


+ (ASProgramManager*)programManager;

- (ASProgram*) program:(int) type;

- (void) draw;

- (void) createBuffers;
- (void) createPrograms;

@end
