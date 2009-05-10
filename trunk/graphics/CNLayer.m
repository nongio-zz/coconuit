//
//  CNLayer.m
//  TuioClient
//
//  Created by Nicola Martorana on 19/03/09.
//  Copyright 2009 Unifi. All rights reserved.
//

#import "CNLayer.h"
#import "CNCircleLayer.h"

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

-(void)CNPress:(NSDictionary*)params{
	
}

-(void)updateTouch:(NSDictionary*)params{

}

-(void)CNRelease:(NSDictionary*)params{
	
}

-(void)CNTap:(NSDictionary*)params{
}

-(void)DoubleTap:(NSDictionary*)params{

}

-(void)CNHold:(NSDictionary*)params{

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
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue
					 forKey:kCATransactionDisableActions];
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
