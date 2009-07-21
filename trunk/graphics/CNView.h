//
//  CNLayer.h
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
//  Copyright 2009 Riccardo Canalicchio <riccardo.canalicchio@gmail.com>.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/CoreAnimation.h>
#import <Quartz/Quartz.h>
#import "CNGesture.h"
#import "CNLayer.h"
#import "CNTuioDispatcher.h"
#import "CNEvent.h"

/**
 * \brief CNView inherit from NSView that defines the basic drawing, event-handling, and printing architecture of an application.\n
 * It hold the layer tree hierarchy and Its task is to dispatch the strokes to the proper active layer.
 * \details After its initialization, It must be registered at the notification center for the "newCNEvent" messages.\n
 *\par
 * Right now the dispatch is only for touches. The dispatch of touches is based on their position, looking if they fall into an active layer.\n
 * After a touch is associate to an active area, a reference to the layer is stored in the activerLayers array\n
 * and at the end of the dispatch the recognizeGesture method of each active layer is called.\n
 */

@interface CNView : NSView {
	NSMutableArray* activeLayers;///<Keep a list of the active layers that contain strokes
}

@property (retain) NSMutableArray* activeLayers;

- (void)setupLayers;///<Called automatically after initializzation, provide a first setup of the layers.
-(CNLayer*)activeLayerHitTest:(CGPoint)point;///<Hit test for the active layers inside the viewLayer.
-(CNLayer*) findActiveLayer:(CALayer*)alayer;///<Starting from the CALayer passed as parameter, go up through the layer three. Return the first CNLayer finded if exist else return nil.

- (void)newCNEvent:(NSNotification *)notification;///<Callback function called from notification center. Dispatch the strokes and call recognize gesture on each active layer.

@end
