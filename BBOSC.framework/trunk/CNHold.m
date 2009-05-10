//
//  CNHold.m
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

#import "CNHold.h"
#import "CNGestureFactory.h"
#import "CNLayer.h"

@implementation CNHold

-(id)init{
	if(self = [super init]){
		super.GestureName = @"CNHold";
		state = WaitingGesture;
	}
	return self;
}

-(BOOL)recognize:(id)sender{
	if([sender isKindOfClass:[CNLayer class]]){
		NSMutableArray* gStrokes = [[sender myMultitouchEvent] strokes];
		if([gStrokes count] == 1){
			CNTouch* touch = [gStrokes lastObject];
			double minHoldTimeInterval = [[GesturesParams objectForKey:@"MinHoldTimeInterval"] doubleValue];
			if(touch.lifetime>minHoldTimeInterval && NSEqualPoints(touch.velocity,NSZeroPoint)){
				if(state==WaitingGesture && touch.type==UpdateTouch){
					state=EndGesture;
					[sender performGesture:@"CNHold" withData:Nil];
					return TRUE;
				}
				if(state==EndGesture && touch.type==ReleaseTouch){
					state=WaitingGesture;
					return FALSE;
				}

			}
		}
	}
	return FALSE;
}

@end
