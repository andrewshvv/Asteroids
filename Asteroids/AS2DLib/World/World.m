//
//  World.m
//  OpenGLTest
//
//  Created by Наталья Дидковская on 14.09.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import "World.h"
#import "Collision.h"
#import "Pair.h"


static World *_world = nil;
@implementation World

+ (World*) world {
 
    @synchronized(self) {
        
        if (!_world) {
            
            _world = [[World alloc] init];
        }
    }
    return _world;
    
}

- (id)init
{
    self = [super init];
    if (self) {
        
        _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        _world_group = dispatch_group_create();
        
        _groups = [NSMutableDictionary dictionary];
        _objects = [NSMutableArray array];
        _collisions = [NSMutableArray array];
        _removedObjects = [NSMutableArray array];
        
//        !!!!!!!!!!!!
        
        NSDictionary *shapeFirstMethods = @{[NSNumber numberWithInteger:PS_CIRCLE]:[NSValue valueWithPointer:&circleWithCircle],
                                            [NSNumber numberWithInteger:PS_POLYGON]:[NSValue valueWithPointer:&circleWithPolygon]};
        
        NSDictionary *shapeSecondMethods = @{[NSNumber numberWithInteger:PS_POLYGON]:[NSValue valueWithPointer:&polygonWithPolygon],
                                             [NSNumber numberWithInteger:PS_CIRCLE]:[NSValue valueWithPointer: &circleWithPolygon]};
        
        _methods = @{[NSNumber numberWithInteger:PS_CIRCLE]:shapeFirstMethods,
                         [NSNumber numberWithInteger:PS_POLYGON]:shapeSecondMethods};
        
//        !!!!!!!!!!!!
        
    }
    return self;
}

- (void) addGroup:(NSString *)name
{
    
    NSMutableArray *objects = [NSMutableArray array];
    [_groups setObject:objects forKey:name];
    
}

- (void) removeGroup:(NSString *)name
{
    
    if(!_collisionHandle){
     
        [_groups removeObjectForKey:name];
        
    }
}

- (void) doCollisionFor:(NSString*) firstGroup and:(NSString*) secondGroup {
    
    if([_groups objectForKey:firstGroup] && [_groups objectForKey:secondGroup]){
        
        GroupPair *gp = [GroupPair firstGroup:firstGroup secondGroup:secondGroup];
        [_collisions addObject:gp];
        
        
    } else {
        
        NSLog(@"Can't find %@ or %@",firstGroup,secondGroup);
        
    }
}

- (void) addObject:(ASContactListner *) object inGroup:(NSString *)groupName
{
    
    NSMutableArray *group = [_groups objectForKey: groupName ];
    if(group == nil){
        
        NSLog(@"Did'n find group:%@",groupName);
        
    } else {
        
        [group addObject:object];
//        [_objects addObject:object];
    }
    
}

- (void) removeObject:(ASContactListner*) object fromGroup:(NSString *)groupName
{
    
    NSMutableArray *group = [_groups objectForKey: groupName ];
    
    if(group == nil){
        
        NSLog(@"Did'n find group:%@",groupName);
        
    } else {
        
       [group removeObject: object];
        
    }
    
}

- (BOOL) outsideTheWorld:(ASContactListner*) cl {
        
    NSArray *bodies = cl.bodies;
    for (ASBody *body in bodies) {
        
        id<ASWorldShape> shape = body.shape;
        
        CGFloat dx = shape.center.x - _bound.center.x;
        CGFloat dy = shape.center.y - _bound.center.y;
        
        CGFloat d = sqrtf(powf(dx,2) + powf(dy, 2));
        
        if( _bound.r > d ){
            
            return NO;
            
        }

    }
    
    return YES;

}


- (void) handleCollisions
{
    
    if(_bound){
        
        dispatch_group_async(_world_group,_queue, ^ {
        
            NSArray* groupObject;
            for (NSString *name in _groups) {
                groupObject = [[_groups objectForKey:name] copy];
            
                for (ASContactListner *cl in groupObject) {
                    if([self outsideTheWorld:cl]){
                        
                        [cl outsideTheWorld];
                        
                    }
                    
                }
            }
            
        });
    }
    
    for (GroupPair *pair in _collisions) {
        
        NSArray* firstObjects= [[_groups objectForKey:pair.firstGroup] copy];
        NSArray* secondObjects = [[_groups objectForKey:pair.secondGroup] copy];
        
        if(firstObjects && secondObjects){
            
            for (ASContactListner *firstCL in firstObjects) {
                for (ASContactListner *secondCL in secondObjects) {
                    
                    handleCollision(firstCL , secondCL ,_methods);
                    
                    
                }
            }
            
        } else {
            
            NSAssert(NO, @"Cant'n find %@ or %@",pair.firstGroup,pair.secondGroup);
            
        }
    }
    
    dispatch_group_wait(_world_group, DISPATCH_TIME_FOREVER);

    NSMutableArray* group;
    
//    while ((group = [groupEnumerator nextObject])) {
    for (NSString *name in _groups) {
        group = [_groups objectForKey:name];
        
        for (ASContactListner *cl in group) {
            
            if(cl.remove){
                
                [_removedObjects addObject:cl];
                
            }
        }
        
        [group removeObjectsInArray:_removedObjects];
    }
    
    [_removedObjects removeAllObjects];
}


- (void) update:(CFTimeInterval) dt
{
    
    NSArray *contactListners;

    for (NSString *name in _groups) {
        contactListners = [_groups objectForKey:name];
        
        for (ASContactListner *cl in contactListners) {
            
            dispatch_group_async(_world_group,_queue, ^ {
            
                [cl update:dt];
            
            });
        }
    }
    
    dispatch_group_wait(_world_group, DISPATCH_TIME_FOREVER);

}

@end
