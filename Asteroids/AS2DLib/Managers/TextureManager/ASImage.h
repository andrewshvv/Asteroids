//
//  ASImage.h
//  OpenGLTest
//
//  Created by Наталья Дидковская on 29.08.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASTexture2D.h"

/* Composite Pattern */
@protocol ASImageNode <NSObject>

@property ASTexture2D *texture;

@property NSString *name;

@property CGFloat width;
@property CGFloat height;

- (id<ASImageNode>) image:(NSString *)name;

@end


#pragma mark -
#pragma mark Composite
@interface ASCompositeImage : NSObject <ASImageNode>

@property NSMutableArray *nodes;

- (id)initWidth:(CGFloat) w
         height:(CGFloat) h
           name:(NSString*) name
        texture:(ASTexture2D*) texture;


@end


#pragma mark -
#pragma mark Leaf
@interface ASImage : NSObject <ASImageNode>


- (id)initWidth:(CGFloat) w
         height:(CGFloat) h
           name:(NSString*) name
        texture:(ASTexture2D*) texture;

@end
