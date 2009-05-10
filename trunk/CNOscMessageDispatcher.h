//
//  CNOscMessageDispatcher.h
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
#import <BBOSC/BBOSCMessage.h>

///Generica classe per la gestione di messaggi OSC
@interface CNOscMessageDispatcher : NSObject {

}
-(void)dispatchRawPacket:(NSData*)someData;///<gestisce un pacchetto grezzo - lo trasforma in messaggio
-(void)dispatchMessage:(BBOSCMessage*)message;///<gestisce il messaggio - implementato dalle classi figlie

@end
