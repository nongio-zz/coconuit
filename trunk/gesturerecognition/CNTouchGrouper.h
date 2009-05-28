//
//  CNTouchGrouper.h
//  CocoNuitApp
//
//  Created by Nicola Martorana on 25/05/09.
//  Copyright 2009 Unifi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CNTouchGroup.h"

@interface CNTouchGrouper : NSObject {
	NSMutableArray* TouchGroups;
	NSArray* SortedTouchGroups;
	
}

-(id)initWithTouches:(NSMutableArray*)touches;
-(CNTouchGroup*)touchHasGroup:(CNTouch*)aTouch;
-(void)sortByGroupSize;
-(CNTouchGroup*)getGroupAtIndex:(int)i;
-(CNTouch*)getRapresentativeOfGroupAtIndex:(int)index;
-(int)groupsNumber;

@end
