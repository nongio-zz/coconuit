//
//  CNDebugView.h
//  TuioClient
//
//  Created by Riccardo Canalicchio on 19/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CNView.h"
#import "CNStatusbarLayer.h"
#import "CNLightLayer.h"
#import "CNDebug.h"
#import "CNDebugLayer.h"
#import "CNWheel.h"

@interface CNDebugView : CNView {
	CNDebug*tcdbg;
	CNDebugLayer*circlesfortouches;
}
@property(retain) CNDebug*tcdbg;
@property(retain) CNDebugLayer*circlesfortouches;
@end
