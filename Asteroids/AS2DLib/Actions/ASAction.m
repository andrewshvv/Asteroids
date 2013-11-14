//
//  Action.m
//  OpenGLTest
//
//  Created by Наталья Дидковская on 15.07.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import "ASAction.h"
#import "Action_Private.h"

#import "ASTextureManager.h"
#import "ASAnimation.h"
#import "Pair.h"

#import "ASSprite.h"


@implementation ASAction

- (id)init
{
    self = [super init];
    if (self) {
        
        _finish = NO;
        _pause = NO;
        
    }
    return self;
}

- (id) copyWithZone:(NSZone *)zone {
    
    ASAction *copy = [[[self class] allocWithZone:zone] init];
    
    copy.finish = self.isFinished;
    copy.pause = self.isPaused;
    copy.finishBlock = self.finishBlock;
    copy.type = self.type;
    
    return copy;
    
}
- (BOOL) valid:(NSObject *)target {
    
    @throw [NSException exceptionWithName:@"Action Implementation" reason:@"Implement method \"valid:\" " userInfo:nil];
}

- (void) start:(NSObject*) target {
    
    @throw [NSException exceptionWithName:@"Action Implementation" reason:@"Implement method \"start:\" " userInfo:nil];
    
}
- (void) finish:(NSObject *)target {
    
    @throw [NSException exceptionWithName:@"Action Implementation" reason:@"Implement method \"finish:\" " userInfo:nil];
    
}

- (void) actionWithTarget:(NSObject *) target interval:(CFTimeInterval)interval {
    
    @throw [NSException exceptionWithName:@"Action Implementation" reason:@"Implement method  \"actionWithTarget:\" " userInfo:nil];
    
}

@end


#pragma mark -
#pragma mark Move
@implementation Move

- (id)initWithDuration:(CFTimeInterval) time position:(CGPoint) point finishBlock:(FinishBlock) finishBlock
{
    self = [super init];
    if (self) {
        
        self.finishBlock = finishBlock;
        
        _point = point;
        _time = time;
        self.type = MOVE;
        
    }
    return self;
}

+ (Move*) actionWithTime:(CFTimeInterval)time position:(CGPoint)position {
    
    return [[Move alloc] initWithDuration:time position:position finishBlock:nil];
    
}

+ (Move*) actionWithTime:(CFTimeInterval)time position:(CGPoint)position finishBlock:(FinishBlock)finishBlock {
    
    return [[Move alloc] initWithDuration:time position:position finishBlock:finishBlock];
}

- (void) start:(id<ASGameObject>) target {
    
    CGPoint targetPosition = target.center;
    
    _vX = (_point.x - targetPosition.x)/_time;
    _vY = (_point.y - targetPosition.y)/_time;
    
}

- (void) finish:(id<ASGameObject>) target {
    
    self.finishBlock();
    
}

- (BOOL) valid:(NSObject *)target {
    
    return [target conformsToProtocol:@protocol(ASGameObject)];
    
}

- (void) actionWithTarget:(id<ASGameObject>)target interval:(CFTimeInterval)interval
{
    CGPoint spritePoint = target.center;
    CGPoint nextPoint = CGPointMake(spritePoint.x + _vX * interval, spritePoint.y + _vY * interval);
    
    if( (abs(nextPoint.x) > abs(_point.x) ) || (abs(nextPoint.y) > abs(_point.y)) ){
        
        target.center = _point;
        
        self.finish = YES;
        
        
        
        return;
        
    }
    
    target.center = nextPoint;

}

@end

#pragma mark -
#pragma mark DirectionMove
@implementation DirectionMove

- (id)initWithVelocity:(CGFloat) velocity direction:(ASVector*) direction
{
    self = [super init];
    if (self) {
        
        _direction = direction;
        _velocity = velocity;
        self.type = DIRECTION_MOVE;
        
    }
    return self;
}
+ (DirectionMove*) actionWithVelocity:(CGFloat) velocity direction:(ASVector*) direction {
    
    return [[DirectionMove alloc] initWithVelocity:velocity direction:direction];
    
}

