//
//  ShaderManager.m
//  OpenGLTest
//
//  Created by Наталья Дидковская on 26.07.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import "ASProgramManager.h"
#import "AS2DConstants.h"


static ASProgramManager *_programManager = nil;

@implementation ASProgramManager

+ (ASProgramManager*)programManager {
    
    @synchronized(self) {
        if (!_programManager) {
            _programManager = [[ASProgramManager alloc] init];
        }
    }
    return _programManager;
}




- (id)init {
    self = [super init];
    if (self) {
        
        _programs = [NSMutableDictionary dictionary];
        
    }
    return self;
}

- (ASProgram*) program:(int) type
{
    
    return  [_programs objectForKey:[NSNumber numberWithInteger:type]];
    
}


- (void) createBuffers {
    
    ASProgram *program;
    for (NSNumber *number in _programs) {
        program = [_programs objectForKey:number];
        
        int count = [program.animations count];
        if(count != 0){
            
            [program createBuffer];
            
        }
    }
    
}

- (void) draw {

    ASProgram *program;
    for (NSNumber *number in _programs) {
        program = [_programs objectForKey:number];
    
        int count = [program.animations count];
        if(count != 0){
            
            [program draw];
            
        }
    }
}

- (void) createPrograms {
    
    NSMutableDictionary *naAttributs = [NSMutableDictionary dictionary];
    [naAttributs setObject:[ASAttribute attributeWithSize:SIZE_VERTEX_COORD ]       forKey:NAME_VERTEX_COORD];
    [naAttributs setObject:[ASAttribute attributeWithSize:SIZE_TEXTURE_COORD ]      forKey:NAME_TEXTURE_COORD];
    [naAttributs setObject:[ASAttribute attributeWithSize:SIZE_ANGEL ]              forKey:NAME_ANGEL];
    [naAttributs setObject:[ASAttribute attributeWithSize:SIZE_TRANSLATION_VECTOR]  forKey:NAME_TRANSLATION_VECTOR];
    
    /*#########################################################################################################*/
    
    NSMutableDictionary *gcAttributs = [NSMutableDictionary dictionary];
    [gcAttributs setObject:[ASAttribute attributeWithSize:SIZE_VERTEX_COORD]    	forKey:NAME_VERTEX_COORD];
    [gcAttributs setObject:[ASAttribute attributeWithSize:SIZE_TEXTURE_COORD]   	forKey:NAME_TEXTURE_COORD];
    [gcAttributs setObject:[ASAttribute attributeWithSize:SIZE_ANGEL ]              forKey:NAME_ANGEL];
    [gcAttributs setObject:[ASAttribute attributeWithSize:SIZE_TRANSLATION_VECTOR]  forKey:NAME_TRANSLATION_VECTOR];
    
    [gcAttributs setObject:[ASAttribute attributeWithSize:SIZE_CENTER_VECTOR]       forKey:NAME_CENTER_VECTOR];
    [gcAttributs setObject:[ASAttribute attributeWithSize:SIZE_START_RADIUS]    	forKey:NAME_START_RADIUS];
    [gcAttributs setObject:[ASAttribute attributeWithSize:SIZE_FINISH_RADIUS]       forKey:NAME_FINISH_RADIUS];
    [gcAttributs setObject:[ASAttribute attributeWithSize:SIZE_ALPHA]           	forKey:NAME_ALPHA];
    [gcAttributs setObject:[ASAttribute attributeWithSize:SIZE_COEFFICIENT]     	forKey:NAME_COEFFICIENT];

    /*#########################################################################################################*/
    
    NSMutableDictionary *glAttributs = [NSMutableDictionary dictionary];
    [glAttributs setObject:[ASAttribute attributeWithSize:SIZE_VERTEX_COORD]        forKey:NAME_VERTEX_COORD];
    [glAttributs setObject:[ASAttribute attributeWithSize:SIZE_TEXTURE_COORD]       forKey:NAME_TEXTURE_COORD];
    [glAttributs setObject:[ASAttribute attributeWithSize:SIZE_TRANSLATION_VECTOR]  forKey:NAME_TRANSLATION_VECTOR];
    [glAttributs setObject:[ASAttribute attributeWithSize:SIZE_ANGEL ]              forKey:NAME_ANGEL];
    
    [glAttributs setObject:[ASAttribute attributeWithSize:SIZE_START_DEGRADATION]   forKey:NAME_START_DEGRADATION];
    [glAttributs setObject:[ASAttribute attributeWithSize:SIZE_FINISH_DEGRADATION]  forKey:NAME_FINISH_DEGRADATION];
    
    /*#########################################################################################################*/
    
    
    [_programs setObject:[[ProgramGradiateCircle alloc] initWithAttributs:gcAttributs
                                               vertexShaderName:NAME_GC_VS
                                             fragmentShaderName:NAME_GC_FS]
                  forKey:[NSNumber numberWithInteger:TYPE_GRADIENT_CIRCLE]];
    
    [_programs setObject:[[ProgramGradiateLinear alloc] initWithAttributs:glAttributs
                                               vertexShaderName:NAME_GL_VS
                                             fragmentShaderName:NAME_GL_FS]
                  forKey:[NSNumber numberWithInteger:TYPE_GRADIENT_LINEAR]];
    
    [_programs setObject:[[ProgramNone alloc] initWithAttributs:naAttributs
                                               vertexShaderName:NAME_NA_VS
                                             fragmentShaderName:NAME_NA_FS]
                  forKey:[NSNumber numberWithInteger:TYPE_NONE]];
}
@end
