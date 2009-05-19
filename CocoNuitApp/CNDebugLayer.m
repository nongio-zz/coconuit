//
//  debugLayer.m
//  TuioClient
//
//  Created by Riccardo Canalicchio on 17/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CNDebugLayer.h"


@implementation CNDebugLayer
@synthesize layersForTouches;

-(id)init
{
	if(self=[super init]){
		layersForTouches = [[NSMutableDictionary alloc]init];
	}
	return self;
}
-(void)setupLayers
{
	
}
-(void)updateStrokes:(CNEvent*)aEvent
{
	[super updateStrokes:aEvent];
	[self redraw];
}
-(void) redraw
{
	NSMutableArray* tempStrokes = myMultitouchEvent.strokes;
	for (id stroke in tempStrokes)
	{
		if([stroke isKindOfClass:[CNTouch class]])
		{
			CNTouch* tempTouch = (CNTouch*) stroke;
			CNCursorLayer* circle;
			switch(tempTouch.type)
			{
				case UpdateTouch:

					circle = [layersForTouches objectForKey:[NSNumber numberWithInt: tempTouch.strokeID]];
					[CATransaction begin];
					[CATransaction setValue:(id)kCFBooleanTrue
									 forKey:kCATransactionDisableActions];
					CGPoint point = CGPointMake(tempTouch.position.x*[self superlayer].bounds.size.width, (1-tempTouch.position.y)*[self superlayer].bounds.size.height);
					circle.position = point;
					[qc setValue:[NSNumber numberWithFloat:tempTouch.position.x] forInputKey:@"X"];
					[qc setValue:[NSNumber numberWithFloat:(1-tempTouch.position.y)] forInputKey:@"Y"];
					[[self superlayer] setNeedsDisplayInRect:CGRectMake(point.x-12.5, point.y-12.5, 25, 25)];
					[CATransaction commit];						
					break;
				case ReleaseTouch:
					circle = [layersForTouches objectForKey:[NSNumber numberWithInt: tempTouch.strokeID]];
					[[self superlayer] setNeedsDisplayInRect:CGRectMake(circle.position.x-12.5, circle.position.y-12.5, 25, 25)];
					[circle removeFromSuperlayer];
					[layersForTouches removeObjectForKey:[NSNumber numberWithInt: tempTouch.strokeID]];
					break;
			}
		}
	}
}
-(void) setStroke:(CNStroke*)stroke hover:(BOOL)ishover
{

	if([stroke isKindOfClass:[CNTouch class]])
	{
		[self.myMultitouchEvent setStroke:stroke];
		CNTouch* tempTouch = (CNTouch*) stroke;
		CGPoint point = CGPointMake(tempTouch.position.x*[self superlayer].bounds.size.width, (1-tempTouch.position.y)*[self superlayer].bounds.size.height);
		CNCursorLayer *circle = [[CNCursorLayer alloc] initWithRadius:25.0 hover:ishover];
		circle.position = point;
		[self addSublayer:circle];
//		[[self superlayer] setNeedsDisplayInRect:CGRectMake(point.x-12.5, point.y-12.5, 25, 25)];
		[layersForTouches setObject:circle forKey:[[NSNumber numberWithInt: tempTouch.strokeID]];
	}
}
@end
