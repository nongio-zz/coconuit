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
				if([gStrokes count]>1){///if the Touchs number is greater than one
					if(touch==Nil){
						touch = [[CNTouch alloc] init];
					}
					[self groupStrokesToOne:gStrokes andUpdateTouch:touch];///grouping the touches to one
				}
				else{
					touch = [[gStrokes lastObject] copy];///else get the only one
				}
				
			if(touch){
				if([touch.strokePath count] >1){
					CNPathElement* last = [touch.strokePath objectAtIndex:([touch.strokePath count]-2)];
					double MinMoveVelocity = [[GesturesParams objectForKey:@"MinMoveVelocity"] doubleValue];
					
					CN2dVect* vectT = [[CN2dVect alloc] initWithPoint:touch.position andPoint:last.position];
				
					if(touch.type==ReleaseTouch){///if release touch set GestureState to EndGesture
						state=EndGesture;
						//touch=nil;
						}
					
					//NSLog(@"%f",touch.velocity.x);
					if(fabs(touch.velocity.x)>MinMoveVelocity || fabs(touch.velocity.y)>MinMoveVelocity || state==EndGesture){///if touch velocity is greater than a minimum Threshold get Move
							if(state==WaitingGesture){
								state=BeginGesture;///if waiting Gesture State, set state to BeginGesture
								}
							else{
								if(touch.type == UpdateTouch){
									state=UpdateGesture;///else set state to UpdateGesture
								}
							}
							
							///set the useful animation params for the active area animation
							NSArray* keys = [NSArray arrayWithObjects:@"translation",@"center", @"velocity", @"gState", nil];
							NSValue* center= [NSValue valueWithPoint:NSMakePoint(touch.position.x, touch.position.y)];
							NSValue* velocity = [NSValue valueWithPoint:touch.velocity];
							NSValue* gState = [NSNumber numberWithInt:state];
						
							NSArray* objects = [NSArray arrayWithObjects:vectT,center, velocity,gState, nil];
							NSDictionary* params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
							
							if(vectT.module>0 || state==EndGesture){///if translation is greater than 0
								[sender performGesture:@"Move" withData:params];///calls PerformMoveGesture on the related layer [sender performGesture:@"Move" withData:params];
																				///passing Touch Position, Velocity and GestureState
								}
							
							if(state==EndGesture){///if GestureState is EndGesture set it to WaitingGesture
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

@end
