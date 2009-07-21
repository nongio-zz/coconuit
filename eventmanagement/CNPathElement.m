//
//  CNPathElement.m
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

#import "CNPathElement.h"


@implementation CNPathElement

@synthesize position;
@synthesize velocity;
@synthesize timestamp;

- (id) initWithPosition:(NSPoint)aPosition andVelocity:(NSPoint)aVelocity andTime:(NSTimeInterval)aTime{
	if(self=[super init]){
		position = aPosition;
		velocity = aVelocity;
		timestamp = aTime;
	}
	return self;
}

@end
