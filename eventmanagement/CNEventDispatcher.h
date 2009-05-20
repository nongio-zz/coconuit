//
//  CNEventDispatcher.h
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
#import "CNEvent.h"
#import "CNObserverProtocol.h"

/**
 *\brief This class represents the center of creation and dispatching for CNEvent instances.
 *\details This class register itself like observer to the TuioDispacher. It creates instances of CNEvent and notifies it with the Cocoa NSNotificationCenter.
 * It is important to notice that the notification is synchronous with the changing of the scene.
 *
 */

@interface CNEventDispatcher : NSObject <CNObserverProtocol> {
	bool connected;///<Keep the OSCConnection state 
	BBOSCListener* OscListener;///<Keep the OSCListener like class attribute
	CNTuioDispatcher* TuioMessageDispatcher;///<Keep the CNTuioMessageDispatcher like class attribute
	CNEvent* myEvent;///<Is the current Event that will be dispatched. It is updated for each CNTuioMessageDispatcher notify.
	NSDictionary* OldCursors;///<Stores the previous step cursors state. It is useful to know which cursors are disappeared and to get some info like cursor's velocity and acceleration.
	NSDictionary* NewCursors;///<Represents the actual cursors state.
}


- (void)notify:(id)anObject;///<let start listening the BBOscListener on the specified port 
- (void)startListeningOnPort:(int) port;///<manage the notify from the CNTuioDispatcher

@end
