//
//  Packer.m
//  OpenGLTest
//
//  Created by Наталья Дидковская on 05.08.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import "Packer.h"


@implementation Node

- (id)initWithWidth:(CGFloat) w heiht:(CGFloat) h x:(CGFloat)x y:(CGFloat)y right:(Node*) r down:(Node*) d used:(BOOL) u
{
    self = [super init];
    if (self) {
        
        _rect.origin.x = x;
        _rect.origin.y = y;
        
        _rect.size.height = h;
        _rect.size.width = w;
        
        _used = u;
        
        _right = r;
        _down =  d;
        
    }
    return self;
}


- (id)initWithWidth:(CGFloat) w heiht:(CGFloat) h x:(CGFloat)x y:(CGFloat)y
{
    
    return [self initWithWidth:w heiht:h x:x y:y right:nil down:nil used:NO];
    
}

+ (Node*) weight:(CGFloat) w height:(CGFloat) h x:(CGFloat) x y:(CGFloat) y {
    
    return [[Node alloc] initWithWidth:w heiht:h x:x y:y];
    
}
+ (Node*) weight:(CGFloat) w height:(CGFloat) h x:(CGFloat) x y:(CGFloat) y right:(Node*) r down:(Node*) d used:(BOOL) u{
    
    return [[Node alloc] initWithWidth:w heiht:h x:x y:y right:r down:d used:u];
    
}


@end

@implementation Block

- (id)initWithWidth:(CGFloat) w height:(CGFloat) h index:(int) index 
{
    self = [super init];
    if (self) {
        
        _w = w;
        _h = h;
        _index = index;
        
    }
    return self;
}

@end

@implementation Packer
static Node* _root;

+ (CGFloat) width {
    
    return _root.rect.size.width;
    
}
+ (CGFloat) height {

    return _root.rect.size.height;
    
}

+ (Block*) blockAtIndex:(int) index blocks:(NSArray*) blocks{
    
    for (Block *b in blocks) {
        
        if(b.index == index){
            
            return b;
            
        }
    }
    
    return nil;
    
}
+ (NSArray*) packedBlocks:(NSArray*) rectangles {
    
    NSArray *blocks = [Packer sort:[Packer wrap:rectangles]];
    
    
    Block *block = [blocks objectAtIndex:0];
    
    CGFloat allowableHeight = [Packer allowableNumber:block.h];
    CGFloat allowableWidth = [Packer allowableNumber:block.w];
    
    _root = [Node weight: allowableWidth
                  height: allowableHeight
                       x:0
                       y:0 ];
    
    [Packer fit:blocks];
    
    return [Packer unwrap:blocks];
    
}

+ (NSArray*) sort:(NSArray*) blocks {
    

    return [blocks sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        Block* b1 = (Block*)obj1;
        Block* b2 = (Block*)obj2;
        
        if( (b1.w * b1.h) > (b2.w * b2.h)){
            
            return NSOrderedAscending;
            
        } else if ((b1.w * b1.h) < (b2.w * b2.h)) {
            
            return NSOrderedDescending;
            
        } else {
            
            return NSOrderedSame;
        
        }
    }];
}

+ (NSArray*) wrap:(NSArray*) objects {
    
    NSMutableArray *blocks = [NSMutableArray array];
    
    int i = 0;
    for (NSValue *v in objects) {
        
        CGRect rect = [v CGRectValue];
        
        [blocks addObject:[[Block alloc] initWithWidth:rect.size.width
                                                height:rect.size.height
                                                index:i]];
        
        i++;
        
    }
    
    return blocks;

}

+ (NSArray*) unwrap :(NSArray*) blocks {
    
    NSMutableArray *objects = [NSMutableArray array];
    
    for (int i = 0; i < [blocks count]; i++) {
        
        Block *block = [Packer blockAtIndex:i blocks:blocks];
        
        CGRect rect = CGRectMake(block.fit.rect.origin.x, block.fit.rect.origin.y, block.w, block.h);
        [objects addObject:[NSValue valueWithCGRect:rect]];
        
        
    }
    
    return objects;
    
    
    
}
+ (void) fit:(NSArray *)blocks {
    
    for (Block *block in blocks) {
        
        Node *node;
        if((node = [Packer findNode: _root width: block.w height: block.h]) != nil){
            
            block.fit = [Packer splitNode:node
                                    width:block.w
                                   height:block.h];
            
        } else {
            
            block.fit = [Packer growNodeWidth:block.w height:block.h];
            
        }
    }
}

