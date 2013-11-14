//
//  ASImage.m
//  OpenGLTest
//
//  Created by Наталья Дидковская on 29.08.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import "ASImage.h"


#pragma mark -
#pragma mark Composite
@implementation ASCompositeImage

@synthesize texture = _texture;
@synthesize name = _name;

@synthesize width = _width;
@synthesize height = _height;


- (id)initWidth:(CGFloat) w
         height:(CGFloat) h
           name:(NSString*) name
        texture:(ASTexture2D*) texture
{
    self = [super init];
    if (self) {
        
        _nodes = [NSMutableArray array];
        
        self.width = w;
        self.height = h;
        self.name = name;
        self.texture = texture;
        
    }
    return self;
}

- (id<ASImageNode>) image:(NSString *)name
{
    
    if([name isEqualToString:self.name]){
        
        return self;
        
    }
    
    id<ASImageNode> findNode = nil;
    for (id<ASImageNode> node in self.nodes) {
        
        findNode =  [node image:name];
        
        if(findNode){
            
            return findNode;
            
        }
    }
    
    return nil;
}

@end

#pragma mark -
#pragma mark Leaf
@implementation ASImage

@synthesize texture = _texture;
@synthesize name = _name;

@synthesize width = _width;
@synthesize height = _height;

- (id)initWidth:(CGFloat) w
         height:(CGFloat) h
           name:(NSString*) name
        texture:(ASTexture2D*) texture
{
    self = [super init];
    if (self) {
        
        self.width = w;
        self.height = h;
        self.name = name;
        self.texture = texture;
        
    }
    return self;
}

- (id<ASImageNode>) image:(NSString *)name {
    
    if([name isEqualToString:self.name]){
        
        return self;
        
    }
    
    return nil;
    
}

@end

