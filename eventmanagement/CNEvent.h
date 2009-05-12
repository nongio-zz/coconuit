//
//  Event.h
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
#import "CNStroke.h"
#import "CNTouch.h"

/**
 * \brief Rappresenta un qualsiasi evento Multitouch.
 * \details Di fatto è la fotografia della scena ad un certo istante di tempo. L'evento è poi passato all'interfaccia. A Questa viene delegata
 * la responsabilità di assegnare a ciascuna area attiva i propri Strokes.
 */

@interface CNEvent : NSEvent {
	NSDate* timestamp;///<Istante di tempo identificativo dell'evento
	NSMutableArray* strokes;///<Array che aggrega gli Strokes che costituiscono l'evento
}

@property (retain) NSMutableArray* strokes;
@property (retain) NSDate* timestamp;

-(void)setStroke:(CNStroke*) aStroke;///<Permette di aggiungere dinamicamente uno stroke all'evento
-(CNStroke*)getStrokeByID:(NSInteger)strokeID;///<Permette di ottenere uno CNStroke in base all'ID
-(BOOL)removeStrokeByID:(NSInteger)aStrokeID;///<Permette di rimuovere uno CNStroke in base all'ID
-(BOOL)updateStroke:(CNStroke*)stroke;
@end
