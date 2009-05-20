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
 * \brief Represents a SnapShot of the real scene
 * \details An instance of this class is passed by copy to the view. The view has to assign each stroke to the own right area. 
 */

@interface CNEvent : NSEvent {
	NSTimeInterval timestamp;///<CNEvent timestamp
	NSMutableArray* strokes;///<Keep the CNEvent's Strokes list
}

@property (retain) NSMutableArray* strokes;
@property (assign) NSTimeInterval timestamp;

-(void)setStroke:(CNStroke*) aStroke;///<Add a stroke to the CNEvent
-(CNStroke*)getStrokeByID:(NSInteger)strokeID;///<Get a Stroke by ID
-(BOOL)removeStrokeByID:(NSInteger)aStrokeID;///<Remove a Stroke from the CNEvent by ID

@end
