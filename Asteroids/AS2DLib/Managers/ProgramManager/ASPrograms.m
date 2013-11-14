//
//  Programs.m
//  OpenGLTest
//
//  Created by Наталья Дидковская on 22.08.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

//
//  ShaderManager.m
//  OpenGLTest
//
//  Created by Наталья Дидковская on 26.07.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import "ASLayerManager.h"
#import "ASSprite.h"
#import "Pair.h"
#import "ASMath.h"

#import "ASAttribute.h"
#import "ASAnimation.h"

void offset(NSArray* attributs){
    
    ASAttribute *prevAttrib = [attributs objectAtIndex:0];
    ASAttribute *attrib;
    for (int i = 1; i < [attributs count]; i++) {
        
        attrib = [attributs objectAtIndex:i];
        attrib->offset = prevAttrib->offset + prevAttrib->size;
        prevAttrib = attrib;
        
    }
    
}

int getStride(NSArray* attributs){
    
    int stride = 0;
    for (ASAttribute *attrib in attributs) {
        
        stride += attrib->size;
        
    }
    
    return stride;
    
}

void setting(NSArray *attributs,int stride){
    
    int byteStride = stride * sizeof(CGFloat);
    
    for (ASAttribute *attrib in attributs) {
        
        int byteOffset = attrib->offset * sizeof(CGFloat);
        
        glEnableVertexAttribArray(attrib->loc);
        glVertexAttribPointer(attrib->loc , attrib->size, GL_FLOAT, GL_FALSE, byteStride ,(void*)byteOffset);
        
    }
    
    
}

void setLocations(GLuint program,NSDictionary *dAttributs){
    
    NSArray *aAttributs = [dAttributs allKeys];
    
    for (NSString *name in aAttributs) {
        
        ASAttribute *attrib = [dAttributs objectForKey:name];
        
        attrib->loc = glGetAttribLocation(program,[name UTF8String]);
     
    }
    
}

GLuint createShader(NSString* shaderName ,GLenum shaderType){
    
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName
                                                           ofType:@"glsl"];
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath
                                                       encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        NSLog(@"Error loading shader: %@", error.localizedDescription);
        exit(1);
    }
    
    GLuint shaderHandle = glCreateShader(shaderType);
    
    const char * shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = [shaderString length];
    
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    glCompileShader(shaderHandle);
    
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    
    if (compileSuccess == GL_FALSE) {
        
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    return shaderHandle;
    
}

GLuint createProgramWithVertexShader(GLuint vertexShader ,GLuint fragmentShader) {
    
    GLuint program = glCreateProgram();
    
    glAttachShader(program, vertexShader);
    glAttachShader(program, fragmentShader);
    glLinkProgram(program);
    
    
    return  program;
}   


@implementation ASProgram

