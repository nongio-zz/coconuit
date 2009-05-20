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
 * \brief Represents an active element in the real scene, something like a touch or other tangible subject.
 * \details Instances of this class are collected in a CNEvent
 * 
 */

@interface CNStroke : NSObject {
	NSInteger strokeID;///<is the CNStroke ID
	NSTimeInterval lifetime;///<is the CNStroke lifetime since its birth
	NSPoint position;///<is the CNStroke position
	NSPoint velocity;///<is the CNStroke velocity

	NSMutableArray* strokePath;///<keep the stroke's history
}

@property(assign) NSInteger strokeID;
@property(assign) NSTimeInterval lifetime;
@property(assign) NSPoint position;
@property(assign) NSPoint velocity;
@property(retain) NSMutableArray* strokePath;

@end
