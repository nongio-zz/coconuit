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

-(void)newEvent:(NSNotification *)notification{
	
	CNEvent* newMultitouchEvent = [notification object];
	
	//primo ciclo aggiornamento degli strokes dei layer attivi (CNLayer)
	for(id aLayer in activeLayers){
		if([aLayer isKindOfClass:[CNLayer class]]){
			CNLayer* aTCLayer = (CNLayer*) aLayer;
			[aTCLayer updateStrokes:newMultitouchEvent];
		}
	}
	
	//secondo ciclo dispatch dei nuovi strokes
	for (id stroke in newMultitouchEvent.strokes){
		//controllo se è un tocco
		if([stroke isKindOfClass:[CNTouch class]]){
			CNTouch*touch = stroke;
			CNLayer* touchable;
			CALayer* tempLayer;
			//converto il punto dalle coordinate 0:1 a quelle reali del rootLayer
			CGPoint point = CGPointMake(touch.position.x*rootLayer.bounds.size.width, (1-touch.position.y)*rootLayer.bounds.size.height);
			if(touch.type==NewTouch){
					//con il metodo hitTest di core animation si guarda a chi appartiene il nuovo tocco
					tempLayer  = [viewLayer hitTest: point];
					if([tempLayer isKindOfClass:[CNLayer class]])
					{
						touchable = (CNLayer*) tempLayer;
						[touchable.myMultitouchEvent setStroke:[touch copy]];
					}
			}
		}
	}
	//fine dispatch
	
	//terzo ciclo viene richiamto il metodo riconosci gesto sui ogni layer attivo
	//poi si tolgono i tocchi di tipo release
	for(id layer in activeLayers){
		if([layer isKindOfClass:[CNLayer class]]){
			CNLayer*tl = (CNLayer*)layer;
			[tl.GestureRecognizer recognizeGesture:tl];

			//NSMutableArray* tempStrokesCopy = [tl.myMultitouchEvent.strokes mutableCopy];

			CNEvent* aEvent = [tl.myMultitouchEvent copy];
			NSMutableArray* tempStrokeCopy = aEvent.strokes;

			for(id stroke in tl.myMultitouchEvent.strokes){
				CNTouch* aStroke = (CNTouch*) stroke;
				//CNTouch*stroke = [tl.myMultitouchEvent.strokes objectAtIndex:i];
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

@end
