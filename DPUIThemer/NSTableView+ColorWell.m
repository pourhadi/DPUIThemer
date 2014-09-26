//
//  NSTableView+ColorWell.m
//  DPUIThemer
//
//  Created by Dan Pourhadi on 5/23/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import "NSTableView+ColorWell.h"
#import <objc/runtime.h>
@implementation NSTableView (ColorWell)

- (void)setAssociatedColorWell:(NSColorWell *)associatedColorWell
{
	objc_setAssociatedObject(self, "associatedColorWell", associatedColorWell, OBJC_ASSOCIATION_ASSIGN);
}

- (NSColorWell*)associatedColorWell
{
	return  objc_getAssociatedObject(self, "associatedColorWell");
}


@end
