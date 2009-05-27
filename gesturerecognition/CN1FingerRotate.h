//
//  CN1FingerRotate.h
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
#import "CNGesture.h"

/**
 * \brief It represents a specif Gesture. It recognizes a OneFinger rotation gesture on the active area (CNLayer).
 * \details In this case we try to track the rotation movement of a single touch that moves in the active area for a long time.
 * For this gesture is needed a center for the rotation. In this case the anchor point of the active area is taken like rotation center.
 * Every CALayer has the AnchorPoint attribute.
 */

@interface CN1FingerRotate : CNGesture {
	float angle;///<keeps the rotation angle
	float angularVelocity;///<keeps the rotation angular velocity
}

@property(assign) float angle;
@property(assign) float angularVelocity;

-(BOOL)recognize:(id)sender;

@end
