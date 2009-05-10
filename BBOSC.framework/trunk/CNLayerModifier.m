//
//  CNLayerModifier.m
//  TuioClient
//
//  Created by Nicola Martorana on 19/03/09.
//  Copyright 2009 Unifi. All rights reserved.
//

#import "CNLayerModifier.h"

#import "CNLayer.h"


@implementation CNLayerModifier

-(void)drawTCLayer:(id)sender{

}

-(void)singleTap{

}

-(BOOL)rotateLayer:(id)aLayer{
	if([aLayer isKindOfClass:[CNLayer class]]){
	
	}
	return TRUE;
}

-(BOOL)scaleLayer:(id)aLayer{
		if([aLayer isKindOfClass:[CNLayer class]]){
			
		}
	return TRUE;
}

-(BOOL)selectLayer:(id)aLayer{
		if([aLayer isKindOfClass:[CNLayer class]]){
			
		}
	return TRUE;
}

-(BOOL)releaseLayer:(id)aLayer{
		if([aLayer isKindOfClass:[CNLayer class]]){
			
		}
	return TRUE;
}

-(BOOL)dragLayer:(id)aLayer{
		if([aLayer isKindOfClass:[CNLayer class]]){
			
		}
	return TRUE;
}

@end
