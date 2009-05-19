//
//  CNTap.m
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

#import "CNTap.h"
#import "CNLayer.h"

@implementation CNTap

@synthesize touch;

-(id)init{
	if(self = [super init]){
		GestureName = @"CNTap";
		nTaps = 0;
		state = WaitingGesture;
		lastTapTimeStamp = 0;
		touch=Nil;
	}
	return self;
}

-(BOOL)recognize:(id)sender{
	
	if([sender isKindOfClass:[CNLayer class]]){
		NSMutableArray* gStrokes = [[sender myMultitouchEvent] strokes];
		
		if([gStrokes count]>0){
			if([gStrokes count]>1){
				if(touch==Nil){
					self.touch = [[CNTouch alloc] init];
				}
				[self groupStrokesToOne:gStrokes andUpdateTouch:touch];
			}
			else{
				self.touch = [[gStrokes lastObject] copy];
			}
		
		if(touch){
			double maxSingleTapInterval = [[GesturesParams objectForKey:@"MaxSingleTapInterval"] doubleValue];
			double maxDoubleTapInterval = [[GesturesParams objectForKey:@"MaxDoubleTapInterval"] doubleValue];
			//NSLog(@"%f",touch.lifetime);
			
			if(touch.type==NewTouch && touch.timestamp-lastTapTimeStamp>maxDoubleTapInterval){
				lastTapTimeStamp = touch.timestamp;
			}
			
			if(touch.lifetime<maxDoubleTapInterval && touch.type==ReleaseTouch){
				double x = touch.timestamp-lastTapTimeStamp;
				NSLog(@"%f",x);
				if(x<maxSingleTapInterval){
					state=EndGesture;
					nTaps=1;
					[sender performGesture:@"CNTap" withData:nil];
					state=WaitingGesture;
					lastTapTimeStamp = touch.timestamp;
				}
				else{
					state=EndGesture;
					nTaps=2;
					[sender performGesture:@"CNDoubleTap" withData:nil];
					lastTapTimeStamp=0;
					state=WaitingGesture;
					}
				return TRUE;
				}
			}
		}
		}
	return FALSE;
}

- (void)groupStrokesToOne:(NSMutableArray*)strokes andUpdateTouch:(CNTouch*)aTouch{
	NSMutableArray* points = [[NSMutableArray alloc] init];
	int touchType = aTouch.type;
	for(CNStroke* S in strokes){
		if([S isKindOfClass:[CNTouch class]]){
			CNTouch* t = (CNTouch*) S;
			
			if(t.type==ReleaseTouch){
				touchType = ReleaseTouch;
			}
			
			[points addObject:[NSValue valueWithPoint:t.position]];
			}
		}
	
	NSPoint gCenter = getCenterPoint(points);
	[aTouch updateWithPoint:gCenter andTouchType:touchType];
}

@end
