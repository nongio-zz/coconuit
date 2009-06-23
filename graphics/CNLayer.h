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
#import "CNLayerModifier.h"
#import "CNEvent.h"
#import "CNGesture.h"
#import "CNStroke.h"
#import "CNTap.h"
#import "CNHold.h"
#import "CNMove.h"
#import "CN2dVect.h"
/**
 * \brief This rapresent the active element, able to manage touches. Can be inserted in a view because inherit from CALayer.
 * \details This Class keeps the state of its touches updated through its attribute CNEvent* myMultitouchEvent and the updateStrokes method.\n
 * The GestureRecognizer attribute is an instance of CNGesture or subclass.\n
 *\par 
 * When a gesture is recognized, the appropriate callback function is called, passing a dictionary parameter with the.\n
 * description variables of the gesture, look at the appropriate CNGesture subclass for the dictionary description.\n
 * These are the possible callback functions:\n
 * - Press
 * - Update 
 * - Release 
 * - Tap 
 * - DoubleTap 
 * - Hold 
 * - Move 
 * - TwoFingerScale 
 * - TwoFingerRotate 
 * - OneFingerRotate
 *\par
 * CNLayer implemets the <CNObservableProtocol>, to allow other object to be notified of the recognized gestures.
 */
@interface CNLayer : CALayer <CNObservableProtocol>{
	CNEvent* myMultitouchEvent;///<Keep the state of strokes attached to this active area
	CNLayerModifier* myModifier;
	CNGesture* GestureRecognizer;///<The root of the possible recognized gestures
	NSMutableArray* observers;///<Keep the list of the observers
}

@property (retain) CNEvent* myMultitouchEvent;
@property (retain) CNGesture* GestureRecognizer;
@property (retain) NSMutableArray* observers;

-(void)updateStrokes:(CNEvent*)aEvent;///<update myMultitouchEvent attribute with the new CNEvent
-(void)performGesture:(NSString*)gName withData:(NSDictionary*)params;///<Redirect to the proper callback function based on the gesture name and notify observers
-(void)Press:(NSDictionary*)params;///<Press callback function
-(void)Update:(NSDictionary*)params;///<Update callback function
-(void)Release:(NSDictionary*)params;///<Release callback function
-(void)Tap:(NSDictionary*)params;///<Tap callback function
-(void)DoubleTap:(NSDictionary*)params;///<Double tap callback function
-(void)Hold:(NSDictionary*)params;///<Hold callback function
-(void)Move:(NSDictionary*)params;///<Move callback functions
-(void)TwoFingerScale:(NSDictionary*)params;///<Two finger scale
-(void)TwoFingerRotate:(NSDictionary*)params;///<Two finger rotate callback function
-(void)OneFingerRotate:(NSDictionary*)params;///<One finger rotate callback function

-(CALayer*)globalLayer;///<Keep the CNGesture childs
-(void) changeAnchorPoint:(CGPoint)unitPoint;///<Keep the CNGesture childs
-(CGPoint)unitToReal:(CGPoint)apoint ofLayer:(CALayer*)layer;///<Keep the CNGesture childs
-(CGPoint)realToUnit:(CGPoint)apoint ofLayer:(CALayer*)layer;///<Keep the CNGesture childs

-(void)draw;
@end
