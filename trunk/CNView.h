//
//  CNView.h
//  TuioClient
//
//  Created by Nicola Martorana on 25/02/09.
//  Copyright 2009 Unifi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/CoreAnimation.h>
#import <Quartz/Quartz.h>
#import "CNCursorLayer.h"
#import "CNGesture.h"
#import "CNLayer.h"
#import "CNTuioDispatcher.h"
#import "CNEvent.h"
#import <QTKit/QTMovieLayer.h>
#import <QTKit/QTMovie.h>
#import "CNTap.h"
#import "CNMove.h"
#import "CNDebug.h"
#import "CNDebugLayer.h"

@interface CNView : NSView {
	CNGesture* GestureRecognizer;
	NSMutableArray* activeLayers;
	CALayer *rootLayer;
	CALayer *viewLayer;
	CNDebugLayer *dbgLayer;	
}

@property (retain) NSMutableArray* activeLayers;
@property (retain) CALayer* rootLayer, *viewLayer;
@property (retain) CNDebugLayer* dbgLayer;

- (void)setupLayers;
- (void)newEvent:(NSNotification *)notification;

-(void)addSublayer:(CALayer*)newlayer; //aggiunge un livello a viewLayer
-(void)addActiveSubLayer:(CALayer*)newlayer; //controlla se il livello è un CNLayer e nel caso lo aggiunge alla propria lista di layer attivi
@end
