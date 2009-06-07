//
//  CNGesture.m
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

#import "CNGesture.h"
#import "CNGestureFactory.h"
#import "CNLayer.h"
#import "CNTouchGrouper.h"

@implementation CNGesture

@synthesize GestureName,GesturesParams,state;

-(id)init{
	if (self = [super init]){
		GestureName = @"GESTURE";
		GesturesParams = [[CNGestureFactory getGestureFactory] GesturesParams]; 
		state = WaitingGesture;
		GestureChilds = [[NSMutableArray alloc] init];
	}
	return self;
}

-(BOOL)addChildGesture:(CNGesture*)aGesture{
	if(![self getChildGestureByName:[aGesture GestureName]]){
		[GestureChilds addObject:[aGesture retain]];
		return TRUE;
	}
	else{
		return FALSE;
	}
}

-(void)removeChildGestureByName:(NSString*)gName{
	for (CNGesture* gesture in GestureChilds){
		if([gesture.GestureName isEqual:gName]){
			[GestureChilds removeObject:gesture];
		}
	}
}

-(CNGesture*)getChildGestureByName:(NSString*)gName{
	for (CNGesture* gesture in GestureChilds){
		if ([gesture.GestureName isEqual:gName]){
			return gesture;
		}
	}
	return Nil;
}

///If the gesture is not recognized calls recognizeGesture on all its Childs
///[GestureChilds makeObjectsPerformSelector:@selector(recognizeGesture:) withObject:sender];\n
-(void)recognizeGesture:(id)sender{
	if(![self recognize:sender]){
		[GestureChilds makeObjectsPerformSelector:@selector(recognizeGesture:) withObject:sender];
	}
}

///Each subClass of CNGesture has to override this method.
///In CNGesture this method only return FALSE, because it only has to call recognizeGesture: on its childs.
-(BOOL)recognize:(id)sender{
	return FALSE;
}

-(void) groupStrokesToOne:(NSMutableArray*)strokes andUpdateTouch:(CNTouch*)aTouch{
	//NSMutableArray* points = [[NSMutableArray alloc] init];
	int touchType = aTouch.type;
	int countRelease=0;
	int countNew=0;
	
	for(CNStroke* S in strokes){
		if([S isKindOfClass:[CNTouch class]]){
			CNTouch* t = (CNTouch*) S;
			
			if(t.type==NewTouch){
				aTouch.strokePath = [[NSMutableArray alloc] init];
			}
			
			if(t.type==NewTouch){
				countNew++;
			}
			
			if(t.type==ReleaseTouch){
				countRelease++;
			}
			//[points addObject:[NSValue valueWithPoint:t.position]];
		}
	}
	
	if(countNew==[strokes count]){
		touchType==NewTouch;
	}
	else{
		touchType=UpdateTouch;
	}
	
	if(countRelease==[strokes count]){
		touchType = ReleaseTouch;
	}
	
	CNTouchGrouper* aGrouper = [[CNTouchGrouper alloc] initWithTouches:strokes];
	CNTouch* rapresentativeTouch = [aGrouper getRapresentativeOfGroupAtIndex:0];
	
	//NSPoint gCenter = getCenterPoint(points);
	
	[aTouch updateWithPoint:rapresentativeTouch.position andTouchType:touchType];
}

@end
