#import <Cocoa/Cocoa.h>
#import <QuartzCore/CoreAnimation.h>
#import <Quartz/Quartz.h>
#import "CNUntouchableLayer.h"

@interface CNCircleLayer : CNUntouchableLayer {
	NSString *type;
	float r;
}
@property (retain) NSString*type;
@property float r;

-(CNCircleLayer*)initWithRadius:(float)r;

@end
