//
//  CNLayerModifier.h
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

#import <Cocoa/Cocoa.h>
#import "CNEvent.h"

/**
 *\brief Questa classe implementa il modificatore di Layer.
 *\details Riceve l'insieme di Strokes attivi sul layer e li passa al riconoscitore di gesti. 
 * In base al gesto ritornato dal riconoscitore modifica il layer a cui è associato.
 */

@interface CNLayerModifier : NSObject {
	
}

-(void)drawTCLayer:(id)sender;///<Metodo invocato dal Layer per essere ridisegnato

-(void)singleTap;
-(BOOL)rotateLayer:(id)aLayer;///<Metodo per ruotare il Layer
-(BOOL)scaleLayer:(id)aLayer;///<Metodo per ridimensionare il Layer
-(BOOL)selectLayer:(id)aLayer;///<Metodo per impostare il Layer come selezionato
-(BOOL)releaseLayer:(id)aLayer;///<Metodo per rilasciare il Layer
-(BOOL)dragLayer:(id)aLayer;///<Metodo per trascinare il Layer

@end