- (id) copyWithZone:(NSZone *)zone {
    
    DirectionMove *copy = [super copyWithZone:zone];
    
    copy.direction = self.direction;
    copy.velocity = self.velocity;
    
    return copy;
}

- (void) finish:(ASSprite *)sprite {
    
    
}

- (void) start:(ASSprite *)gameObject
{
    
    CGFloat cos;
    CGFloat sin;
    
    CGFloat lenght = [_direction lenght];
    if(lenght != 0){
        
        cos = _direction->x  / lenght;
        sin = _direction->y  / lenght;
        
    } else {
        
        cos = 0;
        sin = 0;
        
    }
    
    _vX = _velocity*cos;
    _vY = _velocity*sin;
    
}

- (BOOL) valid:(NSObject *)target {
    
    return [target conformsToProtocol:@protocol(ASGameObject)];
    
}

- (void) setVelocity:(CGFloat) velocity {
    
    _velocity = velocity;
    
    CGFloat cos;
    CGFloat sin;
    
    CGFloat lenght = [_direction lenght];
    if(lenght != 0){
        
        cos = _direction->x  / lenght;
        sin = _direction->y  / lenght;
        
    } else {
        
        cos = 0;
        sin = 0;
        
    }
    
    _vX = _velocity*cos;
    _vY = _velocity*sin;
    
}
- (void) actionWithTarget:(id<ASGameObject>)target interval:(CFTimeInterval)interval {
    
    CGPoint spritePoint = target.center;
    CGPoint nextPoint = CGPointMake(spritePoint.x + _vX * interval, spritePoint.y + _vY * interval);
    
    target.center = nextPoint;
    
}

@end

#pragma mark -
#pragma mark DirectionRotation

@implementation DirectionRotation

- (id)initWithRotationVelocity:(CGFloat) wA
{
    self = [super init];
    if (self) {
        
        _wA = wA;
        
    }
    return self;
}

+(DirectionRotation*) actionWithRotationVelocity:(CGFloat) wA
{
    
    return [[DirectionRotation alloc] initWithRotationVelocity:wA];
    
}

- (BOOL) valid:(NSObject *)target {
    
    return [target conformsToProtocol:@protocol(ASGameObject)];
    
}

- (void) finish:(ASSprite *)sprite {
    
    
}

- (void) start:(ASSprite *)gameObject
{
    
}

- (void) setRotationVelocity:(CGFloat) wA {
    
    _wA = wA;

}
- (void) actionWithTarget:(id<ASGameObject>)target interval:(CFTimeInterval)interval {
    
    [target setAngel:target.angel + _wA*interval];
    
    if(target.angel > 360){
        
        target.angel = target.angel - 360;
        
    }
    
    if(target.angel < 0){
        
        target.angel =  360 - target.angel;
        
    }
    
    
    
}


@end

#pragma mark -
#pragma mark Frame
@implementation Frame

- (id)initWithTime:(CFTimeInterval)time
        withFrames:(NSArray *)framesNames
              loop:(BOOL) shouldLoop
          inverted:(BOOL) shouldInverted
       finishBlock:(FinishBlock) block
{
    self = [super init];
    if (self) {
        
        self.finishBlock = block;
        
        _frames = [NSMutableArray array];
        _shouldInverted = shouldInverted;
        
        for (NSString *frameName in framesNames) {
            
            ASImage *image = [[ASTextureManager textureManager] returnImage:frameName];
            
            
            if(image){
                
                [_frames addObject:image];
                
            } else {
                
                NSLog(@"Can't find texture");
                return nil;
                
            }
        }
        
        _loop = shouldLoop;
        
        _dt = time / [framesNames count];
        
        _allInterval = _dt;
        _textureEnumerator = [_frames objectEnumerator];
        
        self.type = FRAME;
        
        
    }
    return self;
}

