//
//  debugLayer.h
//  TuioClient
//
//  Created by Riccardo Canalicchio on 17/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CNLayer.h"
#import "CNCursorLayer.h"


@interface CNDebugLayer : CNLayer {
	NSMutableDictionary*layersForTouches;
	QCCompositionLayer*qc;
}
-(void) redraw;
-(void) setStroke:(CNStroke*)touch hover:(BOOL)ishover;
-(NSString*)keyForID:(NSInteger)num;
@property (nonatomic,retain) NSMutableDictionary*layersForTouches;
@end
