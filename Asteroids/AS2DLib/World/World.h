//
//  World.h
//  OpenGLTest
//
//  Created by Наталья Дидковская on 14.09.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASObject.h"


@class ASShape;

@interface World : NSObject {
    
    BOOL _collisionHandle;
    NSMutableArray *_objects;
    NSDictionary *_methods;
    NSMutableDictionary *_groups;
    NSMutableArray *_collisions;
    NSMutableArray *_removedObjects;
    
    dispatch_queue_t _queue;
    dispatch_group_t _world_group;
    
    
}
@property id<ASWorldShape>  bound;

+ (World*) world;

- (void) doCollisionFor:(NSString*) firstGroup and:(NSString*) secondGroup ;

- (void) addGroup:(NSString *)name;
- (void) removeGroup:(NSString *)name;

- (void) addObject:(ASContactListner *) object inGroup:(NSString *)groupName;
- (void) removeObject:(ASContactListner*) object fromGroup:(NSString *)groupName ;

- (void) handleCollisions;
- (void) update:(CFTimeInterval) dt;

@end
