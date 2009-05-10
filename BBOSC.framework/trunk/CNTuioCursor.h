//
//  CNTuioCursor.h
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
#import <QuartzCore/CoreAnimation.h>


/**
 * \brief Classe cursore rappresenta un Blob nella scena
 * \details Istanze di questa classe vengono raccolte nella lista di cursori activeBlobs, mantenuta aggiornata dal CNTuioDispatcher. \n
 * Ciascuno dei cursori rappresenta un Blob per mezzo dei suoi attributi.
 */

@interface CNTuioCursor : NSObject {
	NSInteger cursorID;///<E' l'ID del Blob nella scena. Valore unico e non ripetibile per una sessione
	NSPoint position;///<E' un punto 2D che corrisponde alla posizione del Blob nella scena. Gli attributi del punto sono due float X e Y rispettivamente ascissa e ordinata.
	float xVelo;///<E' la componente orizzontale della velocità del Blob
	float yVelo;///<E' la componente verticale della velocità del Blob
	float accel;///<E' l'accelerazione del Blob
}

@property (assign) NSInteger cursorID;
@property (assign) NSPoint position;
@property (assign) float xVelo;
@property (assign) float yVelo;
@property (assign) float accel;


- (id) initWithArgs:(NSArray*)args;

@end
