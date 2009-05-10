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
			[[self alloc] init];     // assignment not done here
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
				
				GesturesParams = [[NSMutableDictionary alloc] init];
                // custom initialization here
				
				NSNumber* MaxSingleTapInterval = [NSNumber numberWithDouble:0.15];
				NSNumber* MaxDoubleTapInterval = [NSNumber numberWithDouble:0.25];
				NSNumber* MinHoldTimeInterval = [NSNumber numberWithDouble:2];
				NSNumber* MinMoveVelocity = [NSNumber numberWithDouble:0.13];
				NSNumber* MinRTbyMoveRotationAngle = [NSNumber numberWithDouble:1];
				NSNumber* Min2FingerRotationAngle = [NSNumber numberWithDouble:1];
				NSNumber* Max2FingerScaleAngle = [NSNumber numberWithDouble:2.6];
				NSNumber* Min2FingerScaleValue = [NSNumber numberWithDouble:0.0000003];
				
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
