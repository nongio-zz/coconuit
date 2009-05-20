//
//  CNRelease.m
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

#import "CNRelease.h"
#import "CNLayer.h"


@implementation CNRelease
-(id)init{
	if(self = [super init]){
		GestureName = @"CNRelease";
		state = WaitingGesture;
	}
	return self;
}

-(BOOL)recognize:(id)sender{
	
	if([sender isKindOfClass:[CNLayer class]]){
		NSMutableArray* gStrokes = [[sender myMultitouchEvent] strokes];
		CNTouch* touch = [gStrokes lastObject];
		if(touch.type==ReleaseTouch&&[gStrokes count]>0){///if the number of release touches in the active area is heighter than 0 
			state = BeginGesture;
			
			[sender performGesture:@"Release" withData:Nil];///calls PerformReleaseGesture on the related layer [sender performGesture:@"Release" withData:Nil];
			
			state = EndGesture;
			state = WaitingGesture;
			return TRUE;
		}
		else{
			return FALSE;//gesture recognized			
		}
	}
	return FALSE;
}
@end
