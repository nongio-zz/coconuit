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


@implementation CNTouch

@synthesize cursor;
@synthesize type;
@synthesize timestamp;

-(CNTouch*)init{
	if(self = [super init]){
		self.strokeID = 666;
		self.type = NewTouch;
		self.cursor = nil;
		self.position = NSMakePoint(0,0);
		self.velocity = NSMakePoint(0,0);
		self.lifetime = 0;
		self.timestamp = [[NSDate date] timeIntervalSinceReferenceDate];
		self.strokePath = [[NSMutableArray alloc] init];
		
	}
	return self;
}

-(CNTouch*)initWithCursor:(CNTuioCursor*)aCursor{
	
	if(self = [super init]){
		self.strokeID = [aCursor cursorID];
		self.type = NewTouch;
		self.cursor = [aCursor retain];
		self.position = [aCursor position];
		self.velocity = NSMakePoint(0,0);
		self.lifetime = 0;
		self.timestamp = [[NSDate date] timeIntervalSinceReferenceDate];
		self.strokePath = [[NSMutableArray alloc] init];
		CNPathElement* newPathElement = [[CNPathElement alloc] initWithPosition:self.position andVelocity:self.velocity andTime:self.timestamp];
		[self.strokePath addObject:[newPathElement retain]];
	}
	
	return self;
}

-(void)setRelease{
	[self setType:ReleaseTouch];
}

-(void)updateWithCursor:(CNTuioCursor*)aCursor{
	self.cursor = aCursor;
	self.position = [aCursor position];
	self.timestamp = [[NSDate date] timeIntervalSinceReferenceDate];
	
	CNPathElement* lastPathElement = [self.strokePath lastObject];
	NSPoint newVelocity = [self CalculateVelocityOfActualPosition:self.position fromPreviousPosition:lastPathElement.position withTimeInterval:(self.timestamp - lastPathElement.timestamp)];
	if([self.strokePath count] > 2)
	{
		CNTouch*t0 = (CNTouch*)[self.strokePath objectAtIndex:[self.strokePath count]-3];
		CNTouch*t1 = (CNTouch*)[self.strokePath objectAtIndex:[self.strokePath count]-2];
		newVelocity.x = (newVelocity.x+t1.velocity.x+t0.velocity.x)/3;
		newVelocity.y = (newVelocity.y+t1.velocity.y+t0.velocity.y)/3;

	}else
	{
		newVelocity.x = (newVelocity.x+self.velocity.x)/2;
		newVelocity.y = (newVelocity.y+self.velocity.y)/2;
	}
	self.velocity = newVelocity;
	CNPathElement* newPathElement = [[CNPathElement alloc] initWithPosition:self.position andVelocity:self.velocity andTime:self.timestamp];
	[self.strokePath addObject:[newPathElement retain]];
	self.lifetime += self.timestamp - lastPathElement.timestamp;
}

- (NSString*)stringValue{
	NSMutableString* TempString = [NSMutableString new];
	NSDateFormatter* TempFormatter = [[NSDateFormatter alloc] init];
	[TempFormatter setDateStyle:NSDateFormatterNoStyle];
	[TempFormatter setTimeStyle:NSDateFormatterMediumStyle];//Da vedere Date - TimeInterval

	[TempString appendString:@"ID: "];
	[TempString appendString:[[NSNumber numberWithInt:self.strokeID] stringValue]];
	[TempString appendString:@" type: "];
	[TempString appendString:[[NSNumber numberWithDouble:self.type] stringValue]];	
	[TempString appendString:@" position:("];
	[TempString appendString:[[NSNumber numberWithFloat:self.position.x] stringValue]];
	[TempString appendString:@","];
	[TempString appendString:[[NSNumber numberWithFloat:self.position.y] stringValue]];
	[TempString appendString:@") "];
	[TempString appendString:@" velocity:("];
	[TempString appendString:[[NSNumber numberWithFloat:self.velocity.x] stringValue]];
	[TempString appendString:@","];
	[TempString appendString:[[NSNumber numberWithFloat:self.velocity.y] stringValue]];
	[TempString appendString:@") "];
	//[TempString appendString:[TempFormatter stringFromDate:[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:timestamp]]];
	[TempString appendString:@" TimeStamp: "];
	[TempString appendString:[[NSNumber numberWithDouble:self.timestamp] stringValue]];
	[TempString appendString:@" Lifetime: "];
	[TempString appendString:[[NSNumber numberWithDouble:self.lifetime] stringValue]];
	return TempString;
}

-(NSPoint) CalculateVelocityOfActualPosition:(NSPoint)aPosition fromPreviousPosition:(NSPoint)pPosition withTimeInterval:(NSTimeInterval)aTime{
		NSPoint tempVelocity;
		tempVelocity.x = (aPosition.x - pPosition.x)/aTime;
		tempVelocity.y = (aPosition.y - pPosition.y)/aTime;
		return tempVelocity;
	}

-(id)copy{
	CNTouch* aTouch = [[CNTouch alloc] initWithCursor:cursor];
	if(aTouch){
		aTouch.type = type;
		aTouch.timestamp = timestamp;
		aTouch.lifetime = lifetime;
		aTouch.velocity = velocity;
		aTouch.strokePath = [strokePath mutableCopy];
	}
	return aTouch;
}

-(void)updateWithPoint:(NSPoint)aPoint andTouchType:(TouchType)aType{
	self.position = aPoint;
	self.timestamp = [[NSDate date] timeIntervalSinceReferenceDate];
	self.type = aType;
	
	CNPathElement* lastPathElement = [self.strokePath lastObject];
	
	NSPoint newVelocity = [self CalculateVelocityOfActualPosition:aPoint fromPreviousPosition:lastPathElement.position withTimeInterval:(self.timestamp - lastPathElement.timestamp)];
	if([self.strokePath count] > 2)
	{
		CNTouch*t0 = (CNTouch*)[self.strokePath objectAtIndex:[self.strokePath count]-3];
		CNTouch*t1 = (CNTouch*)[self.strokePath objectAtIndex:[self.strokePath count]-2];
		newVelocity.x = (newVelocity.x+t1.velocity.x+t0.velocity.x)/3;
		newVelocity.y = (newVelocity.y+t1.velocity.y+t0.velocity.y)/3;
		
	}else
	{
		newVelocity.x = (newVelocity.x+self.velocity.x)/2;
		newVelocity.y = (newVelocity.y+self.velocity.y)/2;
	}
	self.velocity = newVelocity;
	
	CNPathElement* newPathElement = [[CNPathElement alloc] initWithPosition:self.position andVelocity:self.velocity andTime:self.timestamp];
	[self.strokePath addObject:[newPathElement retain]];
	self.lifetime += self.timestamp - lastPathElement.timestamp;
}

@end
