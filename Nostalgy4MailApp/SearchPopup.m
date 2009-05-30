//
//  SearchPopup.m
//  Nostalgy4MailApp
//
//  Created by Hajo Nils Krabbenhöft on 30.05.09.
//  Copyright 2009 Hajo Nils Krabbenhöft. All rights reserved.
//

#import "SearchPopup.h"


@implementation SearchPopup

+ (id)popupWithSubmenu:(NSMenu *)submenu andParent:(SearchManager*) parent{
	SearchPopup* new = [[SearchPopup alloc] init];
	new->submenu = submenu;
	new->parent = parent;
	new->currentResults = [NSMutableArray array];
	[new->currentResults retain]; //FIXME: why ???
	
	[NSBundle loadNibNamed: @"SearchPopup" owner: new ];
	
	NSLog(@"SearchPopup: popupWithSubmenu: %@", submenu);
	return new;
}

- (void)showWithSender: sender andTitle: (NSString *)title {
	if( [submenu numberOfItems] == 0 )  [[submenu delegate] menuNeedsUpdate: submenu ];
	
	if( [parent lastFolder] != nil ) {
		[searchField setStringValue: [parent lastFolder]];
		[self doSearch: sender];
		[searchField selectText: sender];
	}
	[searchWindow setTitle:title];
	[searchWindow makeKeyAndOrderFront: sender];
}

- (IBAction)doSearch: sender
{
	NSString *searchString = [searchField stringValue];

	while( [currentResults count] > 0 ) [currentResults removeLastObject];
	
    NSArray     *items = [submenu itemArray];
    for(int iI = 0; iI < [items count]; iI++){
        NSMenuItem*  menuItem = [items objectAtIndex:iI];
		if(! [menuItem isEnabled] ) continue;
		
		NSString* title = [menuItem title];
		NSRange aRange = [title rangeOfString: searchString options: NSCaseInsensitiveSearch];
		if (aRange.location == NSNotFound) continue;
		[currentResults addObject: menuItem];
    }   
	
	if( [currentResults count] > 0 )
		selectedResult = [currentResults objectAtIndex:0];
	else
		selectedResult = nil;
	
	[resultViewer reloadData];
}


- (BOOL)control:(NSControl*)control textView:(NSTextView*)textView doCommandBySelector:(SEL)commandSelector {
    BOOL result = NO;
    if (commandSelector == @selector(insertNewline:)) {
		if(selectedResult != nil) {
			[parent setLastFolder: [selectedResult title]];
			[submenu performActionForItemAtIndex: [submenu indexOfItem: selectedResult] ];
		}
		[searchWindow orderOut:nil];
		result = YES;
    }
	else if(commandSelector == @selector(cancelOperation:)) {
		[searchWindow orderOut:nil];
		result = YES;
	}
	/* else if(commandSelector == @selector(moveLeft:)) {
	 // left arrow pressed
	 result = YES;
	 }
	 else if(commandSelector == @selector(moveRight:)) {
	 // rigth arrow pressed
	 result = YES;
	 }*/
	 else if(commandSelector == @selector(moveUp:)) {
		 if(selectedResult != nil) {
			 int index = [currentResults indexOfObject: selectedResult]-1;
			 if(index < 0) index = 0;
			 selectedResult = [currentResults objectAtIndex:index];
			 [resultViewer selectRow:index byExtendingSelection:FALSE];
			 [resultViewer scrollRowToVisible:index];
		 }
		 result = YES;
	 }
	 else if(commandSelector == @selector(moveDown:)) {
		 if(selectedResult != nil) {
			 int index = [currentResults indexOfObject: selectedResult]+1;
			 if(index >= [currentResults count]) index = [currentResults count] - 1;
			 selectedResult = [currentResults objectAtIndex:index];
			 [resultViewer selectRow:index byExtendingSelection:FALSE];
			 [resultViewer scrollRowToVisible:index];
		 }
		 result = YES;
	 }
    return result;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex
{	
    id theValue;
    NSParameterAssert(rowIndex >= 0 && rowIndex < [currentResults count]);
	
    NSMenuItem* row = [currentResults objectAtIndex:rowIndex];
	if( [[aTableColumn identifier] isEqualToString: @"image"] ) return [row image];
	else if( [[aTableColumn identifier] isEqualToString: @"title"] ) return [row title];
    return theValue;
	
}

- (int)numberOfRowsInTableView:(NSTableView *)aTableView

{
	
    return [currentResults count];
	
}

- (IBAction)changeSelection: sender {
	int i = [resultViewer selectedRow];
	if(i >= 0 && i < [currentResults count])
		selectedResult = [currentResults objectAtIndex: i];
	else 
		selectedResult = nil;
}


@end
