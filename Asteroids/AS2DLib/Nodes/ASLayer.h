//
//  Layer.h
//  OpenGLTest
//
//  Created by Наталья Дидковская on 15.07.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASLayerManager.h"
#import "World.h"

#import "ASSprite.h"
#import "ASButton.h"


@class GLView;

@interface ASLayer : ASComposite  {
    
    CGFloat z;
    NSMutableArray *_removedObjects;
    
}

    @property   GLView* glView;
    @property   NSMutableArray *subviews;

- (void) addButton:(Item*) button;

@end


