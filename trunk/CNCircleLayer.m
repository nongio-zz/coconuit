
#import "CNCircleLayer.h"


@implementation CNCircleLayer
@synthesize type,r;

-(CNCircleLayer*)initWithRadius:(float)radius
{
	[super init];
	self.r = radius;
	self.type = @"CIRCLE";
	self.bounds = CGRectMake(0.0, 0.0, self.r*2, self.r*2);
	[self setNeedsDisplay];
	NSMutableDictionary *customActions=[NSMutableDictionary dictionaryWithDictionary:[self actions]];
	[customActions setObject:[NSNull null] forKey:@"position"];
	[customActions setObject:[NSNull null] forKey:@"transform"];
	[customActions setObject:[NSNull null] forKey:@"opacity"];
	self.actions=customActions;
	return self;
}

- (void)drawInContext:(CGContextRef)context
{
	CGContextSetRGBFillColor(context, 0.6, 0.6, 0.6, 1.0);
	CGContextFillEllipseInRect(context,  CGRectMake(0,0,self.r*2,self.r*2));
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, self.r, self.r);
	CGContextAddLineToPoint(context, self.r, self.r*2);
	CGContextStrokePath(context);
}
@end