- (id) copyWithZone:(NSZone *)zone {
    
    Frame *copy = [super copyWithZone:zone];
    
    copy.shouldInverted = self.shouldInverted;
    copy.loop = self.loop;
    copy.frames = [self.frames  copy];
    copy.beginImage = [self.beginImage copy];
    copy.allInterval = self.allInterval;
    copy.textureEnumerator = [self.textureEnumerator copy];
    
    return copy;
}
+ (Frame*) actionWithTime:(CFTimeInterval)time
               withFrames:(NSArray *)framesNames
                     loop:(BOOL) shouldLoop
                 inverted:(BOOL)shouldInverted {
    
    return [[Frame alloc] initWithTime:time withFrames:framesNames loop:shouldLoop inverted: shouldInverted finishBlock:^(void){}];
}

+ (Frame*) actionWithTime:(CFTimeInterval)time
               withFrames:(NSArray *)framesNames
                     loop:(BOOL) shouldLoop
                 inverted:(BOOL)shouldInverted
              finishBlock: (FinishBlock) block
{
    
    return [[Frame alloc] initWithTime:time withFrames:framesNames loop:shouldLoop inverted:shouldInverted finishBlock:block];
    
}

- (void) start:(ASSprite *)sprite{
    
    for (ASImage *image in _frames) {
        
        image.texture.inverted = _shouldInverted;
        
    }
}

- (void) finish:(ASSprite *)sprite {
    
    for (ASImage *image in _frames) {
        
        image.texture.inverted = NO;
        
    }
    
    self.finishBlock();
}

- (BOOL) valid:(NSObject *)target {
    
    return [target isKindOfClass:[ASSprite class]];
}

- (void) actionWithTarget:(ASSprite *) target interval:(CFTimeInterval)interval {
    
    _allInterval += interval;
    
    if(_allInterval  > _dt){
        
        _allInterval = 0;
        
        ASImage *nextImage = _textureEnumerator.nextObject;
        
//        NSLog(@"INVERTED: %i",nextTexture.inverted);
        if(nextImage == nil){
            
//            NSLog(@"==============");
            if(_loop == YES){
                
                _textureEnumerator = [_frames objectEnumerator];
                
            } else {
                
//                sprite.image = _beginSpriteTexture;
                self.finish = YES;
            }
            
        } else {
            
            target.image = nextImage;
            
        }
    }
}

@end

#pragma mark -
#pragma mark Rotation
@implementation Rotation

- (id)initWithDuration:(CFTimeInterval) time angle:(CGFloat) angle
{
    self = [super init];
    if (self) {
        
        _angle = angle;
        _time = time;
        self.type = ROTATION;
        
    }
    return self;
}

+(Rotation*) actionWithTime:(CFTimeInterval)time angle:(CGFloat) angle {
    
    return [[Rotation alloc] initWithDuration:time angle:angle];
}

- (void) start:(id<ASGameObject>)target {
    
    _wA = (_angle - target.angel)/_time;
    
}
- (void) finish:(id<ASGameObject>)target {
 
    
    
}
- (BOOL) valid:(NSObject *)target {
    
    return [target conformsToProtocol:@protocol(ASGameObject)];
    
}

- (void) actionWithTarget:(id<ASGameObject>)target interval:(CFTimeInterval)interval;
{

    CGFloat nextAngle = target.angel + _wA * interval;
    
    if( (abs(nextAngle)) > abs(_angle)){
        
        target.angel = _angle;
        self.finish = YES;
        
        return;
        
    }
    
    target.angel = nextAngle;
    
}
@end

#pragma mark -
#pragma mark Degradation
@implementation Degradation

- (id)initWithTime:(CFTimeInterval)theTime
  startDegradation:(CGFloat) theStartDegradation
finishDegradation:(CGFloat)theFinishDegradation
            offset:(CGFloat) theOffset

