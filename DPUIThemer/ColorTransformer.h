//
//  ColorTransformer.h
//  DPUIThemer
//
//  Created by Dan Pourhadi on 5/1/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSColor+Hex.h"


@interface ParameterTransformer : NSValueTransformer

@end

@interface VariableTransformer : NSValueTransformer

@end

@interface ColorTransformer : NSValueTransformer
+ (NSString*)stringFromColor:(NSColor*)color;
+ (NSColor*)colorFromString:(NSString*)string;
@end
