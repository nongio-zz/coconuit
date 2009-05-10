//
//  CNLightLayer.h
//  TuioClient
//
//  Created by Riccardo Canalicchio on 23/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/CoreAnimation.h>
#import "CNObserverProtocol.h"

@interface CNLightLayer : CALayer <CNObserverProtocol>{
	CALayer *light;
	CGColorRef lightcolor;
	CATextLayer *console;
	CATextLayer *label;
	NSString*observedGestureName;
}
@property(retain)NSString*observedGestureName;
@property(retain)CALayer *light;
@property(retain)CATextLayer *console;
@property(retain)CATextLayer *label;
@property(assign)CGColorRef lightcolor;
-(id)initWithLabel:(NSString*)newlabel observedGestureName:(NSString*)gesturename andColor:(CGColorRef)color withConsole:(BOOL)wantconsole;
-(void)setupLayers;
-(void)switchLight;
-(void)trace:(NSString*)sometext;
@end