+ (Node*) splitNode:(Node*) node width:(CGFloat) w height:(CGFloat) h {
    
    CGFloat node_x = node.rect.origin.x;
    CGFloat node_y = node.rect.origin.y;
    CGFloat node_w = node.rect.size.width;
    CGFloat node_h = node.rect.size.height;
    
    node.used = YES;
    node.down = [Node weight: node_w
                      height: node_h - h
                           x: node_x
                           y: node_y + h  ];
    
    node.right = [Node weight: node_w - w
                       height: h
                            x: node_x + w
                            y: node_y     ];
    
    return node;
    
}


+ (Node*) findNode:(Node*) root width:(CGFloat) w height:(CGFloat) h {
    
    if(root.used){
        
        Node *returnNode = [self findNode:root.right width:w height:h];
        if(returnNode) {
            
            return returnNode;
            
        }else {
         
            return [self findNode:root.down width:w height:h];
        }
    }
    
    else if((h <= root.rect.size.height) && (w <= root.rect.size.width)){
        
        return root;
        
    } else {
        
        return nil;
        
    }
}

+ (Node*) growNodeWidth:(CGFloat) w height:(CGFloat) h {
    
    CGFloat root_w = _root.rect.size.width;
    CGFloat root_h = _root.rect.size.height;
    
    BOOL canGrowDown  = (w <= root_w);
    BOOL canGrowRight = (h <= root_h);
    
    BOOL shouldGrowRight = canGrowRight && (root_h >= (root_w + w));
    BOOL shouldGrowDown  = canGrowDown  && (root_w >= (root_h + h));
    
    if (shouldGrowRight)
        
        return [Packer growRightWidth:w height:h];
    
    else if (shouldGrowDown)
        
        return [Packer growDownWidth:w height:h];
    
    else if (canGrowRight)
        
        return [Packer growRightWidth:w height:h];
    
    else if (canGrowDown)
        
        return [Packer growDownWidth:w height:h];
    
    else
        
        return nil;

}
/* Допустимая ширина и высота текстуры в OpenGL должна быть кратна 2-ке */
+ (GLfloat) allowableNumber:(GLfloat) number {
    
    int allowableNumber = 1;
    while (number > allowableNumber) {
        
        allowableNumber *= 2;
        
    };
    
    return allowableNumber;
    
}

+ (Node*) growRightWidth:(CGFloat) w height:(CGFloat) h {
    
    CGFloat root_w = _root.rect.size.width;
    
    CGFloat allowableWidth = [Packer allowableNumber:root_w + w];
    [self changeWidth:allowableWidth - root_w root:_root rootWidth:_root.rect.size.width];
    
    Node *node;
    if ((node = [Packer findNode:_root width:w height:h]))
        
        return [Packer splitNode:node width:w height:h ];
    
    else
        
        return nil;
    
}

+ (Node*) growDownWidth:(CGFloat) w height:(CGFloat) h {
    
    CGFloat root_h = _root.rect.size.height;
    
    CGFloat allowableHeight = [Packer allowableNumber:root_h + h];

    [self changeHeight:allowableHeight - root_h root:_root rootHeight:_root.rect.size.height];
    
    Node *node;
    if ((node = [Packer findNode:_root width:w height:h]))
        
        return [Packer splitNode:node width:w height:h ];
    
    else
        
        return nil;
    
}

+ (void) changeWidth:(CGFloat) width root:(Node*) root rootWidth:(CGFloat) _rootWidth{
 
    CGFloat x = root.rect.origin.x;
    CGFloat y = root.rect.origin.y;
    
    CGFloat w = root.rect.size.width;
    CGFloat h = root.rect.size.height;
    
    root.rect = CGRectMake(x, y, w + width, h);
    
    if(root.used){
        
        [self changeWidth:width root:root.down rootWidth:_rootWidth];

        [self changeWidth:width root:root.right rootWidth:_rootWidth];
        
    }
}

+ (void) changeHeight:(CGFloat) height root:(Node*)root rootHeight:(CGFloat) _rootHeight{
    
    CGFloat x = root.rect.origin.x;
    CGFloat y = root.rect.origin.y;
    
    CGFloat w = root.rect.size.width;
    CGFloat h = root.rect.size.height;
    
    root.rect = CGRectMake(x, y, w , h + height);
    
    if(root.used){
    
        [self changeHeight:height root:root.down rootHeight:_rootHeight];
        
    }
}



@end
