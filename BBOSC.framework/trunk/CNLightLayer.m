//
//  CNLightLayer.m
//  TuioClient
//
//  Created by Riccardo Canalicchio on 23/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CNLightLayer.h"


@implementation CNLightLayer
@synthesize light, lightcolor,label,console,observedGestureName;
-(id)initWithLabel:(NSString*)newlabel observedGestureName:(NSString*)gesturename andColor:(CGColorRef)color withConsole:(BOOL)wantconsole
{
	if(self=[super init])
	{
		observedGestureName = gesturename;
		light = [CALayer layer];
		lightcolor = color;
		label = [CATextLayer layer];
		label.string = newlabel;
		if(wantconsole)
			console = [CATextLayer layer];
		[self setupLayers];
	}
	return self;
}
-(void)setupLayers
{
//LIGHT
	light.frame = CGRectMake(0.0, 0.0, 44, 44);
	[light setBackgroundColor:CGColorCreateGenericCMYK(0, 0, 0, 0, 1)];
	light.cornerRadius = 22;
	light.position = CGPointMake(0.0,17.0);
//LABEL INSIDE LIGHT
	label.font= @"Helvetica";
	label.fontSize=12.0;
	label.alignmentMode = kCAAlignmentCenter;
	label.foregroundColor=CGColorCreateGenericCMYK(1, 1, 1, 1, 1);
	label.frame = CGRectMake(0.0,0.0,44.0,12.0);
	label.anchorPoint = CGPointMake(0.5, 0.5);
	label.position = CGPointMake(22.0,21.0);
//RECTANGLE WITH CONSOLE
	if(console)
	{
		[self setBackgroundColor:CGColorCreateGenericCMYK(0.06, 0.04, 0.05, 0, 1)];
		self.cornerRadius = 5;
		self.frame = CGRectMake(0.0, 0.0, 80, 34);
		console.string = @"";
		console.font= @"Helvetica";
		console.fontSize=16.0;
		console.alignmentMode = kCAAlignmentCenter;
		console.foregroundColor=CGColorCreateGenericCMYK(1, 1, 1, 1, 1);
		console.frame = CGRectMake(0.0,0.0,50.0,16.0);
		console.anchorPoint = CGPointMake(0, 0.5);
		console.position = CGPointMake(25.0,17.0);
		[self addSublayer:console];
	}
	else
	{
		self.frame = CGRectMake(0.0, 0.0, 44, 34);		
	}
//ADD LAYERS
	[light addSublayer:label];
	[self addSublayer:light];
}
-(void)switchLight
{
	CABasicAnimation* pulseAnimation = [CABasicAnimation animation];
	pulseAnimation.keyPath = @"backgroundColor";
	
	pulseAnimation.fromValue = (id)self.backgroundColor;
	pulseAnimation.toValue = (id)lightcolor;
	pulseAnimation.duration = 0.1;
	pulseAnimation.autoreverses = YES;
	pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:
									 kCAMediaTimingFunctionEaseInEaseOut];
	[light addAnimation:pulseAnimation forKey:@"pulseAnimation"];
}
-(void)trace:(NSString*)sometext
{
	console.string = sometext;
}
-(void)notify:(id)anObject
{
	if([anObject isKindOfClass:[NSDictionary class]])
	{
		NSDictionary*gesturenotice = (NSMutableDictionary*)anObject;
		NSString* gesturename = [gesturenotice objectForKey:@"GestureName"];
		if([gesturename isEqualToString:self.observedGestureName]){
			[self switchLight];
			[self trace:[[gesturenotice objectForKey:@"gState"] stringValue]];
		}
	}
}
@end
