//
//  AppDelegate.m
//  CustomMapOSX
//
//  Created by Carlo Vigiani on 21/Jan/14.
//  Copyright (c) 2014 viggiosoft. All rights reserved.
//

#import "AppDelegate.h"
#import "MapWindowController.h"



@implementation AppDelegate

MapWindowController *windowController; // used to avoid deallocation by ARC

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    windowController = [[MapWindowController alloc] initWithWindowNibName:@"MapWindow"];
    [windowController showWindow:nil];
    [windowController.window makeKeyAndOrderFront:nil];
}

@end
