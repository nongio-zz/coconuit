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

@interface CNLayer : CALayer <CNObservableProtocol>{
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

-(void)Press:(NSDictionary*)params;
-(void)Update:(NSDictionary*)params;
-(void)Release:(NSDictionary*)params;
-(void)Tap:(NSDictionary*)params;
-(void)DoubleTap:(NSDictionary*)params;
-(void)Hold:(NSDictionary*)params;
-(void)Move:(NSDictionary*)params;
-(void)TwoFingerScale:(NSDictionary*)params;
-(void)TwoFingerRotate:(NSDictionary*)params;
-(void)OneFingerRotate:(NSDictionary*)params;

-(void)updateStrokes:(CNEvent*)aEvent;
-(CALayer*)globalLayer;
-(void) changeAnchorPoint:(CGPoint)unitPoint;
-(CGPoint)unitToReal:(CGPoint)apoint ofLayer:(CALayer*)layer;
-(CGPoint)realToUnit:(CGPoint)apoint ofLayer:(CALayer*)layer;

@end
