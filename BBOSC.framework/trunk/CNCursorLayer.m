
#import "CNCursorLayer.h"


@implementation CNCursorLayer
@synthesize type,r,hover;

-(CNCursorLayer*)initWithRadius:(float)radius hover:(BOOL) ishover
{
	[super init];
	self.r = radius;
	self.type = @"CURSOR";
	self.bounds = CGRectMake(0.0, 0.0, self.r*2+10, self.r*2+10);
	self.hover = ishover;
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
	if(self.hover)
	{
		CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
		CGContextSetLineWidth (context,2.0);
		CGContextStrokeEllipseInRect(context,  CGRectMake(5,5,self.r*2,self.r*2));
	}
	else
	{
		const float pattern[2] = {2,4};
		CGContextSetLineDash(context,1.5, pattern ,1);
		CGContextSetRGBStrokeColor(context, 1.0, 0.8, 0.0, 1.0);
		CGContextSetLineWidth (context,2.0);
		CGContextStrokeEllipseInRect(context,  CGRectMake(5,5,self.r*2,self.r*2));	
	}
}
@end
