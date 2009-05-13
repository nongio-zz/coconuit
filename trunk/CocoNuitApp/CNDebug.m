//
//  debugComponent.m
//  TuioClient
//
//  Created by Riccardo Canalicchio on 18/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CNDebug.h"

@implementation CNDebug
@synthesize log,currentgesture,currentgesturestate;

-(CNDebug*)initWithImage:(NSString*)img{
	if (self =[super init]){
		
	self.frame = CGRectMake(0.0, 0.0, 400, 400);
//	[self setBackgroundColor:CGColorCreateGenericRGB( 1, 0, 0.3, 1.0)];
	NSImage *anImage  = [NSImage imageNamed:img];
	NSBitmapImageRep *bitrep = [NSBitmapImageRep imageRepWithData:[anImage TIFFRepresentation]];
	[bitrep retain];
	self.contents = (id)[bitrep CGImage];
	//[self addSublayer:console];
	CNGestureFactory* theGestureFactory = [CNGestureFactory getGestureFactory];
	[self.GestureRecognizer addChildGesture: [theGestureFactory getGestureInstance:@"CNTap"]];
	[self.GestureRecognizer addChildGesture: [theGestureFactory getGestureInstance:@"CNHold"]];
	[self.GestureRecognizer addChildGesture: [theGestureFactory getGestureInstance:@"CNMove"]];
	[self.GestureRecognizer addChildGesture: [theGestureFactory getGestureInstance:@"CN2FingerRotate"]];
	[self.GestureRecognizer addChildGesture: [theGestureFactory getGestureInstance:@"CN2FingerScale"]];
	[self.GestureRecognizer addChildGesture: [theGestureFactory getGestureInstance:@"CNPress"]];
	[self.GestureRecognizer addChildGesture: [theGestureFactory getGestureInstance:@"CNRelease"]];
	[self.GestureRecognizer addChildGesture: [theGestureFactory getGestureInstance:@"CNTap"]];
		
	//Animations
	CABasicAnimation *position = [CABasicAnimation animation];
	position.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	[position setDuration:0.1];
	self.actions = [NSDictionary dictionaryWithObject:position 
													  forKey:@"position"];
	}
	return self;
}

-(void)CNPress:(NSDictionary*)params{
		[self onTop];
}

-(void)updateTouch:(NSDictionary*)params{

}

-(void)CNRelease:(NSDictionary*)params{

}

-(void)CNTap:(NSDictionary*)params{}

-(void)DoubleTap{
	self.transform = CATransform3DIdentity;
}

-(void)CNHold{
	
}

-(void)Move:(NSDictionary*)params{

	CN2dVect* vectT = [params objectForKey:@"translation"];
	NSPoint velocity = (NSPoint)[[params objectForKey:@"velocity"] pointValue];
	//NSPoint center = (NSPoint)[[params objectForKey:@"center"] pointValue];
	velocity = NSMakePoint(velocity.x*sign(vectT.x), velocity.y*sign(vectT.y));
	int gestureState = [[params objectForKey:@"gState"] intValue];
	
	/*
	center = NSMakePoint(center.x,1-center.y);
	CALayer* globalLayer = [self globalLayer];
	CGPoint localcenter = [self convertPoint:[self unitToReal:NSPointToCGPoint(center) ofLayer:globalLayer] fromLayer:globalLayer];
	if(gestureState==BeginGesture)
	{
		[self changeAnchorPoint:[self realToUnit:localcenter ofLayer:self]];
	}
	*/
	
	//soglia per la velocità
	if(fabs(velocity.x) > 0.9)
		velocity.x = 0.9*sign(velocity.x);
	if(fabs(velocity.y) > 0.9)
		velocity.y = 0.9*sign(velocity.y);
	
	CALayer*sl  = [self globalLayer];
	
	//la velocità è in coordinate unitare va moltiplicata per le dimensioni del layer globale
	velocity.x = velocity.x*sl.bounds.size.width;
	velocity.y = (-1)*(velocity.y)*sl.bounds.size.height; //il segno della velocità è al contrario...
	float tx = fabs(velocity.x)*0.001;
	float ty = fabs(velocity.y)*0.001;
	float t = 0.3 +maxAbs(tx, ty);
	
	if(gestureState!=EndGesture)
	{
		//viene usata l'animazione di default impostata all'inizio
		CALayer*sl = [self globalLayer];
		CGPoint newPoint = CGPointMake(self.position.x-(vectT.x*sl.bounds.size.width),self.position.y+(vectT.y*sl.bounds.size.height));	
		self.position = newPoint;
	}
		else
	{
		//quando il gesto è finito c'è una animazione smorzata in fondo in base alla velocità attuale
		[CATransaction begin];
		CABasicAnimation *position = [CABasicAnimation animationWithKeyPath:@"position"];
		position.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
		position.duration = t;
		[self addAnimation:position forKey:@"position"];
		//nuova posizione = p0 + 0.5 * v^2/gm
		CGPoint newpoint = CGPointMake(sign(velocity.x)*0.5*pow(velocity.x,2)*0.001 , sign(velocity.y)*0.5*pow(velocity.y,2)*0.001);
		self.position = CGPointMake(self.position.x+newpoint.x,self.position.y+newpoint.y);
		[CATransaction commit];
	}
}

