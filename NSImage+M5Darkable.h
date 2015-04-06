//
//  NSImage+M5Darkable.h
//  NSImage+M5Darkable
//
//  Created by Mathew Huusko V.
//  Copyright (c) 2015 Mathew Huusko V. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (M5Darkable)

#pragma mark - NSImage+M5Darkable -

#pragma mark Properties

/** Whether image should invert colors when Yosemite dark mode is enabled. Defaults to NO. */
@property (assign, readwrite) BOOL M5_darkable;

#pragma mark -

@end
