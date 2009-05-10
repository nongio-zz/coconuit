//
//  CNLayerModifier.h
//  TuioClient
//
//  Created by Nicola Martorana on 19/03/09.
//  Copyright 2009 Unifi. All rights reserved.
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
