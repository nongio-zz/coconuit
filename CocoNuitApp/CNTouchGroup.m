//
//  CNTouchGroup.m
//  CocoNuitApp
//
//  Created by Nicola Martorana on 25/05/09.
//  Copyright 2009 Unifi. All rights reserved.
//

#import "CNTouchGroup.h"


@implementation CNTouchGroup

@synthesize groupSize,rapresentativeTouch,otherTouches;

-(id) init{
	if(self = [super init]){
		groupSize=0;
		rapresentativeTouch=Nil;
		otherTouches = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void)addTouch:(CNTouch*)aTouch{
	if(rapresentativeTouch==Nil){
		rapresentativeTouch=aTouch;
	}
	else{
		[otherTouches addObject:aTouch];
		groupSize++;
	}
}

@end
