//
//  CoconuitConfig.m
//  CocoaXml
//
//  Created by Nicola Martorana on 17/05/09.
//  Copyright 2009 Unifi. All rights reserved.
//

#import "CoconuitConfig.h"


@implementation CoconuitConfig

-(id)init{
	if(self=[super init]){
		err = nil;
		NSString * baseurl = [[NSBundle mainBundle] resourcePath];
		baseurl = [baseurl substringToIndex:[baseurl length]-34];
		ConfigFile=[NSString stringWithFormat:@"%@CocoNuitConfig.xml", baseurl];
		NSLog(@"%@",ConfigFile);
		ConfigFileUrl = [NSURL fileURLWithPath:ConfigFile];
		
		if (!ConfigFileUrl) {
			NSLog(@"Can't create an URL from file %@.", ConfigFile);
		}
		else{
			xmlDoc = [[NSXMLDocument alloc] initWithContentsOfURL:ConfigFileUrl
														  options:(NSXMLNodePreserveWhitespace|NSXMLNodePreserveCDATA)
															error:&err];
			
			if (xmlDoc == nil) {
				if (err) {
					NSLog([err localizedDescription]);
				}
			}
			if (err) {
				NSLog([err localizedDescription]);
			}
		}
	}
	
	return self;
}

-(NSString*) getConfigParamValue:(NSString*)paramPath{
	NSString* ParamValue = [[NSString alloc] init];
	
	NSXMLElement *CocoNuitParam;
	NSMutableString* completeParamPath = [[NSMutableString alloc] initWithString:@"./CoconuitConfig/"];
	[completeParamPath appendString:paramPath];
	
	NSArray *nodes = [xmlDoc nodesForXPath:completeParamPath
							 error:&err];
	
	if ([nodes count] > 0 ) {
		CocoNuitParam = [nodes objectAtIndex:0];
		// do something with element
		//NSLog([CocoNuitParam stringValue]);
		ParamValue = [CocoNuitParam stringValue];
		
	}
	if (err != nil) {
		NSLog([err localizedDescription]);
	}
	[completeParamPath release];
	return ParamValue;
}

@end