-(void)TwoFingerScale:(NSDictionary*)params{
	
	double scaleFactor = [[params objectForKey:@"scaleValue"] doubleValue];
	NSPoint center = [[params objectForKey:@"center"] pointValue];
	int gestureState = [[params objectForKey:@"gState"] intValue];
	
	center = NSMakePoint(center.x,1-center.y);
	CALayer* globalLayer = [self globalLayer];
	CGPoint localcenter = [self convertPoint:[self unitToReal:NSPointToCGPoint(center) ofLayer:globalLayer] fromLayer:globalLayer];
	if(gestureState==BeginGesture)
	{
		[self changeAnchorPoint:[self realToUnit:localcenter ofLayer:self]];
	}
	if(gestureState!=EndGesture)
	{		
		[CATransaction begin];
		[CATransaction setValue:(id)kCFBooleanTrue
						 forKey:kCATransactionDisableActions];
			CATransform3D scale = CATransform3DIdentity;
			scale = CATransform3DMakeScale(scaleFactor,scaleFactor, 1.0);
			self.transform = CATransform3DConcat(self.transform, scale);	
		[CATransaction commit];
	}
}

-(void)TwoFingerRotate:(NSDictionary*)params{
	float rotationAngle = [[params objectForKey:@"angle"] floatValue];
	int sense =  [[params objectForKey:@"sense"] intValue];
	float angularvelocity = [[params objectForKey:@"angularVelocity"] floatValue];
	int gestureState = [[params objectForKey:@"gState"] intValue];
	NSPoint center = [[params objectForKey:@"center"] pointValue];

	
	center = NSMakePoint(center.x,1-center.y);
	CALayer* globalLayer = [self globalLayer];
	CGPoint localcenter = [self convertPoint:[self unitToReal:NSPointToCGPoint(center) ofLayer:globalLayer] fromLayer:globalLayer];
	if(gestureState==BeginGesture)
	{
		[self changeAnchorPoint:[self realToUnit:localcenter ofLayer:self]];
	}
	
	if(gestureState!=EndGesture)
	{
		[CATransaction begin];
		[CATransaction setValue:(id)kCFBooleanTrue
						 forKey:kCATransactionDisableActions];
		CATransform3D rotate = CATransform3DIdentity;
		rotate = CATransform3DMakeRotation(rotationAngle, 0, 0, -sense); 
		self.transform = CATransform3DConcat(self.transform, rotate);
		[CATransaction commit];
	}else{
		
		NSLog(@"rotAngle: %f",angularvelocity);
		
		if(fabs(angularvelocity) > 0.9)
			angularvelocity = 0.9*sign(angularvelocity);
		
		double t = 0.1 + fabs(angularvelocity)*0.7;
		float rotation = (0.5*pow(angularvelocity,2)*0.7);
		
		[CATransaction begin];
		[CATransaction setValue:[NSNumber numberWithFloat:t]
						 forKey:kCATransactionAnimationDuration];
		CATransform3D rotate = CATransform3DMakeRotation(rotation, 0, 0, -sense); 
		self.transform = CATransform3DConcat(self.transform, rotate);
		[CATransaction commit];
	}
}

-(void)OneFingerRotate:(NSDictionary*)params{
	
}
- (CAMediaTimingFunction *)getTimingFunction 
{ 
	CGFloat c1x = 0.0; 
	CGFloat c1y = 0.0; 
	CGFloat c2x = 0.3; 
	CGFloat c2y = 0.6; 
	return [CAMediaTimingFunction functionWithControlPoints:c1x :c1y :c2x :c2y]; 
} 
-(void) onTop
{
	for(id layer in [[self superlayer] sublayers])
	{
		((CALayer*)layer).zPosition = 10;
	}
	self.zPosition = 20;
}

@end
