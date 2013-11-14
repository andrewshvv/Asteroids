//
//  Button.m
//  OpenGLTest
//
//  Created by Наталья Дидковская on 25.07.13.
//  Copyright (c) 2013 Andrey Samokhvalov. All rights reserved.
//

#import "ASButton.h"
#import "ASLayerManager.h"
#import "ASSprite.h"

#define CGRectSetPos( r, x, y ) CGRectMake( x, y, r.size.width, r.size.height )


CGPoint circleIntersection(CGPoint center,CGPoint touch,CGFloat a,CGFloat b) {
    
    CGFloat k = (center.y - touch.y)/(center.x - touch.x);
    CGFloat m = center.y - k*center.x;
    
    CGFloat Xo = center.x;
    CGFloat Yo = center.y;
    
    CGFloat Xone;
    CGFloat Xtwo;
    
    CGFloat Yone;
    CGFloat Ytwo;
    CGFloat D;
    
    if((k == -INFINITY) || (k == INFINITY)){
        
        Xone = touch.x;
        Xtwo = touch.x;
        
        Yone = center.y + b;
        Ytwo = center.y - b;
        
    } else {
        
        D = (powf((2*k*m - 2*Xo - 2*k*Yo), 2) - (4 + 4*k*k)*(m*m - a*b + Xo*Xo + Yo*Yo - 2*Yo*m));
        
        if(D < 0){
            
            NSLog(@"Дискриминант меньше нуля!!");
            return CGPointMake(0, 0);
            
        }
        
        Xone = ( (-(2*k*m - 2*Xo - 2*Yo*k) - sqrtf(D)) / (2 + 2*k*k) );
        Xtwo = ( (-(2*k*m - 2*Xo - 2*Yo*k) + sqrtf(D)) / (2 + 2*k*k) );
        
        Yone = k*Xone + m;
        Ytwo = k*Xtwo + m;
        
    }
    
    
    CGFloat Rone = sqrtf(powf(Xone - touch.x, 2) + powf(Yone - touch.y, 2));
    CGFloat Rtwo = sqrtf(powf(Xtwo - touch.x, 2) + powf(Ytwo - touch.y, 2));
    
    if (Rone > Rtwo) {
        
        return CGPointMake(Xtwo, Ytwo);
        
    } else {
        
        return CGPointMake(Xone, Yone);
    }
}


@implementation TouchHandler

- (id)initWithHandler:(id<TouchHandlerProtocol>) target
{
    self = [super init];
    if (self) {
        
        _target = target;
        
    }
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [_target touchesBegan:touches withEvent:event];
    
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [_target touchesCancelled:touches withEvent:event];
    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
   
    [_target touchesEnded:touches withEvent:event];
    
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [_target touchesMoved:touches withEvent:event];
    
}

@end

@implementation Item


- (id)init
{
    self = [super init];
    if (self) {
        
        _handler = [[TouchHandler alloc] initWithHandler:self];

    }
    return self;
}

- (UIView*) view {
    
    return _handler;
    
}

- (void) setPause:(BOOL) isPaused {
    
    _handler.userInteractionEnabled = !isPaused;
    
    for (id<ASNode> node in self.nodes) {
        
        [node setPause:isPaused];
        
    }
}