- (id) initWithAttributs:(NSDictionary *)attributs
        vertexShaderName:(NSString*) vsName
      fragmentShaderName:(NSString*) fsName
{
    
    self = [super init];
    
    if(self){
        
        _animations = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
        _attributs = attributs;
        _attributsValues = [attributs allValues];
        _removeAnimations = [NSMutableArray array];
        
        
        count = 0;
        stride = 0;
        
        _indixesBufferDataSize = 10000;
        _arrayBufferDataSize = 3000;
        
        NSString *queue_name = [NSString stringWithFormat:@"%@_Queue",[self class]];
        
        _program_group  = dispatch_group_create();
        _program_queue  = dispatch_queue_create([queue_name UTF8String], NULL);

        
        GLuint vs = createShader(vsName, GL_VERTEX_SHADER);
        GLuint fs = createShader(fsName, GL_FRAGMENT_SHADER);
    
        program = createProgramWithVertexShader(vs, fs);
        
        glUseProgram(program);
        
        glDeleteShader(vs);
        glDeleteShader(fs);
        
        offset([_attributs allValues]);
        stride = getStride([_attributs allValues]);
        
        setLocations(program, attributs);
        
        CGFloat width = [[ASLayerManager layerManager] width];
        CGFloat height = [[ASLayerManager layerManager] height];
        
        GLuint projectionLoc;
        projectionLoc = glGetUniformLocation(program, NAME_PROJECTION);
        
        ASMatrix *_projectionMatrix = [ASMatrix populateOrthoFromFrustumLeft:0
                                                                    andRight:width
                                                                   andBottom:height
                                                                      andTop:0
                                                                     andNear:1
                                                                      andFar:3];
        
        
        
        
        glUniformMatrix4fv(projectionLoc, 1, 0, _projectionMatrix->glMatrix);
        
        
        locTexture   = glGetUniformLocation(program,"uTexture2D");
        
        arrayBuffer = [[ASBufferManager bufferManager] createBufferObjectWithType:GL_ARRAY_BUFFER
                                                                       withSize:_arrayBufferDataSize
                                                               andPointerToData:nil];
        
        indixesBuffer = [[ASBufferManager bufferManager] createBufferObjectWithType:GL_ELEMENT_ARRAY_BUFFER
                                                                         withSize:_indixesBufferDataSize
                                                                 andPointerToData:nil];
        
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indixesBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, arrayBuffer);
        
        vao = [[ASBufferManager bufferManager] createVAO:^{
           
            setting([_attributs allValues],stride);
            
        }];
        
        glUniform1i(locTexture,0);
        
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
        
        
    }
    
    return self;
    
}

- (void) enable {
    
    glUseProgram(program);
    glBindVertexArrayOES(vao);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indixesBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, arrayBuffer);
    
    
}

- (void) disable {
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    
    glBindVertexArrayOES(0);
    
}

- (NSDictionary*) copyAttributs
{
    
    NSMutableDictionary *attributs = [NSMutableDictionary dictionary];
    
    NSArray *keys  = [_attributs allKeys];
    for (NSString *key in keys) {
        [attributs setValue:[[_attributs objectForKey:key] copy] forKey:key];
    }
    
    return attributs;
    
}

- (void) removeAnimation:(ASAnimation*) animation
{
    @synchronized(_animations){
        
        [_animations removeObject:animation];
        
    }
}

- (void) addAnimation:(ASAnimation*) animation
{
    @synchronized(_animations){
        
        [_animations addObject:animation];
        
    }
}

