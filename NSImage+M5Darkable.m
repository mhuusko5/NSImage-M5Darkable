//
//  NSImage+M5Darkable.m
//  NSImage+M5Darkable
//
//  Created by Mathew Huusko V.
//  Copyright (c) 2015 Mathew Huusko V. All rights reserved.
//

#import "NSImage+M5Darkable.h"

#import <objc/runtime.h>
#import <Quartz/Quartz.h>

@implementation NSImage (M5Darkable)

#pragma mark - NSImage+M5Darkable -

#pragma mark Methods

- (void)setM5_darkable:(BOOL)darkable {
    objc_setAssociatedObject(self, @selector(M5_darkable), @(darkable), OBJC_ASSOCIATION_RETAIN);
}

#pragma mark Properties

- (BOOL)M5_darkable {
    return [objc_getAssociatedObject(self, @selector(M5_darkable)) boolValue];
}

#pragma mark -

#pragma mark - NSImage+M5Darkable (Private) -

#pragma mark Methods

static BOOL darkModeState = NO;

+ (void)RM_updateDarkModeState {
    NSDictionary *globalPersistentDomain = [[NSUserDefaults standardUserDefaults] persistentDomainForName:NSGlobalDomain];
    @try {
        NSString *interfaceStyle = [globalPersistentDomain valueForKey:@"AppleInterfaceStyle"];
        darkModeState = [interfaceStyle isEqualToString:@"Dark"];
    } @catch (NSException *exception) {
        darkModeState = NO;
    }
}

#pragma mark Properties

- (NSImage *)M5_invertedSelf {
	NSImage *invertedSelf = objc_getAssociatedObject(self, @selector(M5_invertedSelf));
    
    if (!invertedSelf) {
        CIImage *normalCiImage = [[CIImage alloc] initWithData:[self TIFFRepresentation]];
        
        CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert"];
        [filter setDefaults];
        [filter setValue:normalCiImage forKey:@"inputImage"];
        
        CIImage *invertedCiImage = [filter valueForKey:@"outputImage"];
        [invertedCiImage drawAtPoint:NSZeroPoint fromRect:NSRectFromCGRect([invertedCiImage extent]) operation:NSCompositeSourceOver fraction:1.0];
        
        NSCIImageRep *rep = [NSCIImageRep imageRepWithCIImage:invertedCiImage];
        
        invertedSelf = [[NSImage alloc] initWithSize:rep.size];
        [invertedSelf addRepresentation:rep];
        
        objc_setAssociatedObject(self, @selector(M5_invertedSelf), invertedSelf, OBJC_ASSOCIATION_RETAIN);
    }

	return invertedSelf;
}

#pragma mark -

#pragma mark - NSObject -

#pragma mark Methods

+ (void)load {
    [[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"AppleInterfaceThemeChangedNotification" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        [self RM_updateDarkModeState];
    }];
    
    [self RM_updateDarkModeState];

    @synchronized(self) {
        SEL selector = @selector(drawInRect:fromRect:operation:fraction:respectFlipped:hints:);
        
        __block IMP oldImp = nil;
        IMP newImp = imp_implementationWithBlock(^(id self, NSRect dstSpacePortionRect, NSRect srcSpacePortionRect, NSCompositingOperation op, CGFloat requestedAlpha, BOOL respectContextIsFlipped, NSDictionary* hints) {
            if (oldImp) {
                if (!darkModeState || !((NSImage *)self).M5_darkable) {
                    return ((void(*)(id, SEL, NSRect, NSRect, NSCompositingOperation, CGFloat, BOOL, NSDictionary*))oldImp)(self, selector, dstSpacePortionRect, srcSpacePortionRect, op, requestedAlpha, respectContextIsFlipped, hints);
                }
                
                return ((void(*)(id, SEL, NSRect, NSRect, NSCompositingOperation, CGFloat, BOOL, NSDictionary*))oldImp)(((NSImage *)self).M5_invertedSelf, selector, dstSpacePortionRect, srcSpacePortionRect, op, requestedAlpha, respectContextIsFlipped, hints);
            }
        });
        
        Method method = class_getInstanceMethod(self, selector);
        if (method) {
            oldImp = method_setImplementation(method, newImp);
        } else {
            const char *methodTypes = [NSString stringWithFormat:@"%s%s%s%s%s%s%s%s%s", @encode(void), @encode(id), @encode(SEL), @encode(NSRect), @encode(NSRect), @encode(NSCompositingOperation), @encode(CGFloat), @encode(BOOL), @encode(NSDictionary*)].UTF8String;
            
            class_addMethod(self, selector, newImp, methodTypes);
        }
    }
}

#pragma mark -

@end