{
    
    self = [super init];
    if (self) {
        
        time = theTime;
        startDegradation = theStartDegradation;
        finishDegradation = theFinishDegradation;
        offset = theOffset;
        velocity = offset/time;
        interval = 0;
        
        self.type = DEGRADATION;
        
    }
    return self;
    
}
+ (Degradation*) actionWithStartDegradation:(CGFloat)startDegradation
                      finishDegradation:(CGFloat)finishDegradation

{
    
    return [[Degradation alloc] initWithTime:0
                            startDegradation:startDegradation
                           finishDegradation:finishDegradation
                                      offset:0];
    
}
+ (Degradation*) actionWithTime:(CFTimeInterval)time
               startDegradation:(CGFloat)startDegradation
             finishDegradation:(CGFloat)finishDegradation
                         offset:(CGFloat) offset
    
{
    
    return [[Degradation alloc] initWithTime:time
                            startDegradation:startDegradation
                          finishDegradation:finishDegradation
                                      offset:offset];
    
}

- (void) start:(ASSprite*) target {
    
    _gl = [GradientLinear animationWithStartDegradation:startDegradation finishDegradation:finishDegradation];
    [target setAnimation:_gl];
    
}

- (void) finish:(ASSprite*) target {
    
    
}

- (BOOL) valid:(NSObject *)target {
    
    return [target isKindOfClass:[ASSprite class]];
    
}

- (void) degradationWithOffset:(CGFloat)theOffset time:(CFTimeInterval) theTime {
    
    offset +=  theOffset ;
    
    time = theTime;
    if(offset > 1.0){
        
        offset = 1.0;
        
    }
    
    if(offset < -1.0){
        
        offset = -1.0;
        
    }
    
    velocity = (offset - passed)/time;
    interval = 0;
    self.pause = NO;
    
    
}

- (void) actionWithTarget:(ASSprite*) target interval:(CFTimeInterval) theInterval{
    
    interval += theInterval;
    
    if(interval > time){
        
        passed = offset;
        
        _gl->startDegradation = startDegradation + offset;
        _gl->finishDegradation = finishDegradation + offset;
        
        self.pause = YES;
        
    } else {
        
//        NSLog(@"==================");
//        NSLog(@"\n offset:%f \n passed:%f \n veclosity:%f \n interval:%f",offset,passed,velocity,interval);
//        NSLog(@"==================");
        passed += velocity*theInterval;
        
        _gl->startDegradation +=  velocity*theInterval;
        _gl->finishDegradation +=  velocity*theInterval;
        
    }
}
@end

#pragma mark -
#pragma mark Pulsation
@implementation Pulsation

- (id)initWithInterval:(CFTimeInterval)time
       fromStartRadius:(CGFloat)fromStartRadius
         toStartRadius:(CGFloat)toStartRadius
      fromFinishRadius:(CGFloat)fromFinishRadius
        toFinishRadius:(CGFloat)toFinishRadius
                 alpha:(CGFloat)alpha
                 count:(int)count
                 pause:(BOOL) pause;
{
    self = [super init];
    if (self) {
        
        _fromStartRadius = fromStartRadius;
        _fromFinishRadius = fromFinishRadius;
        
        _toStartRadius = toStartRadius;
        _toFinishRadius = toFinishRadius;
        
        _count = count;
        _passedPulsation = 0;
        
        _time = time;
        _countTime = _time/(2*_count);
        _interval = 0;
        
        _alpha = alpha;
        
        self.pause = pause;
        
        //так как пульсация - расширение и сужение ,то умножаем на 2
        _startRadiusVelocity = (toStartRadius - fromStartRadius)/_countTime;
        _finishRadiusVelocity = (toFinishRadius - fromFinishRadius)/_countTime;
        
        if(_finishRadiusVelocity < 0) {
            
            _state = EXPANSION;
            
        } else {
            
            _state = CONSTRACTION;
        }
        
        self.type = PULSATION;
    }
    return self;
}

