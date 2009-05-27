//
//  CNTouchGroup.h
//  CocoNuitApp
//
//  Created by Nicola Martorana on 25/05/09.
//  Copyright 2009 Unifi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CNTouch.h"


@interface CNTouchGroup : NSObject {
	int groupSize;
	CNTouch* rapresentativeTouch;
	NSMutableArray* otherTouches;
}

@property (assign) int groupSize;
@property (retain) CNTouch* rapresentativeTouch;
@property (retain) NSMutableArray* otherTouches;

-(void)addTouch:(CNTouch*)aTouch;

@end