- (void) setHidden:(BOOL)isHidden {
    
    _handler.hidden = isHidden;
        for (id<ASNode> node in self.nodes) {
            
            [node setHidden:isHidden];
            
        }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {}
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {}



@end

@implementation ASButton

@synthesize sprite = _sprite;

@synthesize beganBlock = _beganBlock;
@synthesize endedBlock = _endedBlock;
@synthesize cancelledBlock = _cancelledBlock;
@synthesize movedBlock = _movedBlock;

- (id)initWithImage:(NSString*) comonImage tapImage:(NSString*) tapImage position:(CGPoint) position
{

    self = [super init];
    
    if (self) {
        
        ButtonBlock nullBlock = ^(NSSet *touhes,UIEvent *event){};
        
        self.beganBlock = nullBlock;
        self.endedBlock = nullBlock;
        self.cancelledBlock = nullBlock;
        self.movedBlock = nullBlock;

        _sprite = [ASSprite spriteWithName:comonImage];
        
        [self addNode:_sprite];
        _sprite.position = position;
        
        CGRect rect = CGRectMake(position.x  , position.y , _sprite.width, _sprite.height);
        
        [self.handler setFrame:rect];
        
    }

    return self;


    
}

- (void) setPosition:(CGPoint) position {
    
    _sprite.position = position;
    [self.handler setFrame:CGRectMake(position.x, position.y, self.handler.frame.size.width, self.handler.frame.size.height )];
    
}

+ (ASButton*) buttonWithImage:(NSString *)imageName {
    
    return [[ASButton alloc] initWithImage:imageName tapImage:nil position:CGPointMake(0, 0)];
    
}
+ (ASButton*) buttonWithImage:(NSString*) imageName tapImage:(NSString*) tapImage {
    
    return [[ASButton alloc] initWithImage:imageName tapImage:tapImage position:CGPointMake(0, 0)];
    
}
+ (ASButton*) buttonWithImage:(NSString*) imageName  position:(CGPoint)position{
    
    return [[ASButton alloc] initWithImage:imageName tapImage:nil position:position];
    
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    self.beganBlock(touches,event);
    
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    self.endedBlock(touches,event);
    
}
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    self.cancelledBlock(touches,event);
    
}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    self.movedBlock(touches,event);
    
}

@end

@implementation Joystick

- (id)initWithJoystick:(NSString*) joystick area:(NSString*) area position:(CGPoint) position
{
    
    self = [super init];
    
    if(self){
     
        _joystick = [ASSprite spriteWithName:joystick];
        _area = [ASSprite spriteWithName:area];
        
        
        [self addNode:_area];
        [self addNode:_joystick];
        
        _area.position = position;
        
        
        _joystick.center =  _area.center;
        
        CGRect rect = CGRectMake(position.x, position.y, _area.width, _area.height);
        
        [self.handler setFrame:rect];
        
        
    }
    
    return self;
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    /* точка касания по кнопке (не экрана!!) с началом координат в левом-верхнем углу :
     
            width
    (0,0)------------>x
        |             |
 height |   BUTTON    |
        |-------------|
        v
        y
     */
    
    UITouch *touch = [touches anyObject];
    CGPoint viewPoint = [touch locationInView: self.handler];
    
    
    /* радиус [0,1] отсчитывающийся от центра площади джостика */
    CGFloat r = 1 - powf((viewPoint.x - _area.width/2)/ (_area.height/2), 2) - powf((viewPoint.y - _area.height/2)/(_area.height/2),2);
    
    
    CGPoint superviewPoint = [touch locationInView: self.handler.superview];
    
    if(r > 0){
        
        CGPoint joystickPoint = CGPointMake(superviewPoint.x - _joystick.width/2, superviewPoint.y - _joystick.height/2);
        _joystick.position = joystickPoint;
        
        self.deviation = 1 - r;
        
    } else {
        
        
        CGPoint areaPosition = _area.position;
        
        CGPoint centerOfElipse = CGPointMake(areaPosition.x + _area.width/2, areaPosition.y + _area.height/2);
        
        CGPoint el = circleIntersection(centerOfElipse, superviewPoint, _area.height/2, _area.height/2);
        
//        [_joystick setPosition:CGPointMake(el.x - _joystick.image.width/2, el.y - _joystick.image.height/2)];
        _joystick.position = CGPointMake(el.x - _joystick.width/2, el.y - _joystick.height/2);
    
        self.deviation = 1;
        
    }
    
    CGPoint areaCenter = _area.center;//CGPointMake(_area.position.x + _area->width/2, _area.shape.position.y + _area.image.height/2);
    self.direction =  [ASVector x:superviewPoint.x - areaCenter.x
                                y: superviewPoint.y - areaCenter.y];
    
//    NSLog(@"=======================");
//    NSLog(@"areaCenter{%f,%f}",areaCenter.x,areaCenter.y);
//    NSLog(@"direction {%f,%f}",self.direction.x,self.direction.y);
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    _joystick.center = _area.center;
    self.direction = [ASVector x:0 y:0];
    self.deviation = 0;
    
}

