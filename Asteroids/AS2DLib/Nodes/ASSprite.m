//
//  GameObject.m
//  OpenGLTest
//
//  Created by Наталья Дидковская on 16.07.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import "ASSprite.h"

#import "Pair.h"
#import "ASAnimation.h"

#import "ASBufferManager.h"


#import "ASLayer.h"

@implementation ASComposite

@synthesize hidden;
@synthesize pause;

- (id)init
{
    self = [super init];
    if (self) {
    
        
        _nodes = [NSMutableArray array];
        
        
    }
    return self;
}

- (void)addNode:(id<ASNode>) node
{
    
    if(!self.isPaused){
        
        @synchronized(_nodes){
            
            [_nodes addObject:node];
            
            [node setHidden:self.isHidden];
            
        }
    }
}

- (void) removeNode:(id<ASNode>) node {
    
    if(!self.isPaused){
        
        @synchronized(_nodes){
    
            [_nodes removeObject:node];
            
        
        }
    }
    
}

- (void) drain {
    
    [_nodes removeAllObjects];
    
}

- (void) update:(CFTimeInterval)dt {
    
    if(!self.isPaused){
        
        for (id<ASNode> node in _nodes) {
            
            [node update:dt];
        }
    }
}

- (void) setHidden:(BOOL) isHidden {
    
    for (id<ASNode> node in _nodes) {
        
        [node setHidden: isHidden];
        
    }
}

- (BOOL) isHidden {
    
    return hidden;
    
}

- (BOOL) isPaused {

    return pause;
    
}

- (void) setPause:(BOOL) isPaused {
    
    for (id<ASNode> node in _nodes) {
        
        [node setPause:isPaused];
        
    }
    
}

- (void) translateWithVector:(ASVector *)vector {
 
    for (id<ASNode> node in _nodes) {
        
        [node translateWithVector:vector];
        
    }
    
}

@end

@implementation ASActionHandler

- (id)initWitTarget:(NSObject*) target
{
    self = [super init];
    if (self) {
        
        _actions = [NSMutableArray array];
        _removeArray = [NSMutableArray array];
        _target = target;
        
    }
    return self;
}

- (void) handleActions:(CFTimeInterval)dt {
    
    for (ASAction *action in _actions) {
        
        if(!action.finish){
            
            [action actionWithTarget:_target interval:dt];
            
        } else {
            
            [_removeArray addObject:action];
            [action finish:_target];
            
        }
    }
    
    [_actions removeObjectsInArray:_removeArray];
    [_removeArray removeAllObjects];
}

- (BOOL) doAction:(ASAction *) newAction {
    
    /*  looking for action the same type  */
    ASAction *removeAction = nil;
    for (ASAction *action in _actions) {
        
        if(action.type == newAction.type){
            
            removeAction = action;
            break;
            
        }
    }
    
    /* if found remove them */
    if(removeAction != nil){
        
        [_actions removeObject:removeAction];
        
    }


    /*  check target for the valid (conforms to protocol) */
    if([newAction valid:_target]){
        
        [_actions addObject:newAction];
        
        [newAction start:_target];
        
        return YES;
        
    } else {
        
        return NO;
        
    }
}

@end


@implementation ASSprite

@synthesize pause = _pause;
@synthesize hidden = _hidden;

- (id) copyWithZone:(NSZone *)zone {
    
    ASSprite *sprite = [[ASSprite allocWithZone:zone] init];
    sprite.hidden = self.isHidden;
    sprite.pause = self.isPaused;
    sprite.shape = [_shape copy];
    sprite.image = _image;
    
    return sprite;
    
}

- (id) initWithImagePath:(NSString*) fileName type:(int) type center:(CGPoint) center {
    
    self = [super init];
    
    if(self){
        
        _hidden = YES;
        _pause = YES;
        
        _actionHandler = [[ASActionHandler alloc] initWitTarget:self];
        _image = [[ASTextureManager textureManager] returnImage:fileName];
        
        if(!_image){
            
            NSException *e = [NSException exceptionWithName:@"Image Error" reason:@"Not Found" userInfo:nil];
            @throw e;
            
        }
        
        _shape = [ASShape shapeWithWidth:_image.width height:_image.height type:type];

        
        [_shape applyImage:_image];
        
        [self setAnimation:[[NoneAnimation alloc] init]];
        
        [_shape setCenter:center];

        
    }

    
    return self;
}
+ (id)spriteWithName:(NSString *)pathToImage shape:(int) type{
    
    return [[self alloc] initWithImagePath: pathToImage type:type center:CGPointMake(0, 0)];
    
}

+ (id)spriteWithName:(NSString *)pathToImage {
    
    return [[self alloc] initWithImagePath: pathToImage type:SQUARE center:CGPointMake(0, 0)];
    
}

+ (id)spriteWithName:(NSString *)pathToImage center:(CGPoint) center {
    
    return [[self alloc] initWithImagePath: pathToImage type:SQUARE center:center];
    
}

- (void) doAction:(ASAction*) action
{
    
    [_actionHandler doAction:action];
    
}

- (void) setPosition:(CGPoint)position { _shape.position = position; }
- (CGPoint) position { return _shape.position; }

- (void) setCenter:(CGPoint)center { _shape.center = center; }
- (CGPoint) center { return  _shape.center; }

- (void) setAngel:(CGFloat)angel { _shape.angel = angel; }
- (CGFloat) angel { return _shape.angel; }

- (CGFloat) width { return  _shape.width; }
- (CGFloat) height { return _shape.height; }


- (void) setImage:(ASImage *)image {
    
    _image = image;
    
    [_shape applyImage:_image];
    
}

