//
//  Pair.m
//  OpenGLTest
//
//  Created by Наталья Дидковская on 10.08.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import "Pair.h"

@implementation ActionPair

@synthesize actions = _actions,object = _object;

- (id)initWithObject:(id<HavePause>) object
{
    self = [super init];
    if (self) {
        
        self.object = object;
        self.actions = [NSMutableArray array];
        
    }
    return self;
}


+ (ActionPair*) object:(id<HavePause>) object {
    
    return [[ActionPair alloc] initWithObject:object];
    
}


@end

@implementation AnimationPair

- (id)initWithAnimation:(ASAnimation*) animation andSprite:(ASSprite*) sprite
{
    self = [super init];
    if (self) {
        
        self.animation = animation;
        self.sprite = sprite;
        
    }
    return self;
}

+ (AnimationPair*) animation:(ASAnimation *)animation sprite:(ASSprite *)sprite {
    
    return [[AnimationPair alloc] initWithAnimation:animation andSprite:sprite];
    
}

@end

@implementation GroupPair

@synthesize firstGroup = _firstGroup;
@synthesize secondGroup = _secondGroup;

- (id)initFirstGroup:(NSString*) firstGroup secondGroup:(NSString*) secondGroup
{
    self = [super init];
    if (self) {
        
        self.firstGroup = firstGroup;
        self.secondGroup = secondGroup;
        
    }
    return self;
}

+ (GroupPair*) firstGroup:(NSString *)firstGroup secondGroup:(NSString *)secondGroup {
    
    return [[GroupPair alloc] initFirstGroup:firstGroup secondGroup:secondGroup];
    
}
@end
