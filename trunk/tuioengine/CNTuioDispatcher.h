//
//  CNTuioDispatcher.h
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
#import "CNObserverProtocol.h"
#import "CNOscMessageDispatcher.h"

/// \brief This Class let to menage Tuio Messages
/// \details This Class implements the CNObservableProtocol. Every class who wants to observe it has to register like Observer using the method addObserver:. \n
/// When CNTuioDispatcher gets a Tuio FSEQ message it notifies the Observers about the active Cursors state.
@interface CNTuioDispatcher : CNOscMessageDispatcher <CNObservableProtocol>{
	NSMutableDictionary * activeBlobs;///<Active Cursors List
	NSMutableArray* observers;///<Observer Objects List
}

@property (retain) NSMutableDictionary* activeBlobs;

-(NSString*)keyForID:(NSInteger)num;///<A nice quick way to grab the identified cursors out of a dictionary
-(void)processSet:(NSArray*)args;///<Process Tuio Set messages
-(void)processAlive:(NSArray*)args;///<Process Tuio Set messages
-(void)processFseq:(NSArray*)args;///<Process Tuio Set messages
-(void)processSource:(NSArray*)args;///<Process Tuio Set messages
-(void)dispatchMessage:(BBOSCMessage*)message;///<Read OSC messages and dispatch it

@end