- (void) translateWithVector:(ASVector *)vector {
    
    NSArray *points = _shape.points;
    for (AS5Point *point in points) {
        
        point->x += vector->x;
        point->y += vector->y;
        
    }
}



- (void) update:(CFTimeInterval)dt {
        
    [_actionHandler handleActions:dt];
    [_animation update];
    
}


- (void) setAnimation:(ASAnimation*) animation {
    
    [animation wrap:self];
    
    _animation = animation;
    
}

- (void) removeAnimation {
    
    _animation = nil;

}


@end

@implementation ASTailSprite

- (id)initWithSprite:(ASSprite*) sprite
          tailLenght:(int) lenght
         startRadius:(CGFloat) sradius
        finishRadius:(CGFloat) fradius
               alpha:(CGFloat) alpha
{
    self = [super init];
    if (self) {
        
        _actionHandler = [[ASActionHandler alloc] initWitTarget:self];
        _sprite = sprite;
        
        CGFloat step = (fradius - sradius) / (lenght + 1);
        CGFloat textureRadius = fradius;
        
        GradientCircle *gc = [GradientCircle animationStartRadius:sradius
                                                     finishRadius:textureRadius
                                                            alpha:alpha];
        
        [self addNode:sprite];
        [sprite setAnimation:gc];
        
        textureRadius -= step;
        for (int i = 0; i < lenght; i++) {
            
            
            gc = [GradientCircle animationStartRadius:sradius finishRadius:textureRadius alpha:alpha];
            textureRadius -= step;
            
            ASSprite *tailSprite = [sprite copy];;
            
            [tailSprite setAnimation:gc];
            
            [self addNode:tailSprite];
            
            
        }
    }
    
    return self;
}

+ (ASTailSprite*) tailSpriteWithSprite:(ASSprite*) sprite
                           startRadius:(CGFloat)sradius
                          finishRadius:(CGFloat)fradius
                                lenght:(int)lenght
                                 alpha:(CGFloat)alpha
{
    
    return [[ASTailSprite alloc] initWithSprite:sprite
                                     tailLenght:lenght
                                    startRadius:sradius
                                   finishRadius:fradius
                                          alpha:alpha];
    
}


- (void) update:(CFTimeInterval)dt {
    
    [_actionHandler handleActions:dt];
    [super update:dt];
    
}

- (void) doAction:(ASAction*) action
{
    
    [_actionHandler doAction:action];
    
}


- (void) setPosition:(CGPoint) thePosition {
    
    CGPoint nextPosition = thePosition;
    CGPoint position;
    
    NSEnumerator *tailEnumerator = [self.nodes objectEnumerator];
    
    for (ASSprite *sprite in tailEnumerator) {
        
        position = sprite.position;
        [sprite setPosition:nextPosition];
        nextPosition = position;
        
    }
    
}


- (void) setCenter:(CGPoint) theCenter {
    
    CGPoint nextCenter = theCenter;
    CGPoint center;
    
    NSEnumerator *tailEnumerator = [self.nodes objectEnumerator];
    
    for (ASSprite *sprite in tailEnumerator) {
        
        center = sprite.center;
        [sprite setCenter:nextCenter];
        nextCenter = center;
        
    }
    
}

- (void) setAngel:(CGFloat)theAngel {
    
    CGFloat nextAngel = theAngel;
    CGFloat angel;
    
    NSEnumerator *tailEnumerator = [self.nodes objectEnumerator];
    
    for (ASSprite *sprite in tailEnumerator) {
        
        angel = sprite.angel;
        [sprite setAngel:nextAngel];
        nextAngel = angel;
        
        
        
    }
}

- (CGPoint) position { return _sprite.position; }
- (CGPoint) center { return _sprite.center; }
- (CGFloat) width { return _sprite.width; }
- (CGFloat) height { return _sprite.height; }
- (CGFloat) angel {  return _sprite.angel; }

@end


@implementation ASCompositeSprite

- (id)initWithGeneralSprite:(ASSprite*) sprite
{
    self = [super init];
    if (self) {
        
        _generalSprite = sprite;
        _actionHandler = [[ASActionHandler alloc] initWitTarget:self];
        
        [self addNode:_generalSprite];
        
    }
    return self;
}

+ (ASCompositeSprite*) compositeSpriteWithGeneralSprite:(ASSprite*) sprite
{
    
    return [[ASCompositeSprite alloc] initWithGeneralSprite:sprite ];
    
}

- (void) doAction:(ASAction*) action
{

    [_actionHandler doAction:action];
    
}

- (void) update:(CFTimeInterval)dt {
    
    [_actionHandler handleActions:dt];
    
    [super update:dt];
}

- (void) addNode:(id<ASNode>) node translationVector:(ASVector*) vector
{
    
    [self addNode:node];
    [node translateWithVector:vector];
    
    
}

- (void) setPosition:(CGPoint) thePosition {
    
    NSEnumerator *spritesEnumerator = [self.nodes objectEnumerator];
    
    for (ASSprite *sprite in spritesEnumerator) {
        
        [sprite setPosition:thePosition];

        
    }
    
}


- (void) setCenter:(CGPoint) theCenter {
    
    NSEnumerator *spritesEnumerator = [self.nodes objectEnumerator];
    
    for (ASSprite *sprite in spritesEnumerator) {
        
        [sprite setCenter:theCenter];
        
    }
}


- (void) setAngel:(CGFloat) angel {
    
    NSEnumerator *spritesEnumerator = [self.nodes objectEnumerator];
    
    for (id<ASGameObject> object in spritesEnumerator) {
        
        [object setAngel:angel];
        
    }
}

- (CGFloat) angel { return _generalSprite.angel; }
- (CGPoint) position { return _generalSprite.position; }
- (CGPoint) center { return _generalSprite.center; }

@end
