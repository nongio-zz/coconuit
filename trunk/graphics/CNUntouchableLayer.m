//
//  CNUntouchableLayer.m
//  TuioClient
//
//  Created by Riccardo Canalicchio on 31/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CNUntouchableLayer.h"


@implementation CNUntouchableLayer
- (BOOL)containsPoint:(CGPoint)p
{
	return FALSE;
}
@end
