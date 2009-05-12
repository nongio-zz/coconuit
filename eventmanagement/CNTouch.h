//
//  CNTouch.h
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
#import "CNTuioCursor.h"
#import "CNStroke.h"

typedef enum TouchType {
	NewTouch,
	UpdateTouch,
	ReleaseTouch,
} TouchType;


/**
 * \brief Classe Tocco, rappresenta un Tocco sulla scena. E' blob sulla scena che può essere un polpastrello ma non solo.
 * \details Istanze di questa classe vengono raccolte in quello che è un Evento Multitouch CNEvent\n
 * i tocchi possono essere di tre tipi: \n
 * - NewTouch indica un tocco appena comparso nella scena
 * - UpdateTouch indica tocco già stato rilevato che ancora presente nella scena
 * - ReleaseTouch indica un tocco appena scomparso dalla scena
 */

@interface CNTouch : CNStroke {
	TouchType type;///<Indica il tipo di tocco
	NSTimeInterval timestamp;
	CNTuioCursor* cursor;///<E' un puntatore all'elemento di basso livello che genera il Tocco (CNStroke)
}

@property (assign) TouchType type;
@property (assign) NSTimeInterval timestamp;
@property (retain) CNTuioCursor* cursor;

-(CNTouch*)initWithCursor:(CNTuioCursor*)aCursor;///<Permette di inizializzare il tocco con un Cursore [NewTouch]
-(void)updateWithCursor:(CNTuioCursor*)aCursor;///<Aggiorna il tocco con il cursore relativo [UpdateTouch]
-(void)setRelease;///<Rilascia il tocco che è scomparso dalla scena [CNRelease]
-(NSString*)stringValue;///<Ritorna una stringa che descrive il Tocco
-(NSPoint) CalculateVelocityOfActualPosition:(NSPoint)aPosition fromPreviousPosition:(NSPoint)pPosition withTimeInterval:(NSTimeInterval)aTime;
-(void)updateWithPoint:(NSPoint)aPoint andTouchType:(TouchType) aType;
@end
