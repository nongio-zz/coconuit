//
//  CNTouch.m
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

#import "CNTouch.h"
#import "CNPathElement.h"
#import "CNMath.h"


@implementation CNTouch

@synthesize cursor;
@synthesize type;
@synthesize timestamp;

-(CNTouch*)init{
	if(self = [super init]){
		strokeID = 666;
		type = NewTouch;
		cursor = nil;
		position = NSMakePoint(0,0);
		velocity = NSMakePoint(0,0);
		lifetime = 0;
		timestamp = [[NSDate date] timeIntervalSinceReferenceDate];
		strokePath = [[NSMutableArray alloc] init];
		
	}
	return self;
}

-(CNTouch*)initWithCursor:(CNTuioCursor*)aCursor{
	
	if(self = [super init]){
		strokeID = [aCursor cursorID];
		type = NewTouch;
		cursor = [aCursor retain];
		position = [aCursor position];
		velocity = NSMakePoint(0,0);
		lifetime = 0;
		timestamp = [[NSDate date] timeIntervalSinceReferenceDate];
		strokePath = [[NSMutableArray alloc] init];
		CNPathElement* newPathElement = [[CNPathElement alloc] initWithPosition:position andVelocity:velocity andTime:timestamp];
		[strokePath addObject:newPathElement];
		[newPathElement release];
	}
	
	return self;
}
-(void)dealloc
{
	NSLog(@"dealloc cntouch");
	[cursor release];
	[super dealloc];
}
-(void)setRelease{
	[self setType:ReleaseTouch];
}

-(void)updateWithCursor:(CNTuioCursor*)aCursor{
	[cursor release];
	cursor = [aCursor retain];///keep the updated cursor
	position = [aCursor position];///update touch position
	timestamp = [[NSDate date] timeIntervalSinceReferenceDate];///update touch timestamp
	
	CNPathElement* lastPathElement = [strokePath lastObject];
	
	NSPoint newVelocity = getActualPositionTouchVelocity(position,lastPathElement.position,(timestamp - lastPathElement.timestamp));///calculate Touch velocity
	newVelocity.x = (newVelocity.x+velocity.x)/2;
	newVelocity.y = (newVelocity.y+velocity.y)/2;
	
	velocity = newVelocity;///update Touch velocity
	
	CNPathElement* newPathElement = [[CNPathElement alloc] initWithPosition:position andVelocity:velocity andTime:timestamp];
	[strokePath addObject:newPathElement];///save the actual Touch state in the StrokePath
	[newPathElement release];
	lifetime += timestamp - lastPathElement.timestamp;///update Touch lifetime
	
}

- (NSString*)stringValue{
	NSMutableString* TempString = [NSMutableString new];
	NSDateFormatter* TempFormatter = [[NSDateFormatter alloc] init];
	[TempFormatter setDateStyle:NSDateFormatterNoStyle];
	[TempFormatter setTimeStyle:NSDateFormatterMediumStyle];//Da vedere Date - TimeInterval

	[TempString appendString:@"ID: "];
	[TempString appendString:[[NSNumber numberWithInt:strokeID] stringValue]];
	[TempString appendString:@" type: "];
	[TempString appendString:[[NSNumber numberWithDouble:type] stringValue]];	
	[TempString appendString:@" position:("];
	[TempString appendString:[[NSNumber numberWithFloat:position.x] stringValue]];
	[TempString appendString:@","];
	[TempString appendString:[[NSNumber numberWithFloat:position.y] stringValue]];
	[TempString appendString:@") "];
	[TempString appendString:@" velocity:("];
	[TempString appendString:[[NSNumber numberWithFloat:velocity.x] stringValue]];
	[TempString appendString:@","];
	[TempString appendString:[[NSNumber numberWithFloat:velocity.y] stringValue]];
	[TempString appendString:@") "];
	[TempString appendString:[TempFormatter stringFromDate:[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:timestamp]]];
	[TempString appendString:@" TimeStamp: "];
	[TempString appendString:[[NSNumber numberWithDouble:timestamp] stringValue]];
	[TempString appendString:@"Lifetime: "];
	[TempString appendString:[[NSNumber numberWithDouble:lifetime] stringValue]];
	return TempString;
}

-(id)copy{
	CNTouch* aTouch = [[CNTouch alloc] initWithCursor:cursor];
	if(aTouch){
		aTouch.type = type;
		aTouch.timestamp = timestamp;
		aTouch.lifetime = lifetime;
		aTouch.velocity = velocity;
		NSMutableArray*copyPath=[strokePath mutableCopy];
		aTouch.strokePath = copyPath;
		[copyPath release];
	}
	return aTouch;
}

-(void)updateWithPoint:(NSPoint)aPoint andTouchType:(TouchType)aType{
	position = aPoint;
	timestamp = [[NSDate date] timeIntervalSinceReferenceDate];
	type = aType;
	
	CNPathElement* lastPathElement = [strokePath lastObject];
	
	NSPoint newVelocity = getActualPositionTouchVelocity(aPoint,lastPathElement.position,(timestamp - lastPathElement.timestamp));

	newVelocity.x = (newVelocity.x+velocity.x)/2;
	newVelocity.y = (newVelocity.y+velocity.y)/2;
	velocity = newVelocity;
	
	CNPathElement* newPathElement = [[CNPathElement alloc] initWithPosition:position andVelocity:velocity andTime:timestamp];
	[strokePath addObject:newPathElement];
	[newPathElement release];
	lifetime +=timestamp - lastPathElement.timestamp;
}

@end
