//
//  CoconuitConfig.h
//  CocoaXml
//
//  Created by Nicola Martorana on 17/05/09.
//  Copyright 2009 Unifi. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CoconuitConfig : NSObject {
	NSString* ConfigFile;
	NSXMLDocument* xmlDoc;
	NSError* err;
	NSURL* ConfigFileUrl;
}

-(NSString*) getConfigParamValue:(NSString*)paramPath;

@end
