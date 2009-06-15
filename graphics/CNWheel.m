//
//  CNWheel.m
//  CocoNuitApp
//
//  Created by Nicola Martorana on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CNWheel.h"


@implementation CNWheel
-(id)init
{
	if (self =[super init]){
		self.backgroundColor = CGColorCreateGenericRGB(0.0, 0.0, 0.0, 1);		
		self.frame = CGRectMake(0.0, 0.0, 200, 200);
		self.cornerRadius=100;
		
		self.anchorPoint = CGPointMake(0.5,0.5);
		CALayer*c=[CALayer layer];
		c.frame=CGRectMake(0, 0, 20, 20);
		c.backgroundColor=CGColorCreateGenericRGB(1, 1, 1, 1);
		c.cornerRadius=10;
		c.position=CGPointMake(100,180);
		[self addSublayer:c];
		
		CNGestureFactory* theGestureFactory = [CNGestureFactory getGestureFactory];
		[self.GestureRecognizer addChildGesture: [theGestureFactory getGestureInstance:@"CN1FingerRotate"]];

		
		//Animations
		CABasicAnimation *position = [CABasicAnimation animation];
		position.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
		[position setDuration:0.1];
		
		CABasicAnimation *transformation = [CABasicAnimation animation];
		transformation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
		[transformation setDuration:0.1];
		
		self.actions = [NSDictionary dictionaryWithObjectsAndKeys:position,@"position",[NSNull null],@"transform",[NSNull null],@"anchorPoint",nil];
		
		
	}
	return self;
}
-(void)OneFingerRotate:(NSDictionary*)params{
	//float radius = [[params objectForKey:@"radius"] floatValue];
	double rotationAngle = [[params objectForKey:@"rotation"] doubleValue];
	int sense =  [[params objectForKey:@"sense"] intValue];
	int gestureState = [[params objectForKey:@"gState"] intValue];
	//NSLog(@"gesture angle: %f", rotationAngle);
	//NSLog(@"gesture sense: %d", sense);
	if(gestureState!=EndGesture)
	{	
		//CATransform3D i = CATransform3DIdentity;
		self.transform = CATransform3DRotate(self.transform, rotationAngle, 0.0, 0.0, -sense);
	}
	
}
@end
