//
//  CN2FingerRotate.m
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

#import "CN2FingerRotate.h"
#import "CNPathElement.h"

#import "CNLayer.h"

@implementation CN2FingerRotate

@synthesize angle,sense;

-(id)init{
	if(self = [super init]){
		super.GestureName = @"2FingersRotate";
		state = WaitingGesture;
		angle = 0.0;
	}
	return self;
}

-(BOOL)recognize:(id)sender{
	if([sender isKindOfClass:[CNLayer class]]){
		NSMutableArray* gStrokes = [[sender myMultitouchEvent] strokes];
		
		if([gStrokes count] == 2){///By now no grouping for this gesture is supported. Is supposed that only two different touch are in the active area.
			
			//Controllare la velocità diversa da zero
			CNStroke* stroke_0 = [gStrokes objectAtIndex:0];
			CNStroke* stroke_1 = [gStrokes objectAtIndex:1];

			if(stroke_0.strokePath.count>1 && stroke_1.strokePath.count>1){///if touches velocity is heighterd than a Threshold
				
				CNTouch* Touch0 = (CNTouch*)stroke_0;///for each touch get the actual position: Ap0 and Ap1
				CNTouch* Touch1 = (CNTouch*)stroke_1;
				
				if(Touch0.type==ReleaseTouch || Touch1.type==ReleaseTouch){///if one of the touches is a release touch set gesture state to EndGesture
					state=EndGesture;
				}
				
				NSPoint stroke_0_old_position = [(CNPathElement*)[stroke_0.strokePath objectAtIndex:([stroke_0.strokePath count]-2)] position];///for each touch get the previous position: Pp0 and Pp1
				NSPoint stroke_1_old_position = [(CNPathElement*)[stroke_1.strokePath objectAtIndex:([stroke_1.strokePath count]-2)] position];

				
				NSPoint mediumPoint = getMediumPoint(stroke_0_old_position,stroke_1_old_position);///get the medium point M between the old positions
				
				CN2dVect* vect_0_old = [[CN2dVect alloc] initWithPoint:mediumPoint andPoint:stroke_0_old_position];///get the 2d vector between M and Pp0: V0p
				CN2dVect* vect_0 = [[CN2dVect alloc] initWithPoint:mediumPoint andPoint:stroke_0.position];///get the 2d vector between M and Ap0: V0a

				CN2dVect* vect_1_old = [[CN2dVect alloc] initWithPoint:mediumPoint andPoint:stroke_1_old_position];///get the 2d vector between M and Pp1: V1p
				CN2dVect* vect_1 = [[CN2dVect alloc] initWithPoint:mediumPoint andPoint:stroke_1.position];///get the 2d vector between M and Ap1: V1a
				
				
				double alfa_0 = getAngleBetweenVector(vect_0_old,vect_0);///get the angle and rot sense between V0p and V0a: alfa0
				double rotSense_alfa_0 = getRotationSenseBetweenVector(vect_0_old,vect_0);
				
				double alfa_1 = getAngleBetweenVector(vect_1_old,vect_1);///get the angle and rot sense between V1p and V1a: alfa1
				double rotSense_alfa_1 = getRotationSenseBetweenVector(vect_1_old,vect_1);
				
				self.sense = rotSense_alfa_1!=0? rotSense_alfa_1:self.sense;
				double alfa = maxDouble(alfa_0,alfa_1);///get the max between alfa0 and alfa1 as rotation angle: alfa
				self.angle = alfa;
				
				double Min2FingerRotationAngle = [[GesturesParams objectForKey:@"Min2FingerRotationAngle"] doubleValue];
				
				if(alfa>(Min2FingerRotationAngle*M_PI/180) || state==EndGesture){///if alfa is higher than a Threshold and the rotation sense is consistent
					if(rotSense_alfa_0*rotSense_alfa_1>=0){
						
						///manage the gesture state
						if(state==BeginGesture){
							state=UpdateGesture;
						}
						
						if(state==WaitingGesture){
							state=BeginGesture;
							anchorPoint = getMediumPoint(stroke_0_old_position,stroke_1_old_position);
							lastTimestamp = [[NSDate date] timeIntervalSinceReferenceDate];
						}
						
						///get the angular velocity
						NSTimeInterval curretTimeStamp = [[NSDate date] timeIntervalSinceReferenceDate];
						double time = curretTimeStamp - lastTimestamp;
						lastTimestamp = curretTimeStamp;
						angularvelocity;
						double deltaangle = fabs(self.angle-alfa);
						
						if(time>0 && deltaangle>0)
							angularvelocity= (angularvelocity+(deltaangle/time))/2;
						else
							angularvelocity = 0;
						
						///set the useful params for the animation
						NSArray* keys = [NSArray arrayWithObjects:@"angle", @"sense", @"angularVelocity", @"center" ,@"radius",@"gState",nil];
						NSNumber* anglePar = [NSNumber numberWithFloat:alfa];
						NSNumber* sensePar = [NSNumber numberWithInt:self.sense];
						NSNumber* angVelocity = [NSNumber numberWithFloat:angularvelocity];
						NSValue* centerPar = [NSValue valueWithPoint:anchorPoint];
						NSNumber* radiusPar = [NSNumber numberWithFloat:vect_1.module];
						NSNumber* gStatePar = [NSNumber numberWithInt:self.state];
						
						NSArray* objects = [NSArray arrayWithObjects:anglePar, sensePar,angVelocity, centerPar, radiusPar, gStatePar, nil];
						NSDictionary* params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
						
						[sender performGesture:@"TwoFingerRotate" withData:params];///call perform TwoFingerRotateGesture on the related layer [sender performGesture:@"TwoFingerRotate" withData:params];
																				   ///passing Rotation Angle, Rotation Sense, Rotation Angular Velocity, Medium Point, Velocity and GestureState
					}
				}
				if(state==EndGesture){
					state=WaitingGesture;
				}
				return TRUE;
			}
		}
	}
	return FALSE;
}



@end
