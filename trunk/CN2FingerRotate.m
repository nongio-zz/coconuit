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
		
		if([gStrokes count] == 2){
			//Controllare la velocità diversa da zero
			CNStroke* stroke_0 = [gStrokes objectAtIndex:0];
			CNStroke* stroke_1 = [gStrokes objectAtIndex:1];

			if(stroke_0.strokePath.count>1 && stroke_1.strokePath.count>1){
				
				
				NSPoint stroke_0_old_position = [(CNPathElement*)[stroke_0.strokePath objectAtIndex:([stroke_0.strokePath count]-2)] position];
				NSPoint stroke_1_old_position = [(CNPathElement*)[stroke_1.strokePath objectAtIndex:([stroke_1.strokePath count]-2)] position];
				
				CNTouch* Touch0 = (CNTouch*)stroke_0;
				CNTouch* Touch1 = (CNTouch*)stroke_1;

				
				NSPoint mediumPoint = getMediumPoint(stroke_0_old_position,stroke_1_old_position);
				
				CN2dVect* vect_0_old = [[CN2dVect alloc] initWithPoint:mediumPoint andPoint:stroke_0_old_position];//localhost/Users/nicolamartorana/Documents/MICC/ion];
				CN2dVect* vect_0 = [[CN2dVect alloc] initWithPoint:mediumPoint andPoint:stroke_0.position];

				CN2dVect* vect_1_old = [[CN2dVect alloc] initWithPoint:mediumPoint andPoint:stroke_1_old_position];
				CN2dVect* vect_1 = [[CN2dVect alloc] initWithPoint:mediumPoint andPoint:stroke_1.position];
				
				
				double alfa_0 = getAngleBetweenVector(vect_0_old,vect_0);
				double rotSense_alfa_0 = getRotationSenseBetweenVector(vect_0_old,vect_0);
				
				double alfa_1 = getAngleBetweenVector(vect_1_old,vect_1);
				double rotSense_alfa_1 = getRotationSenseBetweenVector(vect_1_old,vect_1);
				self.sense = rotSense_alfa_1!=0? rotSense_alfa_1:self.sense;
				double alfa = maxDouble(alfa_0,alfa_1);
				
				double Min2FingerRotationAngle = [[GesturesParams objectForKey:@"Min2FingerRotationAngle"] doubleValue];
				if(Touch0.type==ReleaseTouch || Touch1.type==ReleaseTouch){
					state=EndGesture;
				}
				if(alfa>(Min2FingerRotationAngle*M_PI/180) || state==EndGesture){
					if(rotSense_alfa_0*rotSense_alfa_1>=0){
						if(state==BeginGesture){
							state=UpdateGesture;
						}
						if(state==WaitingGesture){
							state=BeginGesture;
							anchorPoint = getMediumPoint(stroke_0_old_position,stroke_1_old_position);
							lastTimestamp = [[NSDate date] timeIntervalSinceReferenceDate];
						}
						
						//angular velocity
						NSTimeInterval curretTimeStamp = [[NSDate date] timeIntervalSinceReferenceDate];
						double time = curretTimeStamp - lastTimestamp;
						lastTimestamp = curretTimeStamp;
						angularvelocity;
						double deltaangle = fabs(self.angle-alfa);
						if(time>0 && deltaangle>0)
							angularvelocity= (angularvelocity+(deltaangle/time))/2;
						else
							angularvelocity = 0;
						
						self.angle = alfa;
						
						NSArray* keys = [NSArray arrayWithObjects:@"angle", @"sense", @"angularVelocity", @"center" ,@"radius",@"gState",nil];
						
						NSNumber* anglePar = [NSNumber numberWithFloat:alfa];
						NSNumber* sensePar = [NSNumber numberWithInt:self.sense];
						NSNumber* angVelocity = [NSNumber numberWithFloat:angularvelocity];
						NSValue* centerPar = [NSValue valueWithPoint:anchorPoint];
						NSNumber* radiusPar = [NSNumber numberWithFloat:vect_1.module];
						NSNumber* gStatePar = [NSNumber numberWithInt:self.state];
						
						NSArray* objects = [NSArray arrayWithObjects:anglePar, sensePar,angVelocity, centerPar, radiusPar, gStatePar, nil];
						
						
						NSDictionary* params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
						[sender performGesture:@"TwoFingerRotate" withData:params];
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