+ (Pulsation*) actionWithInterval:(CFTimeInterval)time
                  fromStartRadius:(CGFloat)fromStartRadius
                    toStartRadius:(CGFloat)toStartRadius
                 fromFinishRadius:(CGFloat)fromFinishRadius
                   toFinishRadius:(CGFloat)toFinishRadius
                            alpha:(CGFloat)alpha
                            count:(int)count {
    
    return [[Pulsation alloc] initWithInterval:time
                               fromStartRadius:fromStartRadius
                                 toStartRadius:toStartRadius
                              fromFinishRadius:fromFinishRadius
                                toFinishRadius:toFinishRadius
                                         alpha:alpha
                                         count:count
                                         pause:NO];
    
}

+ (Pulsation*) actionWithStartRadius:(CGFloat)startRadius
                 finishRadius:(CGFloat)finishRadius
                            alpha:(CGFloat)alpha
 {
    
    return [[Pulsation alloc] initWithInterval:0
                               fromStartRadius:startRadius
                                 toStartRadius:0
                              fromFinishRadius:finishRadius
                                toFinishRadius:0
                                         alpha:alpha
                                         count:0
                                         pause:YES];
    
}

- (void) start:(ASSprite *)sprite {
    
    _gc = [GradientCircle animationStartRadius:_fromStartRadius finishRadius:_fromFinishRadius alpha:_alpha];
    [sprite setAnimation:_gc];
    
}
- (void) finish:(ASSprite *)sprite {
    
    
}

- (BOOL) valid:(NSObject *)target {
    
    return [target isKindOfClass:[ASSprite class]];
    
}
- (void) pulsationToStartRadius:(CGFloat) toStartRadius toFinishRadius:(CGFloat) toFinishRadius time:(CFTimeInterval) time count:(int) count{
    
    _toStartRadius = toStartRadius;
    _toFinishRadius = toFinishRadius;
    
    _count = count;
    _passedPulsation = 0;
    
    _time = time;
    //так как пульсация туда - обратно ,то умножаем на 2
    _countTime = _time/(2*_count);
    _interval = 0;

    _startRadiusVelocity = (_toStartRadius - _fromStartRadius)/_countTime;
    _finishRadiusVelocity = (_toFinishRadius - _fromFinishRadius)/_countTime;
    
    _gc->startRadius  = _toStartRadius;
    _gc->finishRadius = _toFinishRadius;
    
    if(_finishRadiusVelocity < 0) {
        
        _state = EXPANSION;
        
    } else {
        
        _state = CONSTRACTION;
    }
    self.pause = NO;
}
- (void) actionWithTarget:(ASSprite *)sprite interval:(CFTimeInterval)interval {
    
    if(_passedPulsation/2 == _count){
        
        self.pause = YES;
        
    } else {
        
        _interval += interval;
        
        if(_interval > _countTime){
            
            if(_state == EXPANSION) {
                
                _gc->startRadius  = _fromStartRadius;
                _gc->finishRadius = _fromFinishRadius;
                _state = CONSTRACTION;
                
            } else {
                
                _gc->startRadius  = _toStartRadius;
                _gc->finishRadius = _toFinishRadius;
                _state = EXPANSION;
                
            }
        
//            NSLog(@"startRadius:%f  finishRadius:%f interval:%f",gc.startRadius,gc.finishRadius,_interval);
//            NSLog(@"===============================================================");
            
            _startRadiusVelocity = (-1)*_startRadiusVelocity;
            _finishRadiusVelocity = (-1)*_finishRadiusVelocity;
            
            _passedPulsation ++;
            _interval = 0;
            
        } else {
            
            _gc->startRadius += _startRadiusVelocity*interval;
            _gc->finishRadius += _finishRadiusVelocity*interval;
            
//            NSLog(@"startRadius:%f  finishRadius:%f interval:%f",gc.startRadius,gc.finishRadius,_interval);
            
        }
        
    }
    
}
@end
