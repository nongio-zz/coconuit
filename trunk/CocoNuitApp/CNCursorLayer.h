#import <Cocoa/Cocoa.h>
#import <QuartzCore/CoreAnimation.h>
#import <Quartz/Quartz.h>
#import "CNUntouchableLayer.h"

@interface CNCursorLayer : CNUntouchableLayer {
	NSString *type;
	BOOL hover;
	float r;
}
@property (retain) NSString*type;
@property float r;
@property BOOL hover;

-(CNCursorLayer*)initWithRadius:(float)r hover:(BOOL)ishover;
@end
