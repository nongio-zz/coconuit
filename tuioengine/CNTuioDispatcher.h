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

///Classe per la gestione di messaggi Tuio
@interface CNTuioDispatcher : CNOscMessageDispatcher <QTObservableProtocol>{
	NSMutableDictionary * activeBlobs;///<Lista di Blob attivi
	NSMutableArray* observers;
}

@property (retain) NSMutableDictionary* activeBlobs;
//@property (retain,readonly) NSArray* observers;

-(NSString*)keyForID:(NSInteger)num;
-(void)processSet:(NSArray*)args;///<Processa i messsaggi Set del protocollo Tuio
-(void)processAlive:(NSArray*)args;///<Processa i messsaggi Alive del protocollo Tuio
-(void)processFseq:(NSArray*)args;///<Processa i messsaggi FSec del protocollo Tuio
-(void)processSource:(NSArray*)args;///<Processa i messsaggi Source del protocollo Tuio
-(void)dispatchMessage:(BBOSCMessage*)message;///<Metodo per la gestione dei messaggi Tuio

@end
