//
//  Animation.m
//  OpenGLTest
//
//  Created by Наталья Дидковская on 27.07.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import "ASAnimation.h"

#import "ASSprite.h"

#import "ASProgramManager.h"

#import "AS2DConstants.h"


#pragma mark -
#pragma mark ASAnimation
@implementation ASAnimation


- (id)init
{
    self = [super init];
    if (self) {
        
        self.indixes = [NSArray array];
        self.attributs = [NSDictionary dictionary];
        
    }
    return self;
}

- (id) copyWithZone:(NSZone *)zone {
    
    ASAnimation *copy = [[[self class] allocWithZone:zone] init];
    
    copy->type = self->type;
    
    return copy;
    
    
}

- (void) dealloc {
    
    free(data);
    
}

/* packs the data in the order in which the attributes are */
- (void) packDataWithOffset:(int) offset {
    
    for (ASAttribute *attribute in _attributesValue) {
        
        memcpy((data + attribute->offset + offset), attribute->data, attribute->size * sizeof(CGFloat));
        
    }
}

- (void) setData:(CGFloat*) theData forAttribute:(NSString*) aName {
    
    ASAttribute *attrib = [_attributs objectForKey:aName];
    
    attrib->data = theData;
    
    
    
}

- (void) remove {
    
    [_program removeAnimation:self];
    
}

- (void) update
{
    
    
    
}

- (void) wrap:(ASSprite *)sprite {
    
}


@end

#pragma mark -
#pragma mark NoneAnimation
@implementation NoneAnimation

- (id)init
{
    self = [super init];
    if (self) {
        
        self->type = TYPE_NONE;
        
        self.program = [[ASProgramManager programManager] program:type];
        
        self.attributs = [self.program copyAttributs];
        self.attributesValue = [self.attributs allValues];
        stride = self.program->stride;
        
    }
    
    return self;
}

- (id) copyWithZone:(NSZone *)zone {
    
    NoneAnimation *copy = [super copyWithZone:zone];
    
    return copy;
    
    
}
    

- (void) wrap:(ASSprite *)sprite {
 
    [self.program addAnimation:self];
    
    self.sprite = sprite;
    
    self.indixes = sprite.shape.indixes;
    self->pointCount = [sprite.shape.points count];
    self->indixesCount = [sprite.shape.indixes count];
    
    data = (CGFloat*)malloc(pointCount * stride * FLOAT_SIZE);
    
}

- (void) update {
    
    ASSprite *sprite = self.sprite;
    
    NSArray *points = sprite.shape.points;
    
    CGFloat translationVector[SIZE_TRANSLATION_VECTOR] = {sprite.center.x, sprite.center.y , 0};
    CGFloat angel = DegreesToRadians(sprite.shape.angel);
    
    [self setData:translationVector forAttribute:NAME_TRANSLATION_VECTOR];
    [self setData:&angel forAttribute:NAME_ANGEL];
    
    int offset = 0;
    for (AS5Point *point in points) {
        
        CGFloat vertexCoord[SIZE_VERTEX_COORD] = {point->x, point->y , -2};
        CGFloat textureCoord[SIZE_TEXTURE_COORD] = {point->tx , point->ty};
        
        [self setData:vertexCoord forAttribute:NAME_VERTEX_COORD];
        [self setData:textureCoord forAttribute:NAME_TEXTURE_COORD];
        
        [self packDataWithOffset: offset];
        
        offset += stride;
        
        
    }
}


@end


#pragma mark -
#pragma mark GradientCircle
@implementation GradientCircle

- (id)initWithStartRadius:(float) theSRadius
          finishRadius:(float) theFRadius
                 alpha:(float) theAlpha

{
    self = [super init];
    if (self) {
        
        self->type = TYPE_GRADIENT_CIRCLE;
        
        startRadius = theSRadius;
        finishRadius = theFRadius;
        alpha = theAlpha;
        
        
        self.program = [[ASProgramManager programManager] program:type];
        
        self.attributs = [self.program copyAttributs];
        self.attributesValue = [self.attributs allValues];
        stride = self.program->stride;
        
        
    }
    return self;
}
+ (GradientCircle*) animationStartRadius:(float)sRadius
                            finishRadius:(float)fRadius
                                   alpha:(float)alpha
{
    
    return [[GradientCircle alloc] initWithStartRadius:sRadius
                                      finishRadius:fRadius
                                             alpha:alpha];
    
}

- (id) copyWithZone:(NSZone *)zone {
    
    GradientCircle *copy = [super copyWithZone:zone];
    
    copy->startRadius = self->startRadius;
    copy->finishRadius = self->finishRadius;
    copy->alpha = self->alpha;
    
    return copy;
}


- (void) wrap:(ASSprite *)sprite {
    
    [self.program addAnimation:self];
    
    self.sprite = sprite;
    
    self.indixes = sprite.shape.indixes;
    self->pointCount = [sprite.shape.points count];
    self->indixesCount = [sprite.shape.indixes count];
    
    
    ASImage *image = sprite.image;
    
    _k = image.texture->k;//(float)image.globalHeight / (float)image.globalWidth;
    
    _textureRadius = sqrtf( powf((image.texture->width/2),2) + powf((_k*image.texture->height/2),2) );
    
    _centerVector.data[0] = image.texture.quad.bl.x + image.texture->width/2;
    _centerVector.data[1] = image.texture.quad.tl.y + image.texture->height/2;
    
    data = (CGFloat*)malloc(pointCount * stride * FLOAT_SIZE);
    
    
}
    

