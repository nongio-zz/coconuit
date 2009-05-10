//
//  Event.m
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

#import "CNEvent.h"


@implementation CNEvent

@synthesize strokes;
@synthesize timestamp;

-(id)init{
	if(self = [super init]){
		self.timestamp = [NSDate date];//controllare che fa [NSDate timestamp]
		self.strokes = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void)setStroke:(CNStroke*)aStroke{
	[strokes addObject:[aStroke retain]];
}

-(CNStroke *)getStrokeByID:(NSInteger)aStrokeID{
	for (CNStroke* stroke in strokes){/*
		if([[[NSNumber numberWithInt:stroke.strokeID] stringValue] isEqual: aStrokeID]){
			return stroke;
		}*/
		if(stroke.strokeID == aStrokeID){
			return stroke;
		}
	}
	return Nil;
}
-(BOOL)updateStroke:(CNStroke*)stroke{
	NSInteger StrokeID = stroke.strokeID;
	for (CNStroke* mystroke in strokes){
		if(mystroke.strokeID == StrokeID){
			mystroke  = stroke;
			return YES;
		}
	}
	return NO;
}
-(BOOL)removeStrokeByID:(NSInteger)aStrokeID{
	for (int i=0; i<strokes.count; i++){
		CNStroke* tempStroke = (CNStroke*) [strokes objectAtIndex:i];
		if(tempStroke.strokeID == aStrokeID){
			[strokes removeObject:tempStroke];
			return YES;
		}
	}
	return NO;
}

-(id)copy{
	CNEvent* aEvent = [[CNEvent alloc] init];
	aEvent.timestamp = self.timestamp;
	
	NSMutableArray* anArray = [[NSMutableArray alloc] init];
	
	for(id stroke in self.strokes){
		[anArray addObject:[((CNTouch*)stroke) copy]];
	}
		 
		 aEvent.strokes = anArray;
	
	return aEvent;
}

@end
