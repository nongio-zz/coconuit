//
//  CNPress.h
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
 * \brief It represents a specif Gesture. It recognizes a Press on the active area (CNLayer).
 * \details In this case a new Touch that appears in the specific area is recognized like a Press Gesture.
 *
 */


@interface CNPress : CNGesture {

}
-(BOOL)recognize:(id)sender;///<implements the Press GestureRecognition task

@end
