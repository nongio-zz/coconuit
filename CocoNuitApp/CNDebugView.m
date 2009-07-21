//
//  CNDebugView.m
//  TuioClient
//
//  Created by Riccardo Canalicchio on 19/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CNDebugView.h"


@implementation CNDebugView
@synthesize tcdbg,circlesfortouches;

-(void)newCNEvent:(NSNotification *)notification{
	
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
			CGPoint point = CGPointMake(touch.position.x*self.frame.size.width, (1-touch.position.y)*self.frame.size.height);
			if(touch.type==NewTouch){
				//con il metodo hitTest di core animation si guarda a chi appartiene il nuovo tocco
				tempLayer  = [self activeLayerHitTest:point];
				BOOL ishover = NO;
				if([tempLayer isKindOfClass:[CNLayer class]])
				{
					NSUInteger num = [activeLayers indexOfObject:tempLayer];
					if(num == NSNotFound)
						[activeLayers addObject:tempLayer];
					touchable = (CNLayer*) tempLayer;
					[touchable.myMultitouchEvent setStroke:[touch copy]];
					ishover=YES;
				}
				[circlesfortouches setStroke:[touch copy] hover:ishover];
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

-(void)setupLayers
{	
	circlesfortouches = [[CNDebugLayer alloc] init];
	//CIRCLES
	[self.layer addSublayer:circlesfortouches];
//	[self addActiveSubLayer:circlesfortouches];
	
	
	//STATUS BAR
	CNStatusbarLayer*statusbar = [CNStatusbarLayer layer];
	statusbar.name = @"status";
	statusbar.frame = CGRectMake(0, 0, self.frame.size.width, 50);
	statusbar.anchorPoint = CGPointMake(0.0,1.0);
	statusbar.position = CGPointMake(0,self.frame.size.height);
	[self.layer setValue:statusbar forKey:@"status"];

	//LIGHTS
	CNLightLayer*light1 = [[CNLightLayer alloc] initWithLabel:@"press"
									  observedGestureName:@"Press"
												 andColor:CGColorCreateGenericCMYK(0.38, 0.03, 1.0, 0, 1)
											  withConsole:NO];
	light1.position = CGPointMake(100.0,25);
	
	CNLightLayer*light2 = [[CNLightLayer alloc] initWithLabel:@"update"
 									  observedGestureName:@"Update"
												 andColor:CGColorCreateGenericCMYK(0.07, 0.00, 0.91, 0, 1)
											  withConsole:NO];
	light2.position = CGPointMake(150.0,25);
	
	CNLightLayer*light3 = [[CNLightLayer alloc] initWithLabel:@"release"
  									  observedGestureName:@"Release"
												 andColor:CGColorCreateGenericCMYK(0.03, 0.99, 0.37, 0, 1)
												  withConsole:NO];
	light3.position = CGPointMake(200.0,25);
	
	CNLightLayer*light4 = [[CNLightLayer alloc] initWithLabel:@"tap"
									  observedGestureName:@"Tap"
												 andColor:CGColorCreateGenericCMYK(0.64, 0.02, 0.0, 0, 1)
											  withConsole:NO];
	light4.position = CGPointMake(250.0,25);
	
	CNLightLayer*light5 = [[CNLightLayer alloc] initWithLabel:@"2tap"
									  observedGestureName:@"DoubleTap"
												 andColor:CGColorCreateGenericCMYK(0.72, 0.27, 0.0, 0, 1)
											  withConsole:NO];
	light5.position = CGPointMake(300.0,25);
	
	CNLightLayer*light6 = [[CNLightLayer alloc] initWithLabel:@"hold"
									  observedGestureName:@"Hold"
												 andColor:CGColorCreateGenericCMYK(0.86, 0.73, 0.0, 0, 1)
											  withConsole:NO];
	light6.position = CGPointMake(350.0,25);
	CNLightLayer*light7 = [[CNLightLayer alloc] initWithLabel:@"move" 
 									  observedGestureName:@"Move"
												 andColor:CGColorCreateGenericCMYK(0.0, 1.0, 0.0, 0, 1)
											  withConsole:YES];
	light7.position = CGPointMake(470.0,25);
	CNLightLayer*light8 = [[CNLightLayer alloc] initWithLabel:@"rotate"
 									  observedGestureName:@"TwoFingerRotate"
												 andColor:CGColorCreateGenericCMYK(0.00, 1.0, 0.0, 0, 1)
											  withConsole:YES];
	light8.position = CGPointMake(590.0,25);
	CNLightLayer*light9 = [[CNLightLayer alloc] initWithLabel:@"scale"
 									  observedGestureName:@"TwoFingerScale"
												 andColor:CGColorCreateGenericCMYK(0.0, 1.0, 0.0, 0, 1)
											  withConsole:YES];
	light9.position = CGPointMake(710.0,25);

	[statusbar addSublayer:light1];
	[statusbar addSublayer:light2];
	[statusbar addSublayer:light3];
	[statusbar addSublayer:light4];
	[statusbar addSublayer:light5];
	[statusbar addSublayer:light6];
	[statusbar addSublayer:light7];
	[statusbar addSublayer:light8];
	[statusbar addSublayer:light9];

	
	//ADD LAYERS
	[self.layer addSublayer:statusbar];
	
	tcdbg = [[CNDebug alloc] initWithImage:@"john.jpg"];
	tcdbg.position = CGPointMake(700,350);
	[self.layer addSublayer:tcdbg];
	
	CNDebug*tcdbg2 = [[CNDebug alloc] initWithImage:@"einstein.jpg"];
	tcdbg2.position = CGPointMake(250,400);
	[self.layer addSublayer:tcdbg2];
	
	CNWheel*w=[[CNWheel alloc] init];
	w.position=CGPointMake(200,600);
	[self.layer addSublayer:w];
	
	//OBSERVERS
//	[tcdbg addObserver:light1];
//	[tcdbg addObserver:light2];
//	[tcdbg addObserver:light3];
//	[tcdbg addObserver:light4];
//	[tcdbg addObserver:light5];
//	[tcdbg addObserver:light6];
//	[tcdbg addObserver:light7];
//	[tcdbg addObserver:light8];
//	[tcdbg addObserver:light9];
}

@end