- (void) createBuffer {

    GLushort *indixesBufferData ;
    void *arrayBufferData ;
    
    int indixesCount = 0;
    int pointCount = 0;
    
    /* 1.1 calculate arrayBufferData and indixesBufferData size */
    
    for (ASAnimation *animation in _animations) {
        if(!animation.sprite.isHidden){
         
            pointCount += animation->pointCount;
            indixesCount += animation->indixesCount;
            
        }
    }

    /* 1.2 allocate arrayBufferData and indixesBufferData */
    int indixesBufferDataSize = indixesCount * 3 * sizeof(GLushort);
    indixesBufferData = malloc(indixesBufferDataSize);
    
    int arrayBufferDataSize = pointCount * stride * FLOAT_SIZE;
    arrayBufferData = malloc(arrayBufferDataSize);
    
    /* 2.1 set data in arrayBufferData */
    count = 0;
    int dataOffset = 0;
    int objectIndixesOffset = 0;
    
        
    for (ASAnimation *animation in _animations) {
//        animation = [_animations objectForKey:number];
        
//        NSLog(@"%@",[self class]);
        
        
        if(animation.sprite.isHidden == NO){
            
            /* 2.2 fill arrayBufferData */
            CGFloat *data = animation->data;
            
            int copySize = animation->pointCount * stride * FLOAT_SIZE;
            memcpy((arrayBufferData + dataOffset), data, copySize);
            
            //offset in bytes!
            dataOffset += copySize;
            
            
            /* 2.3 fill indixesBufferData*/
            NSArray *indixes = animation.indixes;
            for (ASIndices *ind in indixes) {
                
                indixesBufferData[count] = ind->fisrt + objectIndixesOffset;
                indixesBufferData[count + 1] = ind->second + objectIndixesOffset;
                indixesBufferData[count + 2] = ind->third + objectIndixesOffset;
                
                count += 3;
            }
            
            objectIndixesOffset += animation->pointCount;
            
//            if([self isKindOfClass:[ProgramNone class]]){
//            
//                NSLog(@"\n Animation point count:%i ",animation->pointCount);
//                
//                NSMutableString *desription = [NSMutableString string];
//                int desOffset = 0;
//                
//                void* pointer = arrayBufferData + dataOffset - copySize;
//                
//                for (int i = 0 ; i < animation->pointCount; i++) {
//                    [desription appendString:@"\n" ];
//                    for (NSString *attributeKey in _attributs) {
//                        
//                        ASAttribute *attribute = [_attributs objectForKey:attributeKey];
//                        int countOffloat = attribute->size;
//                        for (int i = 0; i < countOffloat; i++) {
//                            
//                            [desription appendFormat:@" %2.f ",*(CGFloat*)(pointer + desOffset +  4*i)];
//                            
//                            
//                        }
//                        
//                        desOffset += attribute->size * FLOAT_SIZE;
//                        
//                        [desription appendString:@"|"];
//                        
//                    }
//                    
//                    [desription appendString:@"\n"];
//                    
//                }
//                
//                NSLog(@"%@",desription);
//                
//                NSLog(@"\n -----------------------------------");
//            }
        }

    }

    
    if((arrayBufferDataSize > _arrayBufferDataSize) || (indixesBufferDataSize > _indixesBufferDataSize) ){
        
        if(arrayBufferDataSize > _arrayBufferDataSize){
            
            _arrayBufferDataSize = 2 * arrayBufferDataSize;
            [[ASBufferManager bufferManager] delBuffer:arrayBuffer];
            arrayBuffer = [[ASBufferManager bufferManager] createBufferObjectWithType:GL_ARRAY_BUFFER
                                                                           withSize:_arrayBufferDataSize
                                                                   andPointerToData:nil];
            
            
        } else {
            
            _indixesBufferDataSize = 2 * indixesBufferDataSize;
            [[ASBufferManager bufferManager] delBuffer:indixesBuffer];
            indixesBuffer = [[ASBufferManager bufferManager] createBufferObjectWithType:GL_ELEMENT_ARRAY_BUFFER
                                                                             withSize:_indixesBufferDataSize
                                                                     andPointerToData:nil];
            
        }
        
        GLuint array[] = { vao };
        glDeleteVertexArraysOES(1, array);
        
        glBindBuffer(GL_ARRAY_BUFFER, arrayBuffer);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indixesBuffer);
        
        vao = [[ASBufferManager bufferManager] createVAO:^{
            
            setting([_attributs allValues],stride);
            
        }];
        
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
        
    }
    
    /* 4.1 change arrayBuffer and indixesBuffer */
    [[ASBufferManager bufferManager] changeData:arrayBuffer
                                         type:GL_ARRAY_BUFFER
                                         size:arrayBufferDataSize
                                         data:arrayBufferData];
    
    
    [[ASBufferManager bufferManager] changeData:indixesBuffer
                                         type:GL_ELEMENT_ARRAY_BUFFER
                                         size:indixesBufferDataSize
                                         data:indixesBufferData];
    
    /* 3.1 after the creating of buffers they are stored in GPU is not necessary to keep them */
    free(arrayBufferData);
    free(indixesBufferData);
    
}

- (void) draw {
    
    [self enable];
    
    glDrawElements(GL_TRIANGLES,count, GL_UNSIGNED_SHORT, (void*)0);

    [self disable];
    
}


@end

@implementation ProgramGradiateCircle

- (void) enable {
    
    glEnable(GL_BLEND);
    
    [super enable];
    
}

- (void) disable {
    
    [super disable];
    
    glDisable(GL_BLEND);
    
    
}


@end

@implementation ProgramNone
@end

@implementation ProgramGradiateLinear

- (void) enable {
    
    glEnable(GL_BLEND);
    
    [super enable];
    
}

- (void) disable {
    
    [super disable];
    
    glDisable(GL_BLEND);
    
    
}

@end