//
//  statusLayer.m
//  TuioClient
//
//  Created by Riccardo Canalicchio on 22/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CNStatusbarLayer.h"

@implementation CNStatusbarLayer
-(id)init
{
	if(self=[super init])
	{
		[self setNeedsDisplay];
	}
	return self;
}
- (void)drawInContext:(CGContextRef)context
{
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceCMYK();
	//colori per gradiente giallo
	//CGFloat colors[10] = {0.07, 0.04, 0.34, 0, 1, 0.02, 0, 0.16, 0, 1};
	CGFloat colors[10] = {0.38, 0.31, 0.31, 0, 1, 0.12, 0.09, 0.10, 0, 1};
	CGFloat locations[2] = {0, 1};
	CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, 2);
	CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, 50), 0);

}
@end
