//
//  CNTouchGrouper.m
//  CocoNuitApp
//
//  Created by Nicola Martorana on 25/05/09.
//  Copyright 2009 Unifi. All rights reserved.
//

#import "CNTouchGrouper.h"
#import "CNTouchGroup.h"
#import "CNMath.h"

@implementation CNTouchGrouper

-(id)initWithTouches:(NSMutableArray*)touches{
	if(self = [super init]){
		
		TouchGroups = [[NSMutableArray alloc] init];

		for(CNTouch* touch in touches){
			if([TouchGroups count]==0){
				CNTouchGroup* aGroup = [[CNTouchGroup alloc] init];
				[aGroup addTouch:touch];
				[TouchGroups addObject:aGroup];
				}
			else{
				CNTouchGroup* t = [self touchHasGroup:touch];
				if(t){
					[t addTouch:touch];
					}
				else{
					CNTouchGroup* aGroup = [[CNTouchGroup alloc] init];
					[aGroup addTouch:touch];
					[TouchGroups addObject:aGroup];
					}
				}
		}
		
		[self sortByGroupSize];
		
		
	}
	return self;
}

-(CNTouchGroup*) touchHasGroup:(CNTouch*)aTouch{
	for(CNTouchGroup* tGroup in TouchGroups){
		CNTouch* rapresentative = [tGroup rapresentativeTouch];
		
		CN2dVect* vect0 = [[CN2dVect alloc] initWithPoint:NSMakePoint(0, 0) andPoint:rapresentative.velocity];
		CN2dVect* vect1 = [[CN2dVect alloc] initWithPoint:NSMakePoint(0, 0) andPoint:aTouch.velocity];
		
		double alfa = getAngleBetweenVector(vect0, vect1);
		
		if(fabs(alfa)<M_PI/360){
			return tGroup;
		}
	}
	
	return Nil;
}

-(void)sortByGroupSize{
	SortedTouchGroups = [TouchGroups sortedArrayUsingSelector:@selector(groupSize)];
}

-(CNTouchGroup*)getGroupAtIndex:(int)index{
	if(index<[SortedTouchGroups count]){
		return [SortedTouchGroups objectAtIndex:index];
	}
	else{
		return Nil;
	}
}

-(CNTouch*)getRapresentativeOfGroupAtIndex:(int)index{
	if(index<[SortedTouchGroups count]){
		return [[SortedTouchGroups objectAtIndex:index] rapresentativeTouch];
	}
	else{
		return Nil;
	}
}

-(int)groupsNumber{
	return [SortedTouchGroups count];
}


@end
