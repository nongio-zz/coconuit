//
//  CNLayer.m
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

#import "CNLayer.h"

@implementation CNLayer

@synthesize myMultitouchEvent, GestureRecognizer;

-(id)init{
	if(self=[super init]){
		CNGesture*aGesture = [[CNGesture alloc] init];
		CNEvent*aEvent = [[CNEvent alloc] init];
		self.GestureRecognizer = aGesture;
		self.myMultitouchEvent = aEvent;
		[aGesture release];
		[aEvent release];
	}
	return self;
}
/*-(void)addObserver:(id)anObject{
	if([anObject conformsToProtocol:@protocol(CNObserverProtocol)]){
		[observers addObject:anObject];
	}
}

-(void)removeObserver:(id)anObject{
	[observers removeObject:anObject];
}
*/
-(void)updateStrokes:(CNEvent*)aEvent
{
	NSMutableArray* tempStrokes = myMultitouchEvent.strokes;
	for (id stroke in tempStrokes){
		if([stroke isKindOfClass:[CNTouch class]]){
			CNTouch* tempTouch = (CNTouch*) stroke;
			CNStroke* aStroke = [aEvent getStrokeByID:tempTouch.strokeID];
			if([aStroke isKindOfClass:[CNTouch class]]){
				CNTouch* aTouch = (CNTouch *) aStroke;
				tempTouch.type = aTouch.type;
				[tempTouch updateWithCursor:aTouch.cursor];
			}
		}
	}
}
///This method is called when a gesture is recognized. It parse the data, call the appropriate method that manage the gesture, if present, call the appropriate method on the controller.
-(void)performGesture:(NSString*)gestureName withData:(NSDictionary*)params{
	
	NSString* gestureSelector = [gestureName stringByAppendingString:@":"];
	SEL selector = NSSelectorFromString(gestureSelector);
	if([self respondsToSelector:selector])
	{
		[self performSelector:NSSelectorFromString(gestureSelector) withObject:params];
	}
}

///This method go up to the layer tree until the first. return the root layer useful for coordinate conversion.
-(CALayer*)globalLayer
{
	CALayer*gl = self;
	while([gl superlayer]!=nil)
	{
		gl = [gl superlayer];
	}
	return gl;
}
///Change the anchorPoint of the layer to the the new point specified in unit coordinate of the global layer.
-(void) changeAnchorPoint:(CGPoint)unitPoint 
{	
	[self removeAllAnimations];
	[CATransaction setValue:(id)kCFBooleanTrue
					 forKey:kCATransactionDisableActions];
	[self removeAnimationForKey:@"anchorPoint"];
	[self removeAnimationForKey:@"position"];
	CALayer*globalLayer = [self globalLayer];
	CGPoint globalanchorpoint1 = [self convertPoint:[self unitToReal:self.anchorPoint ofLayer:self] toLayer:globalLayer];
	CGPoint globalanchorpoint2 = [self convertPoint:[self unitToReal:unitPoint ofLayer:self] toLayer:globalLayer];
	self.anchorPoint = unitPoint;
	CGPoint delta = CGPointMake(globalanchorpoint1.x-globalanchorpoint2.x,globalanchorpoint1.y-globalanchorpoint2.y);
	self.position = CGPointMake(self.position.x-delta.x,self.position.y-delta.y);
	[CATransaction commit];
}

///Convert a point from unit coordinate to real pixel, of the receiver layer.
-(CGPoint)unitToReal:(CGPoint)apoint ofLayer:(CALayer*)layer
{
	CGPoint newpoint = CGPointMake(apoint.x*layer.bounds.size.width, apoint.y*layer.bounds.size.height);
	return newpoint;
}
///Convert a point from real pixel coordinate to unit, of the receiver layer.
-(CGPoint)realToUnit:(CGPoint)apoint ofLayer:(CALayer*)layer
{
	CGPoint newpoint = CGPointMake(apoint.x/layer.bounds.size.width, apoint.y/layer.bounds.size.height);
	return newpoint;
}

-(void)draw{
	[myModifier drawTCLayer:self];
}
-(void)removeFromSuperlayer
{
	[super removeFromSuperlayer];
}
-(void)dealloc
{
	NSLog(@"CNLayer dealloc");
	[GestureRecognizer release];
	[myMultitouchEvent release];
	[super dealloc];
}
@end
