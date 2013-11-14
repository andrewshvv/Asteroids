//
//  RepeateLayer.m
//  OpenGLTest
//
//  Created by Наталья Дидковская on 05.11.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import "RepeatLayer.h"


@implementation RepeatLayer

- (id)init
{
    self = [super init];
    if (self) {
        
        CGFloat width = [[ASLayerManager layerManager] width];
        CGFloat height = [[ASLayerManager layerManager] height];
        
        _again = [TextLabel labelWithString:@"Again?" position:CGPointMake(width/2- 75, height/2 - 50)];
        
//        _no = [ASButton buttonWithImage:@"no.png"];
        _yes = [ASButton buttonWithImage:@"yes.png"];
        
//        [_no setPosition:CGPointMake(width/2 , height/2)];
        [_yes setPosition:CGPointMake(width/2 - 50, height/2 )];
        
        [self addButton:_again];
        [self addButton:_yes];
//        [self addButton:_no];
        
        
        
    }
    return self;
}

@end
