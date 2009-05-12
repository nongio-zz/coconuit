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
	[self disconnect];
	connected=NO;
}


//The object ‘AppDelegate’ is referenced as the delegate for the NSApplication.when the application has indeed finished launching, 
//then this method on the AppDelegate and only the AppDelegate will be called. Only one object gets this method per application launch.
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
	//TuioMessageDispatcher = [[CNTuioDispatcher alloc] init];
	
	myEventDispatcher = [[CNEventDispatcher alloc] init];
	
	[myEventDispatcher startListeningOnPort:3333];//è lui che alloca il TuioDispatcher e di mette in ascolto
												  //per ricevere i pacchetti Osc
	
	myNotificationCenter = [NSNotificationCenter defaultCenter];
	
	[myNotificationCenter addObserver:myTCView selector:@selector(newEvent:)  name:@"newEvent" object:Nil];
	
	myTCView = [[CNDebugView alloc] initWithFrame:[[mainWindow contentView] bounds]];
	
	[myTCView setAutoresizesSubviews:YES];
	
	[[mainWindow contentView] addSubview:myTCView];
	//[self toggleConnection:nil];
	
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
/**
 * Questa azione è associata al pulsante che avvia e ferma la ricezione di pacchetti Tuio
 */
-(IBAction)toggleConnection:(id)sender{
	if(!connected){
		connected=YES;
		//[TuioMessageDispatcher addObserver:myEventDispatcher];
		
		[myNotificationCenter addObserver:myTCView selector:@selector(newEvent:)  name:@"newEvent" object:Nil];///La Vista si registra come osservatore presso il centro di notifica per gli eventiMultiTouch. Il metodo della vista NewEvent gestisce la notifica
		
		//[self connect:3333];///Si invoca il metodo per avviare la connessione
		//[connectionButton setTitle:@"Stop"];
		}
	else{
		connected=NO;
		//[TuioMessageDispatcher removeObserver:myEventDispatcher forKeyPath:@"activeBlobs"];
		[TuioMessageDispatcher removeObserver:myEventDispatcher];
		[myNotificationCenter removeObserver:myTCView name:@"newEvent" object:Nil];
		[self disconnect];
	//	[connectionButton setTitle:@"Start"];
		}
}

/**
 Questo metodo istanzia la connessione con il server Osc. Avvia un Thread e si mette in ascolto sulla porta passata come argomento
 */
-(void)connect:(int)port{
	BBOSCListener* TempListener = [[BBOSCListener alloc] init];///Si istanzia l'OscListener
	
	[TempListener setDelegate:TuioMessageDispatcher];///Si imposta il delegato per la gestione dei messaggi Osc
	[TempListener startListeningOnPort:port];///Si avvia l'OscListener sulla porta specificata
	
	 // keep a copy for myself
	 self.OscListener = [TempListener retain];
}

/**
 Questo metodo rimuove l'OscListener
 */
- (void)disconnect{
	//[OscListener stopListening];
	//[OscListener release];//rilascia anche il delegato
}




@end
