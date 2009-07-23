//
//  CNEventDispatcher.m
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

#import "CNEventDispatcher.h"


@implementation CNEventDispatcher

-(id)init{
	if(self = [super init]){
		connected = FALSE;
		myEvent = [[CNEvent alloc] init];
		OldCursors = Nil;
		NewCursors = Nil;
		OscListener = Nil;
		TuioMessageDispatcher = [[CNTuioDispatcher alloc] init];
		[TuioMessageDispatcher addObserver:self];
	}
	return self;
}

-(void)dealloc{
	[myEvent release];
	[OldCursors release];
	[NewCursors release];
	[OscListener release];
	[TuioMessageDispatcher release];
	[super dealloc];
}


- (void)startListeningOnPort:(int) port{
	BBOSCListener* TempListener = [[BBOSCListener alloc] init];///create the BBOSCListener
	
	[TempListener setDelegate:TuioMessageDispatcher];///set the TuioMessageDispatcher like delegate for the BBOSCListener instance
	
	[TempListener startListeningOnPort:port];///start listening 

	OscListener = [TempListener retain];///keep the new OSCListener instance
	
	connected = TRUE;///set TRUE the connection state
}


-(void)notify:(id)anObject{
	if([anObject isKindOfClass:[NSMutableDictionary class]]){
		[OldCursors release];

		OldCursors = [NewCursors copy];///keep previous cursors state
		[NewCursors release];
		NewCursors = (NSMutableDictionary*)[anObject mutableCopy];///keep new cursors state
		
		NSArray* OldCursorsKeys = [OldCursors allKeys];
		NSArray* NewCursorsKeys = [NewCursors allKeys];
		
		//Keep a copy to update the current event in safety
		CNEvent* eventcopy = [myEvent copy];
		
		for(CNTouch* touch in myEvent.strokes){
			if(touch.type == ReleaseTouch){
				[eventcopy removeStrokeByID:touch.strokeID];///remove the Touches that have been set as Release at the previous step
			}
		}
		[myEvent release];
		myEvent = eventcopy;

		for (id key in OldCursorsKeys){
			if(![NewCursors objectForKey:key]){
				CNTouch* TempTouch =(CNTouch*) [myEvent getStrokeByID:[key intValue]];
				[TempTouch setRelease];///set as Release the Touches linked to disappeared cursors
			}
			else{
				CNTouch* TempTouch = (CNTouch*) [myEvent getStrokeByID:[key intValue]];
				//Calculate velocity from points and timestamp
				TempTouch.type = UpdateTouch;///update the Touches in the CNEvent instance
				[TempTouch updateWithCursor:[NewCursors objectForKey:key]];
			}
		}
		for (id key in NewCursorsKeys){
			if(![OldCursors objectForKey:key]){
				CNTuioCursor*acursor = (CNTuioCursor*) [NewCursors objectForKey:key];
				CNTouch* newTouch = [[CNTouch alloc] initWithCursor:acursor];//la velocità a zro va messa nell'inizializzatore di tocco
				///create a new Touch linked to the new cursor in the scene
				[newTouch setVelocity:NSMakePoint(0,0)];
				[myEvent setStroke:newTouch];///add the new Touch to the CNEvent instance
				[newTouch release];
			}
		}
		if([myEvent.strokes count]>0){
			myEvent.timestamp = [[NSDate date] timeIntervalSinceReferenceDate];///update the CNEvent instance timestamp
			CNEvent*notificationEvent = [myEvent copy];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"newCNEvent" object:notificationEvent];///notify a new CNEvent [[NSNotificationCenter defaultCenter] postNotificationName:@"newCNEvent" object:[myEvent copy]];
			[notificationEvent release];
		}
	}
}

@end
