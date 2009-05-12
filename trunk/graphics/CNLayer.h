//
//  CNLayer.h
//
//  CocoNuit is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version. 
//
//  CocoNuit is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Lesser General Public License for more details.
//
//  You should have received a copy of the GNU Lesser General Public License
//  along with CocoNuit.  If not, see <http://www.gnu.org/licenses/>.
//
//  Copyright 2009 Riccardo Canalicchio <riccardo.canalicchio@gmail.com>.
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
