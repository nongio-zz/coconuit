//
//  CNOscMessageDispatcher.m
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

#import "CNOscMessageDispatcher.h"
#import "BBOSCDecoder.h"
#import "BBOSCBundle.h"

@implementation CNOscMessageDispatcher

-(id)init{
	self = [super init];
	
	return self;
}

///this is called by the OSCListener with the raw packet data
-(void)dispatchRawPacket:(NSData*)someData
{
	// all we really care about right now are TUIO/2DCur messages
	// these come in bundles, so any non-bundle will be ignored
	id decodedPacket = [BBOSCDecoder decodeData:someData];
	if (![decodedPacket isKindOfClass:[BBOSCBundle class]]) return;
	
	// decompress the bundle into it's contained messages, 
	// dispatch each one individually
	
	for (BBOSCMessage * message in [decodedPacket attachedObjects]) {
		[self dispatchMessage:message];
	}
}

-(void)dispatchMessage:(BBOSCMessage*)message{
	//empty for subclass
}

-(void)dealloc{
	[super dealloc];
}

@end
