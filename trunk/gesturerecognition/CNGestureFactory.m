//
//  CNGestureFactory.m
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

#import "CNGestureFactory.h"

//SINGLETON

@implementation CNGestureFactory

@synthesize GesturesParams;

static CNGestureFactory* GestureFactoryInstance = nil;

+ (CNGestureFactory*)getGestureFactory{
	
	@synchronized(self) {
        
        if (GestureFactoryInstance == nil) {
			[[self alloc] init];// assignment not done here
        }
	}
	
    return GestureFactoryInstance;
}

+ (id)allocWithZone:(NSZone *)zone{
	
    @synchronized(self) {
        if (GestureFactoryInstance == nil) {
            return [super allocWithZone:zone];
        }
    }
    return GestureFactoryInstance;
}

- (id)init{
    Class myClass = [self class];
	
    @synchronized(myClass) {
        if (GestureFactoryInstance == nil) {
            if (self = [super init]) {
                GestureFactoryInstance = self;
				NSString* param;
				GesturesParams = [[NSMutableDictionary alloc] init];
				CoconuitConfig* myCoconuitConfigObj = [[CoconuitConfig alloc] init];
                // custom initialization here
				
				param = [myCoconuitConfigObj getConfigParamValue:@"GestureParams/SingleTapTime"];
				NSNumber* MaxSingleTapInterval = [NSNumber numberWithDouble:[param doubleValue]];
				
				param = [myCoconuitConfigObj getConfigParamValue:@"GestureParams/DoubleTapTime"];
				NSNumber* MaxDoubleTapInterval = [NSNumber numberWithDouble:[param doubleValue]];
				
				param = [myCoconuitConfigObj getConfigParamValue:@"GestureParams/HoldTime"];
				NSNumber* MinHoldTimeInterval = [NSNumber numberWithDouble:[param doubleValue]];
				
				param = [myCoconuitConfigObj getConfigParamValue:@"GestureParams/MoveVelocityThreshold"];
				NSNumber* MinMoveVelocity = [NSNumber numberWithDouble:[param doubleValue]];
				
				param = [myCoconuitConfigObj getConfigParamValue:@"GestureParams/OneFingerRotAngleThreshold"];
				NSNumber* MinRTbyMoveRotationAngle = [NSNumber numberWithDouble:[param doubleValue]];
				
				param = [myCoconuitConfigObj getConfigParamValue:@"GestureParams/TwoFingerRotAngleThreshold"];
				NSNumber* Min2FingerRotationAngle = [NSNumber numberWithDouble:[param doubleValue]];
				
				param = [myCoconuitConfigObj getConfigParamValue:@"GestureParams/TwoFingerScaleAngleThreshold"];
				NSNumber* Max2FingerScaleAngle = [NSNumber numberWithDouble:[param doubleValue]];
				
				param = [myCoconuitConfigObj getConfigParamValue:@"GestureParams/TwoFingerScaleValueThreshold"];
				NSNumber* Min2FingerScaleValue = [NSNumber numberWithDouble:[param doubleValue]];
				
				[GesturesParams setObject:MaxSingleTapInterval forKey:@"MaxSingleTapInterval"];
				[GesturesParams setObject:MaxDoubleTapInterval forKey:@"MaxDoubleTapInterval"];
				[GesturesParams setObject:MinHoldTimeInterval forKey:@"MinHoldTimeInterval"];
				[GesturesParams setObject:MinMoveVelocity forKey:@"MinMoveVelocity"];
				[GesturesParams setObject:MinRTbyMoveRotationAngle forKey:@"MinRTbyMoveRotationAngle"];
				[GesturesParams setObject:Min2FingerRotationAngle forKey:@"Min2FingerRotationAngle"];
				[GesturesParams setObject:Max2FingerScaleAngle forKey:@"Max2FingerScaleAngle"];
				[GesturesParams setObject:Min2FingerScaleValue forKey:@"Min2FingerScaleValue"];
				
            }
        }
    }
	
    return GestureFactoryInstance;
}

- (id)copyWithZone:(NSZone *)zone { return self; }

- (id)retain { return self; }

- (unsigned)retainCount { return UINT_MAX; }

- (void)release {}

- (id)autorelease { return self; }

///This method create and return a new Gesture Instance simple passing the GestureClassName
-(id)getGestureInstance:(NSString*)GestureClassName{
	
	Class GestureClass = NSClassFromString(GestureClassName);
    if([GestureClass instancesRespondToSelector:@selector(recognizeGesture:)]){
		CNGesture* newInstance = [GestureClass new];
		
		return newInstance;
		}
	else{
		return Nil;
	}
}

@end
