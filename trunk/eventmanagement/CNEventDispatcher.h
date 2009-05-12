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
 *\brief Questa classe rappresenta il centro creazione e smistamento eventi.
 *\details Questa classe si registra come osservatore su i generatori di eventi di basso livello. Si occupa di creare eventi multitouch istanziando, 
 * oggiornando o rimuovendo gli Strokes. Quindi notifica il nuovo evento all'Interfaccia grafica per mezzo del NotificationCenter.
 */

@interface CNEventDispatcher : NSObject <CNObserverProtocol> {
	bool connected;
	BBOSCListener* OscListener;
	CNTuioDispatcher* TuioMessageDispatcher;
	CNEvent* myEvent;///<E' il puntatore all'evento corrente
	NSDictionary* OldCursors;///<Mantiene lo stato dei cursori nella scena al passo precente. Utile per riconosce se un tocco è nuovo, aggiornato o rimosso
	NSDictionary* NewCursors;///<Rappresenta lo stato attuale dei cursori nella scena.
}

@property (retain) BBOSCListener* OscListener;

- (void)startListeningOnPort:(int) port;
//- (void)observeValueForKeyPath:(NSString*) keyPath ofObject:(id) object change:(NSDictionary*) change context:(void*) context;///<Questo metodo gestisce la notifica delle modifiche da parte degli oggetti presso i quali l'CNEventDispatcher si è registrato come osservatore.

@end
