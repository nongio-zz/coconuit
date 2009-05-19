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
 * Above you can see the general structure of the Framework:
 * \image html "./Coconuit.png"
 */ 

#import <Cocoa/Cocoa.h>

int main(int argc, char *argv[])
{
    return NSApplicationMain(argc,  (const char **) argv);
}
