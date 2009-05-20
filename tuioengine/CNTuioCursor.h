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
 * \brief This class represents a cursor in the scene
 * \details Instances of this class have been collected in the ActiveBlobs Cursors Array, an attribute of the CNTuioDispatcher Class. The CNTuioDispatcher keeps updated ActiveBlobs.\n
 * Each cursors represents a Blob.
 * 
 */

@interface CNTuioCursor : NSObject {
	NSInteger cursorID;///<The Blob ID given by the sensible engine. This value appears only one time for each session.
	NSPoint position;///<Bidimensional point that represents to the Blob's position. X and Y values are double. 
	float xVelo;///<Blob's Horizontal velocity component's value
	float yVelo;///<Blob's Vertical velocity component's value
	float accel;///<Blobs acceleration...
}

@property (assign) NSInteger cursorID;
@property (assign) NSPoint position;
@property (assign) float xVelo;
@property (assign) float yVelo;
@property (assign) float accel;


- (id) initWithArgs:(NSArray*)args;

@end
