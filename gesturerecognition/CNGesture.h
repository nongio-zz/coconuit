//
//  CNGesture.h
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
//  Copyright 2009 Nicola Martorana <martorana.nicola@gmail.com>.
//

#import <Cocoa/Cocoa.h>
#import "CNObserverProtocol.h"
#import "CNMath.h"
#import "CNTouch.h"

typedef enum GestureState {
	WaitingGesture,
	BeginGesture,
	UpdateGesture,
	EndGesture
} GestureState;

/**
 * \brief It represents a general Gesture. Every real gesture recognition implementation has to inherit from this Class.
 * \details This Class implements the Composite design patter. It is useful to build and modify at runtime the GestureRecognition tree.
 * Thus it is also possible to give a specified priority to the gestures recognition.\n
 * Each active layer has one instance of CNGesture class or subclass linked-in: it is the root of the GestureRecognition Tree.\n
 * Each CNGesture has one or more childs which can pass the GestureRecognition Task.
 * \par
 * Each gesture could be in one of the below state:\n
 * - WaitingGesture, still waiting to be recognized
 * - BeginGesture, just recognized
 * - UpdateGesture, already active doing something
 * - EndGesture, terminated. Becames waiting again. 
 * \par
 * It is useful to distiguish the various state of the gestures because it could be necessary to do something different for each state.
 * For example add the friction effect to the end of a Move.
 *
 */

@interface CNGesture : NSObject{
	NSMutableArray* GestureChilds;///<Keep the CNGesture childs
	NSMutableDictionary* GesturesParams;///<Keep the specific Gestures Paramaters useful for the layerAnimation
	NSString* GestureName;///<CNGesture name
	GestureState state;///<CNGesture state
}

@property (retain) NSString* GestureName;
@property (retain) NSMutableDictionary* GesturesParams;
@property (assign) GestureState state;

-(BOOL)addChildGesture:(CNGesture*)aGesture;///<add a CNGesture child
-(void)removeChildGestureByName:(NSString*)gName;///<remove a CNGesture child by name
-(CNGesture*)getChildGestureByName:(NSString*)gName;///<get a CNGesture child by name

-(void) groupStrokesToOne:(NSMutableArray*) strokes andUpdateTouch:(CNTouch*)aTouch;///<grouping strokes to one if more than requested to recognize the gesture

-(BOOL)recognize:(id)sender;///<implements the specific GestureRecognition task
-(void)recognizeGesture:(id)sender;///<the View call this method to ask the gesture recognition

@end
