//
//  CN2dVect.m
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

#import "CN2dVect.h"


@implementation CN2dVect

@synthesize x,y,z,unitVector,module;

-(id)initWithPoint:(NSPoint)p1 andPoint:(NSPoint)p2{
	if(self = [super init]){
		x = p2.x - p1.x;
		y = p2.y - p1.y;
		z=0;
		
		module = sqrt(pow(x,2)+pow(y,2));
		
		unitVector.x = x/module;
		unitVector.y = y/module;
	}
	return self;
}

@end
