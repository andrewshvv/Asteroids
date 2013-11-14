//
//  ASAtribute.m
//  OpenGLTest
//
//  Created by Наталья Дидковская on 18.09.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import "ASAttribute.h"

@implementation ASAttribute

- (id) copyWithZone:(NSZone *)zone {
    
    ASAttribute *copy = [[ASAttribute alloc] init];
    
    copy->size = size;
    copy->offset = offset;
    
    return copy;
    
}

- (id)initWithSize:(int)theSize
{
    self = [super init];
    if (self) {
        
        offset = 0;
        size = theSize;
        
    }
    return self;
}

+ (ASAttribute*) attributeWithSize:(int)size
{
    
    return [[ASAttribute alloc] initWithSize:size];
    
}

@end

