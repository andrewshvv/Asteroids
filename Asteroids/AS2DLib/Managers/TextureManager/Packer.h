//
//  Packer.h
//  OpenGLTest
//
//  Created by Наталья Дидковская on 05.08.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import <Foundation/Foundation.h>

/* used in order to properly pack texture */
@interface Packer : NSObject

+ (CGFloat) width;
+ (CGFloat) height;

+ (NSArray*) packedBlocks:(NSArray*) rectangles;


@end


@interface Node : NSObject

@property BOOL used;

@property Node *right;
@property Node *down;

@property CGRect rect;

+ (Node*) weight:(CGFloat) w height:(CGFloat) h x:(CGFloat) x y:(CGFloat) y ;
+ (Node*) weight:(CGFloat) w height:(CGFloat) h x:(CGFloat) x y:(CGFloat) y right:(Node*) r down:(Node*) d used:(BOOL) u;

@end

@interface Block : NSObject

@property Node *fit;
@property CGFloat w;
@property CGFloat h;
@property int index;

- (id)initWithWidth:(CGFloat) w height:(CGFloat) h index:(int) index;

@end

