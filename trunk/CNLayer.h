//
//  CNLayer.h
//  TuioClient
//
//  Created by Nicola Martorana on 19/03/09.
//  Copyright 2009 Unifi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/CoreAnimation.h>
#import <Quartz/Quartz.h>
#import <QTKit/QTMovieLayer.h>
#import <QTKit/QTMovie.h>
#import "CNLayerModifier.h"
#import "CNEvent.h"
#import "CNGesture.h"
#import "CNStroke.h"
#import "CNTap.h"
#import "CNHold.h"
#import "CNMove.h"
#import "CN2dVect.h"

@interface CNLayer : CALayer <QTObservableProtocol>{
	CNEvent* myMultitouchEvent;
	CNLayerModifier* myModifier;
	CNGesture* GestureRecognizer;
	NSMutableArray* observers;
}

@property (retain) CNEvent* myMultitouchEvent;
@property (retain) CNGesture* GestureRecognizer;
@property (retain) NSMutableArray* observers;
-(void)draw;
-(void)performGesture:(NSString*)gName withData:(NSDictionary*)params;

-(void)CNPress:(NSDictionary*)params;
-(void)updateTouch:(NSDictionary*)params;
-(void)CNRelease:(NSDictionary*)params;
-(void)CNTap:(NSDictionary*)params;
-(void)DoubleTap:(NSDictionary*)params;
-(void)CNHold:(NSDictionary*)params;
//-(void)Move:(CN2dVect*)vectT  withVelocity:(NSPoint)velocity andGestureState:(int)gestureState;
-(void)Move:(NSDictionary*)params;
//-(void)TwoFingerScale:(double)scaleFactor withCenter:(NSPoint)center andGestureState:(int)gestureState;
-(void)TwoFingerScale:(NSDictionary*)params;
//-(void)TwoFingerRotate:(float)rotationAngle withSense:(int)sense andRadius:(double)radius andGestureState:(int)gestureState andCenter:(NSPoint)center;
-(void)TwoFingerRotate:(NSDictionary*)params;
//-(void)OneFingerRotate:(float)rotationAngle withSense:(int)sense andVelocity:(float)angularVelocity andCenter:(NSPoint)center andRadius:(double)radius andGestureState:(int)gestureState;
-(void)OneFingerRotate:(NSDictionary*)params;

-(void)updateStrokes:(CNEvent*)aEvent;
-(CALayer*)globalLayer;
-(void) changeAnchorPoint:(CGPoint)unitPoint;
-(CGPoint)unitToReal:(CGPoint)apoint ofLayer:(CALayer*)layer;
-(CGPoint)realToUnit:(CGPoint)apoint ofLayer:(CALayer*)layer;
@end
