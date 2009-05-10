//
//  CNSetupWinController.m
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

#import "CNSetupWinController.h"
#import "CNGestureFactory.h"


@implementation CNSetupWinController

-(IBAction) UpdateParams:(id)sender{
	CNGestureFactory* theGestureFactory = [CNGestureFactory getGestureFactory];
	
	NSNumber* MaxSingleTapInterval = [NSNumber numberWithDouble:[MaxSingleTapIntervalTxtF doubleValue]];
	[theGestureFactory.GesturesParams setObject:MaxSingleTapInterval forKey:@"MaxSingleTapInterval"];
	
	NSNumber* MaxDoubleTapInterval = [NSNumber numberWithDouble:[MaxDoubleTapIntervalTxtF doubleValue]];
	[theGestureFactory.GesturesParams setObject:MaxDoubleTapInterval forKey:@"MaxDoubleTapInterval"];
	
	NSNumber* MinHoldTimeInterval = [NSNumber numberWithDouble:[MinHoldTimeIntervalTxtF doubleValue]];
	[theGestureFactory.GesturesParams setObject:MinHoldTimeInterval forKey:@"MinHoldTimeInterval"];
	
	NSNumber* MinMoveVelocity = [NSNumber numberWithDouble:[MinMoveVelocityTxtF doubleValue]];
	[theGestureFactory.GesturesParams setObject:MinMoveVelocity forKey:@"MinMoveVelocity"];
	
	NSNumber* MinRTbyMoveRotationAngle = [NSNumber numberWithDouble:[MinMoveVelocityTxtF doubleValue]];
	[theGestureFactory.GesturesParams setObject:MinRTbyMoveRotationAngle forKey:@"MinRTbyMoveRotationAngle;"];
	
	NSNumber* Min2FingerRotationAngle = [NSNumber numberWithDouble:[Min2FingerRotationAngleTxtF doubleValue]];
	[theGestureFactory.GesturesParams setObject:Min2FingerRotationAngle forKey:@"Min2FingerRotationAngle"];

	NSNumber* Min2FingerScaleAngle = [NSNumber numberWithDouble:[Min2FingerScaleAngleTxtF doubleValue]];
	[theGestureFactory.GesturesParams setObject:Min2FingerScaleAngle forKey:@"Min2FingerScaleAngle"];

	NSNumber* Min2FingerScaleValue = [NSNumber numberWithDouble:[Min2FingerScaleValueTxtF doubleValue]];
	[theGestureFactory.GesturesParams setObject:Min2FingerScaleValue forKey:@"Min2FingerScaleValue"];
	
	[SetupWindow close];
}

-(IBAction) cancel:(id)sender{
	[SetupWindow close];
}

- (BOOL)windowShouldClose:(id)window{
	CNGestureFactory* theGestureFactory = [CNGestureFactory getGestureFactory];
	
	[MaxSingleTapIntervalTxtF setStringValue:[[theGestureFactory.GesturesParams objectForKey:@"MaxSingleTapInterval"] stringValue]];
	[MaxDoubleTapIntervalTxtF setStringValue:[[theGestureFactory.GesturesParams objectForKey:@"MaxDoubleTapInterval"] stringValue]];
	[MinHoldTimeIntervalTxtF setStringValue:[[theGestureFactory.GesturesParams objectForKey:@"MinHoldTimeInterval"] stringValue]];
	[MinMoveVelocityTxtF setStringValue:[[theGestureFactory.GesturesParams objectForKey:@"MinMoveVelocity"] stringValue]];
	[MinRTbyMoveRotationAngleTxtF setStringValue:[[theGestureFactory.GesturesParams objectForKey:@"MinRTbyMoveRotationAngle"] stringValue]];
	[Min2FingerRotationAngleTxtF setStringValue:[[theGestureFactory.GesturesParams objectForKey:@"Min2FingerRotationAngle"] stringValue]];
	[Min2FingerScaleAngleTxtF setStringValue:[[theGestureFactory.GesturesParams objectForKey:@"Max2FingerScaleAngle"] stringValue]];
	[Min2FingerScaleValueTxtF setStringValue:[[theGestureFactory.GesturesParams objectForKey:@"Min2FingerScaleValue"] stringValue]];
	
	return TRUE;
}

-(void) awakeFromNib{
	
	CNGestureFactory* theGestureFactory = [CNGestureFactory getGestureFactory];
	[MaxSingleTapIntervalTxtF setStringValue:[[theGestureFactory.GesturesParams objectForKey:@"MaxSingleTapInterval"] stringValue]];
	[MaxDoubleTapIntervalTxtF setStringValue:[[theGestureFactory.GesturesParams objectForKey:@"MaxDoubleTapInterval"] stringValue]];
	[MinHoldTimeIntervalTxtF setStringValue:[[theGestureFactory.GesturesParams objectForKey:@"MinHoldTimeInterval"] stringValue]];
	[MinMoveVelocityTxtF setStringValue:[[theGestureFactory.GesturesParams objectForKey:@"MinMoveVelocity"] stringValue]];
	[MinRTbyMoveRotationAngleTxtF setStringValue:[[theGestureFactory.GesturesParams objectForKey:@"MinRTbyMoveRotationAngle"] stringValue]];
	[Min2FingerRotationAngleTxtF setStringValue:[[theGestureFactory.GesturesParams objectForKey:@"Min2FingerRotationAngle"] stringValue]];
	[Min2FingerScaleAngleTxtF setStringValue:[[theGestureFactory.GesturesParams objectForKey:@"Max2FingerScaleAngle"] stringValue]];
	[Min2FingerScaleValueTxtF setStringValue:[[theGestureFactory.GesturesParams objectForKey:@"Min2FingerScaleValue"] stringValue]];

}


@end