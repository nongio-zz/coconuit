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

@synthesize OscListener;

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

- (void)startListeningOnPort:(int) port{
	BBOSCListener* TempListener = [[BBOSCListener alloc] init];///Si istanzia l'OscListener
	
	[TempListener setDelegate:TuioMessageDispatcher];///Si imposta il delegato per la gestione dei messaggi Osc
	
	[TempListener startListeningOnPort:port];///Si avvia l'OscListener sulla porta specificata

	self.OscListener = [TempListener retain];// keep a copy for myself
	connected = TRUE;
}

-(void)notify:(id)anObject{
	if([anObject isKindOfClass:[NSMutableDictionary class]]){
		OldCursors = [NewCursors copy];//Se Nil forse da' errore
		NewCursors = (NSMutableDictionary*)[anObject copy];
		
		NSArray* OldCursorsKeys = [OldCursors allKeys];
		NSArray* NewCursorsKeys = [NewCursors allKeys];
		
		CNEvent*eventcopy = [myEvent copy];
		
		for(CNTouch* touch in myEvent.strokes){
			if(touch.type == ReleaseTouch){
				[eventcopy removeStrokeByID:touch.strokeID];
			}
		}
		myEvent = eventcopy;

		for (id key in OldCursorsKeys){
			if(![NewCursors objectForKey:key]){
				CNTouch* TempTouch =(CNTouch*) [myEvent getStrokeByID:[key intValue]];
				[TempTouch setRelease];
			}
			else{
				CNTouch* TempTouch = (CNTouch*) [myEvent getStrokeByID:[key intValue]];
				//Calculate velocity from points and timestamp
				//Farei una struttura dati punto e tempo che poi va anche caricata nel Path
				TempTouch.type = UpdateTouch;
				[TempTouch updateWithCursor:[NewCursors objectForKey:key]];
				
			}
		}
		
		for (id key in NewCursorsKeys){
			if(![OldCursors objectForKey:key]){
				CNTouch* newTouch = [[CNTouch alloc] initWithCursor:(CNTuioCursor*) [NewCursors objectForKey:key]];//la velocità a zro va messa nell'inizializzatore di tocco
				//come il timestamp etc etc
				[newTouch setVelocity:NSMakePoint(0,0)];
				[myEvent setStroke:newTouch];
			}
		}
		if([myEvent.strokes count]>0){
			[[NSNotificationCenter defaultCenter] postNotificationName:@"newEvent" object:[myEvent copy]];
		}
	}
}

/*
 - (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context{
 if(keyPath==@"activeBlobs"){
 //Qui c'è Da creare l'evento inserire gli Strokes - I tocchi decidendo il Tipo etc etc
 CNTuioDispatcher* TempTuioDisp = object;
 
 if([change objectForKey:NSKeyValueChangeNewKey]){
 OldCursors = [NewCursors copy];//Se Nil forse da' errore
 NewCursors = [[TempTuioDisp.activeBlobs copy] retain];
 
 NSArray* OldCursorsKeys = [OldCursors allKeys];
 NSArray* NewCursorsKeys = [NewCursors allKeys];
 
 for(CNTouch* touch in myEvent.strokes){
 if(touch.type == ReleaseTouch){
 [myEvent removeStrokeByID:touch.strokeID];
 }
 }
 
 for (id key in OldCursorsKeys){
 if(![NewCursors objectForKey:key]){
 CNTouch* TempTouch =(CNTouch*) [myEvent getStrokeByID:[key intValue]];
 [TempTouch setRelease];
 }
 else{
 CNTouch* TempTouch = (CNTouch*) [myEvent getStrokeByID:[key intValue]];
 //Calculate velocity from points and timestamp
 //Farei una struttura dati punto e tempo che poi va anche caricata nel Path
 TempTouch.type = UpdateTouch;
 [TempTouch updateWithCursor:[NewCursors objectForKey:key]];
 
 }
 }
 
 for (id key in NewCursorsKeys){
 if(![OldCursors objectForKey:key]){
 CNTouch* newTouch = [[CNTouch alloc] initWithCursor:(CNTuioCursor*) [NewCursors objectForKey:key]];//la velocità a zro va messa nell'inizializzatore di tocco
 //come il timestamp etc etc
 [newTouch setVelocity:NSMakePoint(0,0)];
 [myEvent setStroke:newTouch];
 }
 }
 if([myEvent.strokes count]>0){
 [[NSNotificationCenter defaultCenter] postNotificationName:@"newEvent" object:[myEvent copy]];
 }
 }
 
 }
 }
 */
@end
