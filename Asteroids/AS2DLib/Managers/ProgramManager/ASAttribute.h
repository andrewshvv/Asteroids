//
//  ASAtribute.h
//  OpenGLTest
//
//  Created by Наталья Дидковская on 18.09.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import <Foundation/Foundation.h>



/* ASAttribute represent shader attributs */
@interface ASAttribute : NSObject <NSCopying> {
    
    @public
    
    int size;
    int offset;
    
    GLuint loc;
    
    CGFloat* data;
    
}

+ (ASAttribute*) attributeWithSize:(int)size ;

@end
