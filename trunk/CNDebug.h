//
//  debugComponent.h
//  TuioClient
//
//  Created by Riccardo Canalicchio on 18/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CNLayer.h"
#import "CN1FingerRotate.h"
#import "CNTap.h"
#import "CNHold.h"
#import "CNMove.h"
#import "CN2FingerScale.h"
#import "CN2FingerRotate.h"
#import "CNGestureFactory.h"
#import "CNCircleLayer.h"

@interface CNDebug : CNLayer {
	NSString*	log;
	NSString*	currentgesture;
	NSString*	currentgesturestate;
}

@property(retain) NSString *log,*currentgesture,*currentgesturestate;
-(CNDebug*)initWithImage:(NSString*)img;
- (CAMediaTimingFunction *)getTimingFunction;
-(void) onTop;
@end
