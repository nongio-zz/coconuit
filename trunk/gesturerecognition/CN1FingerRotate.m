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
#import "CNCircleLayer.h"
#import "CNLayer.h"
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
		CNLayer*layer = sender;
		if([gStrokes count] == 1){
			CNTouch* touch = [gStrokes lastObject];
			float rotation;
			
			double v = [[GesturesParams objectForKey:@"MinMoveVelocity"] doubleValue];
			NSPoint minVelocityMove = NSMakePoint(v,v);//external setup
			double MinRTbyMoveRotationAngle = [[GesturesParams objectForKey:@"MinRTbyMoveRotationAngle"] doubleValue];
			
			if([self pointIsGreater:touch.velocity than:minVelocityMove]){

					CALayer*globalLayer = [sender globalLayer];
					CNTouch*last = [touch.strokePath objectAtIndex:([touch.strokePath count]-2)];
					NSPoint lastGpoint = NSMakePoint(last.position.x*globalLayer.bounds.size.width, (1-last.position.y)*globalLayer.bounds.size.height);
					NSPoint currentGpoint = NSMakePoint(touch.position.x*globalLayer.bounds.size.width, (1-touch.position.y)*globalLayer.bounds.size.height);
					
					CGPoint pivotLpoint = CGPointMake(layer.anchorPoint.x*layer.bounds.size.width,layer.anchorPoint.y*layer.bounds.size.height);
					CGPoint pivotGpoint = [layer convertPoint:pivotLpoint toLayer:globalLayer];
					
					NSPoint pivot = NSMakePoint(pivotGpoint.x, pivotGpoint.y);
					
					CN2dVect* v1 = [[CN2dVect alloc] initWithPoint:pivot andPoint:lastGpoint];
					CN2dVect* v2 = [[CN2dVect alloc] initWithPoint:pivot andPoint:currentGpoint];
					
					rotation = getAngleBetweenVector(v1,v2);
				
					float sense = getRotationSenseBetweenVector(v1,v2);
					
					if(rotation>MinRTbyMoveRotationAngle*M_PI/180){
						float dt = touch.timestamp-last.timestamp;
						angularVelocity = (angularVelocity+rotation/dt)/2;
						if(state==WaitingGesture){
							state=BeginGesture;
						}
						else{
							if(touch.type==ReleaseTouch){
								state = EndGesture;
							}
							else{
								state=UpdateGesture;
							}
						}
						//il pivot è in coordinate globali
						//[sender oneFingerRotate:rotation withSense:sense andVelocity:angularVelocity andCenter:pivot andRadius:v2.module andGestureState:self.state];
						
						NSArray* keys = [NSArray arrayWithObjects:@"rotation", @"sense", @"angularVelocity", @"center" ,@"radius",@"gState",nil];
						
						NSNumber* rotationPar = [NSNumber numberWithFloat:rotation];
						NSNumber* sensePar = [NSNumber numberWithInt:sense];
						NSNumber* angularVelocityParam = [NSNumber numberWithFloat:angularVelocity];
						NSValue* pivotPar = [NSValue valueWithPoint:pivot];
						NSNumber* radiusPar = [NSNumber numberWithFloat:v2.module];
						NSNumber* gStatePar = [NSNumber numberWithInt:self.state];
						
						NSArray* objects = [NSArray arrayWithObjects:rotationPar, sensePar, angularVelocityParam,pivotPar,radiusPar,gStatePar, nil];
						
						
						NSDictionary* params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
						
						
						
						[sender performGesture:@"OneFingerRotate" withData:params];
						
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
