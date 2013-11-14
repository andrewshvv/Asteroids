//
//  Button.h
//  OpenGLTest
//
//  Created by Наталья Дидковская on 25.07.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASSprite.h"

typedef void (^ButtonBlock)(NSSet* touches,UIEvent *event);

@protocol TouchHandlerProtocol <NSObject>

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

- (UIView*) view;

@end

@interface TouchHandler : UIButton {
    
    __weak id<TouchHandlerProtocol> _target;
    
}

@end

@interface Item : ASComposite <TouchHandlerProtocol>

@property TouchHandler *handler;

@end

@interface ASButton : Item {
    
    CGFloat _height;
    
}

@property ASSprite* sprite;
@property ASSprite* tapSprite;

@property  (nonatomic,copy) ButtonBlock beganBlock ;
@property  (nonatomic,copy) ButtonBlock endedBlock ;
@property  (nonatomic,copy) ButtonBlock cancelledBlock ;
@property  (nonatomic,copy) ButtonBlock movedBlock ;


+ (ASButton*) buttonWithImage:(NSString*) imageName;
+ (ASButton*) buttonWithImage:(NSString*) imageName position:(CGPoint) point;

- (void) setPosition:(CGPoint) position;


@end

@interface Joystick :Item

@property  (nonatomic,copy) ButtonBlock endedBlock;
@property  (nonatomic,copy) ButtonBlock movedBlock;

@property ASSprite *area;
@property ASSprite *joystick;

@property ASVector* direction;
@property CGFloat deviation;


+ (Joystick*) joystick:(NSString*) joystick area:(NSString*) area position:(CGPoint) position;
+ (Joystick*) joystick:(NSString*) joystick area:(NSString*) area ;

- (void) setPosition:(CGPoint) position;

@end

@interface TextLabel : Item {
    
    CGPoint _position;
    NSString *_string;
    
    
}


- (void) setPosition:(CGPoint)position;
- (void) setString:(NSString*)string;

+ (TextLabel*) labelWithString:(NSString *)string
                      position:(CGPoint) position;

@end


