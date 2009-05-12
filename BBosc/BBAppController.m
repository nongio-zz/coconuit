//
//  BBAppController.m
//  BBOSC-Cocoa
//
//  Created by ben smith on 7/18/08.
//  This file is part of BBOSC-Cocoa.
//
//  BBOSC-Cocoa is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.

//  BBOSC-Cocoa is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Lesser General Public License for more details.

//  You should have received a copy of the GNU Lesser General Public License
//  along with BBOSC-Cocoa.  If not, see <http://www.gnu.org/licenses/>.
// 
//  Copyright 2008 Ben Britten Smith ben@benbritten.com .
//
//
//

#import "BBAppController.h"
#import "BBOSCArgument.h"
#import "BBOSCListener.h"
#import "BBOSCDispatcher.h"
#import "BBOSCDataUtilities.h"
#import "BBOSCMessage.h"
#import "BBOSCBundle.h"
#import "BBOSCDecoder.h"
#import "BBOSCSender.h"
#import "BBOSCAddress.h"


@implementation BBAppController

@synthesize oscListener;
@synthesize oscSender;

-(void)awakeFromNib
{
	[self doTest];
}

// just some tests and sample code basically

-(void)doTest
{
	// data test
	NSString * testString = @"Is this thing on?";
	NSData * testData = [testString dataUsingEncoding:NSASCIIStringEncoding];
	
	// make a new listener, use the default (which generates it's own delegate)
	[self setOscListener:[BBOSCListener defaultListenerOnPort:4556]];
	
	// make a new test message
	BBOSCMessage * newMessage = [BBOSCMessage messageWithBBOSCAddress:[BBOSCAddress addressWithString:@"/test/1/groovy"]];
	[newMessage attachArgument:[BBOSCArgument argumentWithString:@"Testing!!"]];
	[newMessage attachArgument:[BBOSCArgument argumentWithInt:12]];
	[newMessage attachArgument:[BBOSCArgument argumentWithFloat:3.1234]];
	[newMessage attachArgument:[BBOSCArgument argumentWithDataBlob:testData]];
	[newMessage attachArgument:[BBOSCArgument argumentWithString:@"test test test"]];
		
	// make a new sender, attach it to the localhost and the same port
	// as the listener, so we can talk to ourselves
	// note: the host name also works with IP addys like so: @"127.0.0.1"
	[self setOscSender:[BBOSCSender senderWithDestinationHostName:@"localhost" portNumber:4556]];
	
	// send the message to ourselves
	// the dispatcher should handle it
	if (![[self oscSender] sendOSCPacket:newMessage]) {
		NSLog(@"Oh Noes!!");
	}
	
	/// make a second message
	BBOSCMessage * newMessage2 = [BBOSCMessage messageWithBBOSCAddress:[BBOSCAddress addressWithString:@"/test/2/bundle"]];
	[newMessage2 attachArgument:[BBOSCArgument argumentWithString:@"Bundle bundle bundle"]];
	[newMessage2 attachArgument:[BBOSCArgument argumentWithInt:-567]];
	[newMessage2 attachArgument:[BBOSCArgument argumentWithFloat:-4.52734]];
	[newMessage2 attachArgument:[BBOSCArgument argumentWithDataBlob:testData]];
	[newMessage2 attachArgument:[BBOSCArgument argumentWithString:@"i made it out of clay...bundle bundle bundle, a bundle i will play"]];
	
	// make a bundle with both messages
	BBOSCBundle * newBundle = [BBOSCBundle bundleWithTimestamp:[NSDate date]];
	[newBundle attachObject:newMessage];
	[newBundle attachObject:newMessage2];
	// note, i could make another bundle and attach it to this bunlde and so on
	
	// send myself the bundle
	if (![[self oscSender] sendOSCPacket:newBundle]) {
		NSLog(@"Oh Noes!!");
	}
	
}

@end
