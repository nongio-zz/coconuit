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


///Controller MVC

/**
 * Questa classe implementa il Controller per l'applicazione secondo il pattern MVC. Fa da ponte tra il Modello (OscListener,CNTuioDispatcher) e la vista.
 */

@interface CNAppController : NSObject {
	BOOL connected;///< Flag che indica se il Client è connesso o meno
	BBOSCListener* OscListener;///<Puntatore all'OscListener
	CNTuioDispatcher* TuioMessageDispatcher;///<Puntatore al CNTuioDispatcher
	CNEventDispatcher* myEventDispatcher;///<Puntatore all'CNEventDispatcher
	NSNotificationCenter* myNotificationCenter;///<Puntatore al centro di notifica del Task
//	IBOutlet NSButton* connectionButton;
//	IBOutlet NSTextView* textView;
	IBOutlet NSWindow * mainWindow;
	CGDisplayFadeReservationToken tok;
	CNView* myTCView;
}


@property (retain) BBOSCListener* OscListener;

-(IBAction)fullscreen:(id)sender;
-(void)fadeIn;
-(void)fadeOut;
@end