- (void) update {
    
    
    ASSprite *sprite = self.sprite;
    
    NSArray *points = sprite.shape.points;
    
    _textureStartRadius = startRadius*_textureRadius;
    _textureFinishRadius = finishRadius*_textureRadius;
 
    CGFloat translationVector[SIZE_TRANSLATION_VECTOR] = {sprite.center.x, sprite.center.y , 0};
    CGFloat angel = DegreesToRadians(sprite.shape.angel);
    
    [self setData:&_k                               forAttribute:NAME_COEFFICIENT];
    [self setData:&alpha                            forAttribute:NAME_ALPHA];
    [self setData:&_textureStartRadius              forAttribute:NAME_START_RADIUS];
    [self setData:&_textureFinishRadius             forAttribute:NAME_FINISH_RADIUS];
    [self setData:_centerVector.data                forAttribute:NAME_CENTER_VECTOR];
    [self setData:translationVector                 forAttribute:NAME_TRANSLATION_VECTOR];
    [self setData:&angel                            forAttribute:NAME_ANGEL];
    
    int offset = 0;
    for (AS5Point *point in points) {
        
        CGFloat vertexCoord[SIZE_VERTEX_COORD] = {point->x, point->y , -2};
        CGFloat textureCoord[SIZE_TEXTURE_COORD] = {point->tx , point->ty};
        
        [self setData:vertexCoord   forAttribute:NAME_VERTEX_COORD];
        [self setData:textureCoord  forAttribute:NAME_TEXTURE_COORD];
        
        [self packDataWithOffset:offset];
        
        offset += stride;
        
        
    }
    
}

@end


#pragma mark -
#pragma mark GradientLinear
@implementation GradientLinear

- (id)initWithStartDegradation:(CGFloat)theStartDegradation
             finishDegradation:(CGFloat)theFinishDegradation

{
    self = [super init];
    if (self) {
        
        type = TYPE_GRADIENT_LINEAR;
        
        startDegradation = theStartDegradation;
        finishDegradation = theFinishDegradation;
        
        self.program = [[ASProgramManager programManager] program:type];
        
        self.attributs = [self.program copyAttributs];
        self.attributesValue = [self.attributs allValues];
        stride = self.program->stride;
        

    }
    return self;
}

+ (GradientLinear*) animationWithStartDegradation:(CGFloat)startDegradation
                                      finishDegradation:(CGFloat)finishDegradation
{
    
    return [[GradientLinear alloc] initWithStartDegradation:startDegradation
                                                finishDegradation:finishDegradation ];
    
}

- (id) copyWithZone:(NSZone *)zone {
    
    GradientLinear *copy = [super copyWithZone:zone];
    
    copy->startDegradation = self->startDegradation;
    copy->finishDegradation = self->finishDegradation;
    
    
    return copy;
    
    
}

- (void) wrap:(ASSprite *)sprite {
    
    [self.program addAnimation:self];
    
    self.sprite = sprite;
    
    self.indixes = sprite.shape.indixes;
    self->pointCount = [sprite.shape.points count];
    self->indixesCount = [sprite.shape.indixes count];
    

    ASImage *image = sprite.image;
    
    _textureWidth = image.texture->width;
    
    _textureStartDegradation = image.texture.quad.bl.x + _textureWidth*(startDegradation );
    _textureFinishDegradation = image.texture.quad.bl.x + _textureWidth*(finishDegradation );
    
    data = (CGFloat*)malloc(pointCount * stride * FLOAT_SIZE);

    
}
    
- (void) update {
    
    ASSprite *sprite = self.sprite;
    
    NSArray *points = sprite.shape.points;
    
    _textureStartDegradation = sprite.image.texture.quad.bl.x + _textureWidth*(startDegradation );
    _textureFinishDegradation = sprite.image.texture.quad.bl.x + _textureWidth*(finishDegradation );
    
    CGFloat translationVector[SIZE_TRANSLATION_VECTOR] = {sprite.center.x, sprite.center.y , 0};
    CGFloat angel = DegreesToRadians(sprite.shape.angel);
    
    [self setData:&_textureStartDegradation     forAttribute:NAME_START_DEGRADATION];
    [self setData:&_textureFinishDegradation    forAttribute:NAME_FINISH_DEGRADATION];
    [self setData:translationVector             forAttribute:NAME_TRANSLATION_VECTOR];
    [self setData:&angel                        forAttribute:NAME_ANGEL];
    
    
    int offset = 0;
    for (AS5Point *point in points) {
        
        CGFloat vertexCoord[SIZE_VERTEX_COORD] = {point->x, point->y , -2};
        CGFloat textureCoord[SIZE_TEXTURE_COORD] = {point->tx , point->ty};
        
        [self setData:vertexCoord forAttribute:NAME_VERTEX_COORD];
        [self setData:textureCoord forAttribute:NAME_TEXTURE_COORD];
        
        [self packDataWithOffset:offset];
        offset += stride;
        
    }
}


@end



