//
//  Pair.h
//  OpenGLTest
//
//  Created by Наталья Дидковская on 10.08.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASAction;
@protocol HavePause;

@interface ActionPair : NSObject

@property NSMutableArray *actions;
@property id<HavePause> object;

+ (ActionPair*) object:(id<HavePause>) object ;

@end


@class ASAnimation;
@class ASSprite;

@interface AnimationPair : NSObject

@property ASAnimation *animation;
@property ASSprite *sprite;

+ (AnimationPair*) animation:(ASAnimation*) animation sprite:(ASSprite*) sprite;

@end


@interface GroupPair : NSObject

@property NSString *firstGroup;
@property NSString *secondGroup;

+ (GroupPair*) firstGroup:(NSString*) firstGroup secondGroup:(NSString*) secondGroup;

@end

