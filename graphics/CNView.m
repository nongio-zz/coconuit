//
//  CNView.m
//  TuioClient
//
//  Created by Nicola Martorana on 25/02/09.
//  Copyright 2009 Unifi. All rights reserved.
//

#import "CNView.h"


@implementation CNView

@synthesize rootLayer,viewLayer;
@synthesize activeLayers;
- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		activeLayers = [NSMutableArray new];
		[[self window] makeFirstResponder:self];	
		rootLayer = [[CALayer alloc] init];
		[rootLayer setBackgroundColor:CGColorCreateGenericRGB(0.3, 0.3, 0.3, 1.0)];
		[self setLayer:rootLayer];
		[self setWantsLayer:YES];
		viewLayer = [CALayer layer];
		[rootLayer addSublayer:viewLayer];
	    [self setupLayers];
    }
    return self;
}

-(BOOL)acceptsFirstResponder{
	return YES;
}
///Called on each CNEvent from notfication center
-(void)newCNEvent:(NSNotification *)notification{
	
	CNEvent* newMultitouchEvent = [notification object];
	
	///First of all, for each layer already in activeLayers array, it updates the strokes.
	for(id aLayer in activeLayers){
		if([aLayer isKindOfClass:[CNLayer class]]){
			CNLayer* aTCLayer = (CNLayer*) aLayer;
			[aTCLayer updateStrokes:newMultitouchEvent];
		}		
	}
	
	///For each new stroke, look if it fall into an active layer, make the association between the stroke and the CNLayer\n
	///and push the layer into the activeLayers array.
	for (id stroke in newMultitouchEvent.strokes){
		if([stroke isKindOfClass:[CNTouch class]]){
			CNTouch*touch = stroke;
			CNLayer* touchable;
			CALayer* tempLayer;
			///Touch's position coordinate must be converted from unit to real pixel for the hit test
			CGPoint point = CGPointMake(touch.position.x*rootLayer.bounds.size.width, (1-touch.position.y)*rootLayer.bounds.size.height);
			if(touch.type==NewTouch){
					tempLayer  = [self activeLayerHitTest: point];
					if([tempLayer isKindOfClass:[CNLayer class]])
					{
						touchable = (CNLayer*) tempLayer;
						[touchable.myMultitouchEvent setStroke:[touch copy]];
					}
				
			}
		}
	}
	
	///Then for each layer in the activeLayers array it will call the recognizeGesture method.
	for(id layer in activeLayers){
		if([layer isKindOfClass:[CNLayer class]]){
			CNLayer*tl = (CNLayer*)layer;
			[tl.GestureRecognizer recognizeGesture:tl];
			CNEvent* aEvent = [tl.myMultitouchEvent copy];
			NSMutableArray* tempStrokeCopy = aEvent.strokes;
			///The last thing is to remove the touch of type ReleaseTouch from the CNLayer.
			for(id stroke in tl.myMultitouchEvent.strokes){
				CNTouch* aStroke = (CNTouch*) stroke;
				if(aStroke.type == ReleaseTouch){
					[aEvent removeStrokeByID:aStroke.strokeID];
				}
			}
			
			tl.myMultitouchEvent.strokes = tempStrokeCopy;
		}
	}	
}

-(void)setupLayers{}

-(void)addSublayer:(CALayer*)newlayer
{
	[self addActiveSubLayer:newlayer];
	[viewLayer addSublayer:newlayer];
}

-(void)addActiveSubLayer:(CALayer*)newlayer
{
	if([newlayer isKindOfClass:[CNLayer class]])
		[activeLayers addObject:(id)newlayer];
	else
	{
		if([newlayer.sublayers count]){
			for(CALayer*sublayer in newlayer.sublayers)
			{
				[self addActiveSubLayer:sublayer];
			}
		}
			
	}
}
-(CNLayer*)activeLayerHitTest:(CGPoint)point
{
	CALayer* tempLayer  = [viewLayer hitTest: point];
	CNLayer* activeLayer = [self findActiveLayer:tempLayer];
	return activeLayer;
}
-(CNLayer*) findActiveLayer:(CALayer*)alayer
{
	if(alayer!=nil)
	{
		if([alayer isKindOfClass:[CNLayer class]])
		{
			return ((CNLayer*)alayer);
		}
		else
		{
			return [self findActiveLayer:[alayer superlayer]];
		}
	}
	else
	{
		return (CNLayer*)alayer;
	}
}
@end
