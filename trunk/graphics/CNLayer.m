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

@synthesize myMultitouchEvent, GestureRecognizer,observers;

-(id)init{
	if(self=[super init]){
		self.GestureRecognizer = [[CNGesture alloc] init];
		self.myMultitouchEvent = [[CNEvent alloc] init];
		observers = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void)draw{
	[myModifier drawTCLayer:self];
}

//restituisce l'ultimo elemento dell'albero dei livelli il rootLayer
//cioè quel livello che non ha un superlayer
-(CALayer*)globalLayer
{
	CALayer*gl = self;
	while([gl superlayer]!=nil)
	{
		gl = [gl superlayer];
	}
	return gl;
}

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

-(void)Press:(NSDictionary*)params{
	
}

-(void)Update:(NSDictionary*)params{

}

-(void)Release:(NSDictionary*)params{
	
}

-(void)Tap:(NSDictionary*)params{
}

-(void)DoubleTap:(NSDictionary*)params{

}

-(void)Hold:(NSDictionary*)params{

}

-(void)Move:(NSDictionary*)params{

}

-(void)TwoFingerScale:(NSDictionary*)params{

}

-(void)TwoFingerRotate:(NSDictionary*)params{

}

-(void)OneFingerRotate:(NSDictionary*)params{

}

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

-(CGPoint)unitToReal:(CGPoint)apoint ofLayer:(CALayer*)layer
{
	CGPoint newpoint = CGPointMake(apoint.x*layer.bounds.size.width, apoint.y*layer.bounds.size.height);
	return newpoint;
}

-(CGPoint)realToUnit:(CGPoint)apoint ofLayer:(CALayer*)layer
{
	CGPoint newpoint = CGPointMake(apoint.x/layer.bounds.size.width, apoint.y/layer.bounds.size.height);
	return newpoint;
}

-(void)performGesture:(NSString*)gestureName withData:(NSDictionary*)params{
	
	NSString* gestureSelector = [gestureName stringByAppendingString:@":"];
	
	[self performSelector:NSSelectorFromString(gestureSelector) withObject:params];
	
	NSMutableDictionary*nameandparams = [NSMutableDictionary dictionaryWithCapacity:([params count])+1];
	
	[nameandparams setValue:gestureName forKey:@"GestureName"];
	[nameandparams addEntriesFromDictionary:params];
	[observers makeObjectsPerformSelector:@selector(notify:) withObject:nameandparams];
}

-(void)addObserver:(id)anObject{
	if([anObject conformsToProtocol:@protocol(CNObserverProtocol)]){
		[observers addObject:anObject];
	}
}

-(void)removeObserver:(id)anObject{
	[observers removeObject:anObject];
}

@end
