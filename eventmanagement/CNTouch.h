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
 * \brief It is a special kind of Stroke, for example a simple fingertip touch on the tabletop.
 * \details Instances of this class are collected in a CNEvent.\n
 * CNTouches could be of three different types:\n
 * - NewTouch, the touch is just appeared in the scene
 * - UpdateTouch, the touch is still in the scene, doing something
 * - ReleaseTouch, the cursor linked to the touch is disappeared from the scene
 *
 */

@interface CNTouch : CNStroke {
	TouchType type;///<CNTouch type
	NSTimeInterval timestamp;///<CNTouch actual timestamp
	CNTuioCursor* cursor;///<keep the lowlevel object linked to the CNTouch
}

@property (assign) TouchType type;
@property (assign) NSTimeInterval timestamp;
@property (retain) CNTuioCursor* cursor;

-(CNTouch*)init;///<create a new Touch without a specified position
-(CNTouch*)initWithCursor:(CNTuioCursor*)aCursor;///<create a new Touch from a cursor [NewTouch]
-(void)updateWithCursor:(CNTuioCursor*)aCursor;///<update the Touch with the linked cursor [UpdateTouch]
-(void)setRelease;///<release the touch when the linke cursor disappears from the scene [ReleaseTouch]
-(NSString*)stringValue;///<get a string that describes the Touch
-(void)updateWithPoint:(NSPoint)aPoint andTouchType:(TouchType) aType;///<update the Touch with the new calculated position

@end
