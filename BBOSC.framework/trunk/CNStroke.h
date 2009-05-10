//
//  CNStroke.h
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

/**
 * \brief Classe CNStroke (colpo) rappresenta un oggetto attivo sulla scena.
 * \details Può essere un tocco, ma anche un qualsiasi altro elemento legato ad un oggetto attivo sulla scena (ad esempio Tangerine Cube).
 * Elementi di questa classe sono aggragati in un evento CNEvent.
 */

@interface CNStroke : NSObject {
	NSInteger strokeID;///<è l'identificativo dello CNStroke
	NSTimeInterval lifetime;///<indica l'istante in cui è stato rilevato lo CNStroke
	NSPoint position;///<indica la posizione dello CNStroke nella scena
	NSPoint velocity;

	NSMutableArray* strokePath;///<questo array mantiene lo storico dello CNStroke le varie posizioni
	CALayer* myLayer;///<è un puntatore al layer a cui viene associato lo CNStroke quando appare sulla scena
	CALayer* visLayer;///<è un puntatore al layer di visualizzazione
}

@property(assign) NSInteger strokeID;
@property(assign) NSTimeInterval lifetime;
@property(assign) NSPoint position;
@property(assign) NSPoint velocity;
@property(retain) NSMutableArray* strokePath;
@property(retain) CALayer* myLayer;
@property(retain) CALayer* visLayer;


@end
