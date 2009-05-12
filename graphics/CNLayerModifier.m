//
//  CNLayerModifier.m
//
//  CocoNuit is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version. 
//
//  CocoNuit is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Lesser General Public License for more details.
//
//  You should have received a copy of the GNU Lesser General Public License
//  along with CocoNuit.  If not, see <http://www.gnu.org/licenses/>.
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
