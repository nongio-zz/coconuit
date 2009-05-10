//
//  Move.m
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

#import "CNMove.h"
#import "CNLayer.h"
#import "CNPathElement.h"
#import "CNCircleLayer.h"

@implementation CNMove

@synthesize touch;

-(id)init{
		if(self = [super init]){
			touch=Nil;
			super.GestureName = @"Move";
			state = WaitingGesture;
		}
		return self;
	}

-(BOOL)recognize:(id)sender{
		if([sender isKindOfClass:[CNLayer class]]){
			NSMutableArray* gStrokes = [[sender myMultitouchEvent] strokes];
			
			if([gStrokes count]>0){
				if([gStrokes count]>1){
					if(touch==Nil){
						self.touch = [[CNTouch alloc] init];
					}
					[self groupStrokesToOne:gStrokes andUpdateTouch:touch];
				}
				else{
					self.touch = [gStrokes lastObject];
				}
				
				if(touch){
					if([touch.strokePath count] >1){
						CNPathElement* last = [touch.strokePath objectAtIndex:([touch.strokePath count]-2)];
						double MinMoveVelocity = [[GesturesParams objectForKey:@"MinMoveVelocity"] doubleValue];
						
						//DISEGNO DEL TOCCO
						CALayer*global = [sender globalLayer];
						CNCircleLayer*circle = [global valueForKey:@"circletouch"];
						if(!circle)
						{
							circle = [[CNCircleLayer alloc] initWithRadius:5.0];
							[global setValue:circle forKey:@"circletouch"];
							[global addSublayer:circle];
						}
						circle.position=[sender unitToReal:CGPointMake(touch.position.x,(1-touch.position.y)) ofLayer:global];
						//FINE DISEGNO						
						
						CN2dVect* vectT = [[CN2dVect alloc] initWithPoint:touch.position andPoint:last.position];
					
						if(touch.type==ReleaseTouch && state==UpdateGesture){
							state=EndGesture;
							touch=Nil;
						}
						
						//NSLog(@"%f",touch.velocity.x);
						
						if(fabs(touch.velocity.x)>MinMoveVelocity || fabs(touch.velocity.y)>MinMoveVelocity || state==EndGesture){
								if(state==WaitingGesture){
									state=BeginGesture;
								}
								else{
									if(touch.type == UpdateTouch){
										state=UpdateGesture;
									}
								}
							
						
								NSArray* keys = [NSArray arrayWithObjects:@"translation",@"center", @"velocity", @"gState", nil];
							    NSValue* center= [NSValue valueWithPoint:NSMakePoint(touch.position.x, touch.position.y)];
								NSValue* velocity = [NSValue valueWithPoint:touch.velocity];
								NSValue* gState = [NSNumber numberWithInt:self.state];
							
								NSArray* objects = [NSArray arrayWithObjects:vectT,center, velocity,gState, nil];
								NSDictionary* params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
								
								if(vectT.module>0){
								[sender performGesture:@"Move" withData:params];
								}
								
								if(state==EndGesture){
									state=WaitingGesture;
								}
								return TRUE;
							}
					}
				}
			}
		}
		return FALSE;
	}

- (void)groupStrokesToOne:(NSMutableArray*)strokes andUpdateTouch:(CNTouch*)aTouch{
	NSMutableArray* points = [[NSMutableArray alloc] init];
	int touchType = aTouch.type;
	for(CNStroke* S in strokes){
		if([S isKindOfClass:[CNTouch class]]){
			CNTouch* t = (CNTouch*) S;
			
			if(t.type==NewTouch){
				aTouch.strokePath = [[NSMutableArray alloc] init];
			}
			
			if(t.type==ReleaseTouch){
				touchType = ReleaseTouch;
			}
			
			[points addObject:[NSValue valueWithPoint:t.position]];
		}
	}
	
	NSPoint gCenter = getCenterPoint(points);
	[aTouch updateWithPoint:gCenter andTouchType:touchType];
}
@end
