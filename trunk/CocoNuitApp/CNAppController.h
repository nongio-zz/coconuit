//
//  CNAppController.h
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


#import <Cocoa/Cocoa.h>
#import "BBOSCListener.h"
#import "CNTuioDispatcher.h"
#import "CNDebugView.h"
#import "CNView.h"
#import "CNEventDispatcher.h"

@interface CNAppController : NSObject {
	BOOL connected;
	BBOSCListener* OscListener;
	CNTuioDispatcher* TuioMessageDispatcher;
	CNEventDispatcher* myEventDispatcher;
	NSNotificationCenter* myNotificationCenter;
//	IBOutlet NSButton* connectionButton;
//	IBOutlet NSTextView* textView;
	IBOutlet NSWindow * mainWindow;
	CGDisplayFadeReservationToken tok;
	CNView* myTCView;
}


@property (retain) BBOSCListener* OscListener;

-(IBAction)fullscreen:(id)sender;
-(IBAction)toggleConnection:(id)sender;
-(void)connect:(int)port;
-(void)disconnect;
//-(void)observeValueForKeyPath:(NSString*) keyPath ofObject:(id) object change:(NSDictionary*) change context:(void*) context;///< Notifica aggiornamento Blobs
-(void)fadeIn;
-(void)fadeOut;
@end
