//
//  CN1FingerRotate.m
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

#import "CN1FingerRotate.h"
#import "CNLayer.h"
#import "Math.h"

@implementation CN1FingerRotate

@synthesize angle, angularVelocity;

-(id)init
{
	if(self = [super init]){
		super.GestureName = @"RotateByMove";
	}
	return self;
}

-(BOOL)recognize:(id)sender{
	if([sender isKindOfClass:[CNLayer class]]){
		NSMutableArray* gStrokes = [[sender myMultitouchEvent] strokes];
		CNLayer* layer = sender;
		if([gStrokes count] == 1){///By now no grouping for this gesture is supported. Is supposed that only one touch is in the active area.
			double rotation;
			
			double v = [[GesturesParams objectForKey:@"MinMoveVelocity"] doubleValue];
			NSPoint minVelocityMove = NSMakePoint(v,v);//external setup
			
			double MinRTbyMoveRotationAngle = [[GesturesParams objectForKey:@"MinRTbyMoveRotationAngle"] doubleValue];
			
			CNTouch* touch = [gStrokes lastObject];///get the current touch
			if(touch.type==ReleaseTouch){
				state=EndGesture;
			}
			
			if(pointIsGreater(touch.velocity,minVelocityMove) || state==EndGesture){///if the touch has linear velocity highter than a Threshold 

					CALayer*globalLayer = [sender globalLayer];
					CNTouch*last = [touch.strokePath objectAtIndex:([touch.strokePath count]-2)];///get previous touch position
					//CNTouch*last = [touch.strokePath objectAtIndex:(0)];///get previous touch position
				//NSLog(@"%f,%f", layer.bounds.size.width,layer.bounds.size.height);
					CGPoint pivotLpoint = CGPointMake(layer.anchorPoint.x*layer.bounds.size.width,(1-layer.anchorPoint.y)*layer.bounds.size.height);
					CGPoint pivotGpoint = [layer convertPoint:pivotLpoint toLayer:globalLayer];
					NSPoint pivotUpoint = NSPointFromCGPoint([layer realToUnit:pivotGpoint ofLayer:globalLayer]);///get the rotation pivot - layer anchorpoint
					CGPoint v1point = [layer unitToReal:CGPointMake(touch.position.x,1-touch.position.y) ofLayer:globalLayer];
					CGPoint v2point = [layer unitToReal:CGPointMake(last.position.x,1-last.position.y) ofLayer:globalLayer];				
				
					//NSLog(@"pivot: %f,%f",pivotUpoint.x,pivotUpoint.y);
					//CN2dVect* v1 = [[CN2dVect alloc] initWithPoint:pivotGpoint andPoint:NSMakePoint(last.position.x,(1-last.position.y))];///get the vector between the pivot and last position point: v1
					//CN2dVect* v2 = [[CN2dVect alloc] initWithPoint:pivotGpoint andPoint:NSMakePoint(touch.position.x,(1-touch.position.y))];///get the vector between the pivot and actual position point: v2
					CN2dVect* v1 = [[CN2dVect alloc] initWithPoint:NSPointFromCGPoint(pivotGpoint) andPoint:NSMakePoint(v1point.x, v1point.y)];///get the vector between the pivot and last position point: v1
					CN2dVect* v2 = [[CN2dVect alloc] initWithPoint:NSPointFromCGPoint(pivotGpoint) andPoint:NSMakePoint(v2point.x,v2point.y)];///get the vector between the pivot and actual position point: v2
				
					rotation = getAngleBetweenVector(v1,v2);///get angle between v1 and v2
				
					float rotSense = getRotationSenseBetweenVector(v1,v2);///get rotation sense between v1 and v2
					//NSLog(@"senso x angolo: %f", rotSense*(rotation*180/M_PI));
					sense = rotSense!=0? rotSense:sense;
					if(rotation>MinRTbyMoveRotationAngle*M_PI/180 || state==EndGesture){///if rotation value i greater than a threshold
						
						float dt = touch.timestamp-last.timestamp;///calc the angular velocity
						angularVelocity = (angularVelocity+rotation/dt)/2;
						
						///manage gesture state						
						if(state==BeginGesture){
							state=UpdateGesture;
						}
						
						if(state==WaitingGesture){
							state=BeginGesture;
						}
						
						double radius = sqrt(pow(v2.x,2)+pow(v2.y,2));
						
						///set the useful params for the animation
						NSArray* keys = [NSArray arrayWithObjects:@"rotation", @"sense", @"angularVelocity", @"center" ,@"radius",@"gState",nil];
						
						NSNumber* rotationPar = [NSNumber numberWithDouble:rotation];
						NSNumber* sensePar = [NSNumber numberWithInt:sense];
						NSNumber* angularVelocityParam = [NSNumber numberWithFloat:angularVelocity];
						NSValue* pivotPar = [NSValue valueWithPoint:pivotUpoint];
						NSNumber* radiusPar = [NSNumber numberWithFloat:radius];
						NSNumber* gStatePar = [NSNumber numberWithInt:state];
						
						NSArray* objects = [NSArray arrayWithObjects:rotationPar, sensePar, angularVelocityParam,pivotPar,radiusPar,gStatePar, nil];
						
						NSDictionary* params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
						
						if(rotation>0){
						[sender performGesture:@"OneFingerRotate" withData:params];///call perform OneFingerRotateGesture on the related layer [sender performGesture:@"OneFingerRotate" withData:params];
						}
						///passing Rotation Angle, Rotation Sense, Rotation Angular Velocity, Pivot Point and GestureState
						if(state==EndGesture){
							state=WaitingGesture;
						}
						
						return TRUE;
					}
			}
		}
	}
	return FALSE;
}
@end
