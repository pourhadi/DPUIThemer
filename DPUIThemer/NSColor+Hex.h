//
//  NSColor+Hex.h
//  DPUIThemer
//
//  Created by Dan Pourhadi on 5/2/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (Hex)
- (NSString *)hexadecimalValue;
+ (NSColor *)colorFromHexadecimalValue:(NSString *)hex;

@end
