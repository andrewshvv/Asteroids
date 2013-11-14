//
//  GameObject.h
//  OpenGLTest
//
//  Created by Наталья Дидковская on 16.07.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASTextureManager.h"
#import "ASShape.h"
#import "ASAction.h"


@protocol ASNode <NSObject>

@property (nonatomic,getter = isPaused) BOOL pause;
@property (nonatomic,getter = isHidden) BOOL hidden;

- (void) update:(CFTimeInterval) dt;
- (void) translateWithVector:(ASVector*) vector;

@end

@interface ASComposite : NSObject <ASNode> {
    
    dispatch_queue_t _node_queue;
    dispatch_group_t _node_group;
    
    @public
    
    BOOL pause;
    BOOL hidden;
}

@property NSMutableArray *nodes;


- (void) addNode:(id<ASNode>) node;
- (void) removeNode:(id<ASNode>) node;
- (void) update:(CFTimeInterval)dt;

@end


@protocol ASGameObject <NSObject>

- (void) setPosition:(CGPoint) position;
- (CGPoint) position;

- (void) setCenter:(CGPoint) center;
- (CGPoint) center;

- (void) setAngel:(CGFloat) angel;
- (CGFloat) angel;

- (CGFloat) width;
- (CGFloat) height;


@end

@interface ASActionHandler : NSObject {
    
    NSMutableArray *_actions;
    NSMutableArray *_removeArray;
    __weak NSObject *_target;
    
}

- (void) handleActions:(CFTimeInterval) dt;
- (BOOL) doAction:(ASAction*) action;
//- (BOOL) removeAction:(int) type;

@end

@interface ASSprite : NSObject <ASNode,ASGameObject> {
    
    ASActionHandler *_actionHandler;
    
}

@property ASShape *shape;
@property (nonatomic) ASImage *image;

@property (nonatomic) ASAnimation *animation;

+ (id)spriteWithName:(NSString *)pathToImage ;
+ (id)spriteWithName:(NSString *)pathToImage center:(CGPoint) center;
+ (id)spriteWithName:(NSString *)pathToImage shape:(int) type;

- (void) doAction:(ASAction*) action;


@end

@interface ASTailSprite : ASComposite <ASGameObject> {
    
    ASSprite *_sprite;
    ASActionHandler *_actionHandler;
    
}

+ (ASTailSprite*) tailSpriteWithSprite:(ASSprite*) sprite
                           startRadius:(CGFloat) sradius
                          finishRadius:(CGFloat) fradius
                                lenght:(int) lenght
                                 alpha:(CGFloat) alpha;

- (void) doAction:(ASAction*) action;

@end

@interface ASCompositeSprite : ASComposite <ASGameObject> {
    
    __weak ASSprite *_generalSprite;
    
    ASActionHandler *_actionHandler;
    
}

+ (ASCompositeSprite*) compositeSpriteWithGeneralSprite:(ASSprite*) sprite;


- (void) doAction:(ASAction*) action;
- (void) addNode:(id<ASNode>) node translationVector:(ASVector*) vector;


@end
