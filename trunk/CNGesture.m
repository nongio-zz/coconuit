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

@implementation CNGesture

@synthesize GestureName,GesturesParams,state;

-(id)init{
	if (self = [super init]){
		GestureName = @"GESTURE";
		GesturesParams = [[CNGestureFactory getGestureFactory] GesturesParams]; 
		state = WaitingGesture;
		GestureChilds = [[NSMutableArray alloc] init];
		observers = [[NSMutableArray alloc] init];
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
		if([gesture.GestureName isEqual:gesture]){
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

-(void)recognizeGesture:(id)sender{
	if(![self recognize:sender]){
		[GestureChilds makeObjectsPerformSelector:@selector(recognizeGesture:) withObject:sender];
	}
}

-(BOOL)recognize:(id)sender{
	return FALSE;
}

-(BOOL)pointIsGreater:(NSPoint)firstPoint than:(NSPoint)secondPoint{
	if(fabs(firstPoint.x) >  fabs(secondPoint.x) || fabs(firstPoint.y) > fabs(secondPoint.y))
		return YES
		;
	else
		return NO;
}

-(NSPoint)getNormalizedPoint:(NSPoint) p withPivot:(NSPoint) o{
	NSPoint newPoint;
	newPoint.x = p.x - o.x;
	newPoint.y = p.y - o.y;
	return newPoint;
}

-(NSPoint)getHeightPointWithPoint:(NSPoint) p1 andSegmentWithStartPoint:(NSPoint) o andEndPoint:(NSPoint)p2{
	NSPoint h;
	NSPoint norm_p1 = [self getNormalizedPoint:p1 withPivot:o];
	NSPoint norm_p2 = [self getNormalizedPoint:p2 withPivot:o];
	
	h.x = ((norm_p2.x*norm_p2.y*norm_p1.y)/(pow(norm_p2.x,2)+pow(norm_p2.y,2))+(pow(norm_p2.x,2)*norm_p1.x)/(pow(norm_p2.x,2)+pow(norm_p2.y,2)))+o.x;
	h.y = ((pow(norm_p2.y,2)*norm_p1.y)/(pow(norm_p2.x,2)+pow(norm_p2.y,2))+(norm_p2.x*norm_p2.y*norm_p1.x)/(pow(norm_p2.x,2)+pow(norm_p2.y,2)))+o.y;
	
	return h;
}

-(void) groupStrokesToOne:(NSMutableArray*)strokes andUpdateTouch:(CNTouch*)aTouch{
	
}

@end