- (void) setPosition:(CGPoint)position {
    
    _area.position = position;
    _joystick.center = _area.center;
    
    [self.handler setCenter:_area.center];//CGPointMake(position.x + _area.width/2, position.y + _area.height/2)];
    
    
}
+ (Joystick*) joystick:(NSString*) joystick area:(NSString*) area {
    
    return [[Joystick alloc] initWithJoystick:joystick area:area position:CGPointMake(0, 0)];
    
}

+ (Joystick*) joystick:(NSString*) joystick area:(NSString*) area position:(CGPoint) position {
    
    return [[Joystick alloc] initWithJoystick:joystick area:area position:position];
    
}

@end

@implementation TextLabel

- (id)initWithString:(NSString *)string
            position:(CGPoint) position
{
    self = [super init];
    if (self) {

        
        _string = [NSMutableString string];
        _position = position;

        [self setString:string];
        
    }
    return self;
}

+ (TextLabel*) labelWithString:(NSString *)string
                      position:(CGPoint) position
{
    
    return [[TextLabel alloc] initWithString:string position:position];
    
}

- (void) setPosition:(CGPoint)position {
    
    CGFloat offset = 0;
    
    for (ASSprite *sprite in self.nodes) {

        
        CGPoint letterPosition = CGPointMake(position.x + offset, position.y);
        [sprite setPosition:letterPosition];
        
        offset += sprite.width;
        
    }
    
}

- (void) setString:(NSString*) string {
    
    int strLenght = [string length];
    int oldStrLenght = [_string length];
    
    int dif = strLenght - oldStrLenght;
    
    /* новая строка больше или равна*/
    if(dif >= 0){
        
        for(int i = 0; i < oldStrLenght; i++){
            
            /* если символы не равны то заменяем спрайт в массиве букв*/
            
            /* 
                ----------------
                | oldString    | <-dif->
                ----------------
                -------------------------
                | newstring             |
                -------------------------
             
             */
            
            if([string characterAtIndex:i] != [_string characterAtIndex:i]){
                
                NSRange range = NSMakeRange(i, 1);
                NSString *letterName = [NSString stringWithFormat:@"%@",[string substringWithRange:range]];
                ASSprite *letter = [ASSprite spriteWithName:letterName];
                [self.nodes replaceObjectAtIndex:i withObject:letter];
                
            }
        }
        
        for(int i = 0; i < dif; i++){
            
            NSRange range = NSMakeRange(oldStrLenght + i, 1);
            NSString *letterName = [NSString stringWithFormat:@"%@",[string substringWithRange:range]];
            ASSprite *letter = [ASSprite spriteWithName:letterName];
            [self addNode:letter];
            
        }
        
        
        
    } /* новая строка меньше */
    else {
        
        for(int i = 0; i < strLenght; i++){
            
            /* если символы не равны то заменяем спрайт в массиве букв*/
            if([string characterAtIndex:i] != [_string characterAtIndex:i]){
                
                NSRange range = NSMakeRange(i, 1);
                ASSprite *letter = [ASSprite spriteWithName:[string substringWithRange:range]];
                [self.nodes replaceObjectAtIndex:i withObject:letter];
                
            }
        }
        
        NSRange removeRange = NSMakeRange(strLenght, abs(dif));
        [self.nodes removeObjectsInRange:removeRange];
        
        
    }

    
    
    
//    [self.nodes removeAllObjects];
//    [self.sprites addObjectsFromArray:_letters];
    
    [self setPosition:_position];
    
    [self setPause:self.isPaused];
    [self setHidden:self.hidden];
    
    _string = string;
}


@end

