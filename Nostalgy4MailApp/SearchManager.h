//
//  SearchManager.h
//  Nostalgy4MailApp
//
//  Created by Hajo Nils Krabbenhöft on 30.05.09.
//  Copyright 2009 Hajo Nils KrabbenhöftHajo Nils Krabbenhöft. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SearchManager : NSObject {
#if 0
	IBOutlet NSMenu* contextMenu;
#endif
	NSMenuItem* submenuMove;
	NSMenuItem* submenuCopy;
	NSString* lastFolder;
	
	IBOutlet NSMenuItem* menuitemLastMove;
	IBOutlet NSMenuItem* menuitemLastCopy;
}


- (IBAction)moveToFolder: sender;
- (IBAction)copyToFolder: sender;
- (IBAction)moveToLastFolder: sender;
- (IBAction)copyToLastFolder: sender;

- (void)invokeLastFolder:(NSMenu*) submenu;
- (void) setLastFolder: (NSString*) folder;
- (NSString*) lastFolder;

- (NSMenuItem*) dbgSubmenuMove;
- (NSMenuItem*) dbgSubmenuCopy;

@end
