//
//  CNAppController.m
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
//  Copyright 2009 Nicola Martorana <martorana.nicola@gmail.com>.
//

#import "CNAppController.h"
#import "CNTuioDispatcher.h"

@implementation CNAppController

@synthesize OscListener;

-(void)dealloc{
	//[OscListener release];
	//[TuioMessageDispatcher release];
	
	[super dealloc];
}

//After all outlets and actions are connected, the nib loader sends awakeFromNib to every object in the nib.
-(void) awakeFromNib{
	[NSApp setDelegate:self];
	connected=NO;
}


//The object ‘AppDelegate’ is referenced as the delegate for the NSApplication.when the application has indeed finished launching, 
//then this method on the AppDelegate and only the AppDelegate will be called. Only one object gets this method per application launch.
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
	
	myEventDispatcher = [[CNEventDispatcher alloc] init];
	
	[myEventDispatcher startListeningOnPort:3333];//è lui che alloca il TuioDispatcher e di mette in ascolto
												  //per ricevere i pacchetti Osc
	
	myNotificationCenter = [NSNotificationCenter defaultCenter];
	
	myTCView = [[CNDebugView alloc] initWithFrame:[[mainWindow contentView] bounds]];
	
	[myNotificationCenter addObserver:myTCView selector:@selector(newEvent:)  name:@"newCNEvent" object:Nil];
	
	[myTCView setAutoresizesSubviews:YES];
	
	[[mainWindow contentView] addSubview:myTCView];
	
}

-(IBAction)fullscreen:(id)sender
{
	NSDictionary *opts = [NSDictionary dictionaryWithObjectsAndKeys:
						  [NSNumber numberWithBool:NO], NSFullScreenModeAllScreens, nil];
    [self fadeOut];
	if (![myTCView isInFullScreenMode])
		[myTCView enterFullScreenMode:[[myTCView window] screen] withOptions:opts];
	else
		[myTCView exitFullScreenModeWithOptions:opts];
	[self fadeIn];
}

- (void)fadeOut
{ 
    CGAcquireDisplayFadeReservation(5, &tok);
    CGDisplayFade(tok, 0.5, kCGDisplayBlendNormal, kCGDisplayBlendSolidColor, 0, 0, 0, TRUE);
}

- (void)fadeIn
{
    CGDisplayFade(tok, 0.5, kCGDisplayBlendSolidColor, kCGDisplayBlendNormal, 0, 0, 0, TRUE);
    CGReleaseDisplayFadeReservation(tok);
}



@end
