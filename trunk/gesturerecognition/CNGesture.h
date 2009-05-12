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

@interface CNGesture : NSObject{
	NSMutableArray* GestureChilds;
	NSMutableDictionary* GesturesParams;
	NSString* GestureName;
	GestureState state;//Se salvato come oggetto con il Kvc ci si può mettere ad osservare direttamente questo valore
	NSMutableArray* observers;
}

@property (retain) NSString* GestureName;
@property (retain) NSMutableDictionary* GesturesParams;
@property (assign) GestureState state;

-(BOOL)addChildGesture:(CNGesture*)aGesture;
-(void)removeChildGestureByName:(NSString*)gName;
-(CNGesture*)getChildGestureByName:(NSString*)gName;
-(void) groupStrokesToOne:(NSMutableArray*) strokes andUpdateTouch:(CNTouch*)aTouch;


-(BOOL)recognize:(id)sender;
-(void)recognizeGesture:(id)sender;
-(BOOL)pointIsGreater:(NSPoint)firstPoint than:(NSPoint)secondPoint;
@end
