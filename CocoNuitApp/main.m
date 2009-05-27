//
//  main.m
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

/*! \mainpage  
 * 
 * \section intro_sec Coconuit Framework Project
 * 
 * \par
 * This project aims to realize a lightweight, flexible and extensible Cocoa Framework to create Multitouch and more in general Tangible apps.
 * \n
 * We want to implement the basic gestures recognition and offer the possibility for each user to define and setup its owns gestures easily. 
 * \n
 * Because of its nature we hope this framework will work good with Quartz and Core Animation to realize fun and useful applications.
 * \par
 * Below the general structure of the Framework:
 * \image html "./Coconuit.png"
 *
 * As you can see above the framework structure is divided in four main parts:
 * - TuioEngine
 * - EventManagement
 * - View
 * - GestureRecognition
 * \n
 *
 * Thus can be resumed the framework behavior:\n
 * -# Osc packets transporting Tuio messages are caught and dispatched by a CNTuioDispatcher instance. It is important to notice that by now only Tuio
 *    messages sent from a visual tracking engine like Core Vision or Touchè are managed. But it is easy to imagine other different type of dispatcher 
      able to manage other type of tangible information. 
 * -# A CNEventDispatcher instance is registered as CNTuioDispatcher Observer
 * -# For each tuio frame ending - signaled by a Tuio fseq message - the CNTuioDispatcher instance notifies the observers obout the scene state
 * -# The CNEventDispatcher instance receives raw data about the scene state and with these it creates a CNEvent.
 *    A CNEvent is a set of CNStroke. A CNStroke can be seen like a generic active element in the scene. Because by now it is implemented only the Tuio Messages Management
 *    for Multitouch applications, it gets only instance of CNTouch. But it is easy to think other possible subclasses of CNStroke describing other tangible informations.
 * -# For every new notification received by the low level dispatcher, the CNEventDispatcher instance posts a new CNNewEvent notification to the system default Cocoa NSNotificationCenter.
 *    This notification contains the current CNEvent
 * -# Each view listening to the system default NSNotificationCenter for CNNewEvent receives a copy of the current CNEvent. In particular it has been definined a special kind of view called CNView
 * -# The CNView registers itself automatically as listener for CNNewEvent notifications. A CNView instance collects one or more CNLayers. When it receives a new CNEvent instance it
 *    assigns each stroke in the CNEvent to the right layer. The strokes dispatching is made according with the stroke position in the scene and the corresponding area occupied by the layer in the interface.
 *	  It is supposed that the stroke belongs to the first corresponding layer in the foreground.
 * -# When the strokes dispatching ends the view orders to each layer to recognize the own gesture. This implies the layer redrawing linked to the right gesture.
 * -# By the framework is defined a special kind of layer: the CNLayer. Each CNLayer instance is joined to one or more CNGesture subclass instances. Each CNGesture subclass implements the gesture recognition 
 *    for a particular gesture.
 *	  The view has to get a new instance of the needed gesture from the GestureFactory and then it has to join the gesture with the right layer.
 * -# The layer orders to the own joined gestures to recognize the gesture represented by the strokes state
 * -# For each CNGesture instance if it recognizes the gesture than it redraws the joined layer passing the needed gesture params useful for the animation
 */ 

#import <Cocoa/Cocoa.h>

int main(int argc, char *argv[])
{
    return NSApplicationMain(argc,  (const char **) argv);
}
