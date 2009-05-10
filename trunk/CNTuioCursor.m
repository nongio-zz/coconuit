//
//  CNTuioCursor.m
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

#import "CNTuioCursor.h"


@implementation CNTuioCursor

@synthesize cursorID;
@synthesize position;
@synthesize xVelo;
@synthesize yVelo;
@synthesize accel;

// this is the main method, takes the raw argument array and decodes it into
// the proper spots

- (id) initWithArgs:(NSArray*)args{
	// args should be in the form:
	//s { set }, set command, ignore this
	//i { 114 }, id num
	//f { 0.576717 }, xpos
	//f { 0.466031 }, y pos
	//f { -0.413917 }, x velo
	//f { 1.690815 }, y velo
	//f { 0.405713 } accel
	
	self = [super init];
	if (self != nil) {
		// check to make sure it is at least the right size
		if ([args count] < 7) return nil;
		
		// great, no check to see if it is the right kind of argument
		NSString * setString = [[[args objectAtIndex:0] stringValue] lowercaseString];
		if (![setString isEqualToString:@"set"]) return nil;
		
		// ok great, if we got here then we will presume that everything is in order
		self.cursorID = [[args objectAtIndex:1] intValue];
		
		NSPoint pos;
		pos.x = [[args objectAtIndex:2] floatValue];
		pos.y = [[args objectAtIndex:3] floatValue];
		self.position = pos;
		
		self.xVelo = [[args objectAtIndex:4] floatValue];
		self.yVelo = [[args objectAtIndex:5] floatValue];
		
		self.accel = [[args objectAtIndex:6] floatValue];
	}
	return self;
}
@end
