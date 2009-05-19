//
//  CNTuioDispatcher.m
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

#import "CNTuioDispatcher.h"
#import "CNTuioCursor.h"

@implementation CNTuioDispatcher

@synthesize activeBlobs;

- (id) init
{
	self = [super init];
	if (self != nil) {
		// setup my storage
		activeBlobs = [[NSMutableDictionary alloc] init];
		observers = [[NSMutableArray alloc] init];
	}
	return self;
}

// this is a specific implementation designed for the TUIO/2DCur messages

// the come in four types: (and in this order, generally)

// source - defines where the packets are coming from
// set - this adds new 'events', could be old blob ids or new ones
// alive - this tells us which blobs (including the ones just set) that are still alive
// fseq - this signals the end of this frame, and gives a sequence number, in theory the frames can come out of order, and we should be looking for that, but not for this app


-(void)dispatchMessage:(BBOSCMessage*)message{
	
	// need to figure out what kind of message it is
	// lowercase all the strings to make it easier to match up
	NSString * addy = [[[message address] address] lowercaseString];
	
	// for now, just check to make sure it is what we think it is
	// not a TUIO/2DCur? then ignore it
	if (![addy isEqualToString:@"/tuio/2dcur"]) return;
	
	// now for the 'command'
	NSString * command = [[[[message attachedObjects] objectAtIndex:0] stringValue] lowercaseString];
	
	// a bit of manual hackery. this could be nicer
	if ([command isEqualToString:@"fseq"]) {
		
		[self processFseq:[message attachedObjects]];
		
		return;
	}
	
	if ([command isEqualToString:@"alive"]) {
		[self processAlive:[message attachedObjects]];
		return;
	}
	
	if ([command isEqualToString:@"source"]) {
		[self processSource:[message attachedObjects]];
		return;
	}
	
	if ([command isEqualToString:@"set"]) {
		[self processSet:[message attachedObjects]];
		return;
	}
}

// just a nice quick way to grab the identified cursors out of a 
// dictionary
-(NSString*)keyForID:(NSInteger)num
{
	// just the ID in string form
	return [NSString stringWithFormat:@"%d",num];
}

-(void)processSet:(NSArray*)args{
	// make a enw cursor from the arg array
	CNTuioCursor * cursor = [[CNTuioCursor alloc] initWithArgs:args];
	// put it into the active blob collection
	
	[activeBlobs setObject:cursor forKey:[self keyForID:[cursor cursorID]]];
}

-(void)processAlive:(NSArray*)args{
	// we are going to put all the still breathing blobs into
	// a temporary storage, then clear the active blobs
	// then put the still breathing ones back into the active list
	NSMutableDictionary * blobStorage = [NSMutableDictionary dictionary];
	int i;
	
	// ignore the first arg, it is the 'set' string
	for (i = 1; i < [args count]; i++) {
		// get the key from the arg list
		NSString * key = [self keyForID:[[args objectAtIndex:i] intValue]];
		
		//NSLog(@"Alive ID=%@",key);
		// grab the cursor out of the active list and add it to the storage
		CNTuioCursor* cursor = (CNTuioCursor*) [activeBlobs objectForKey:key];
		

		if(cursor!=nil){
			[blobStorage setObject:cursor forKey:key];
		}
			
	}
	
	// any blobs left in the storage get obliterated here
	[activeBlobs removeAllObjects];
	
	// move all the still breathing blobs back into storage
	[activeBlobs addEntriesFromDictionary:blobStorage];
	//[self setActiveBlobs:[self activeBlobs]];
}

-(void)processFseq:(NSArray*)args{
	[observers makeObjectsPerformSelector:@selector(notify:) withObject:activeBlobs];//notify the observers or send an event
}

-(void)processSource:(NSArray*)args{

}

- (void) dealloc
{
	[activeBlobs release];
	[super dealloc];
}

-(void)addObserver:(id)anObject{
	if([anObject conformsToProtocol:@protocol(CNObserverProtocol)]){
		[observers addObject:anObject];
	}
}

-(void)removeObserver:(id)anObject{
		[observers removeObject:anObject];
}

@end
