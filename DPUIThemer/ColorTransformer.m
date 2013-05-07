//
//  ColorTransformer.m
//  DPUIThemer
//
//  Created by Dan Pourhadi on 5/1/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import "ColorTransformer.h"
#import "DPStyleBackground.h"
#import "DPStyleManager.h"
#import "DPUIDocument.h"
@implementation VariableTransformer



@end
@implementation ColorTransformer
+ (Class)transformedValueClass { return [NSColor class]; }
+ (BOOL)allowsReverseTransformation { return NO; }
- (id)transformedValue:(id)value {
    return (value == nil) ? nil : [(DPStyleColor*)value color];
}

- (id)reverseTransformedValue:(id)value
{
	return [ColorTransformer stringFromColor:value];
}

+ (NSString*)stringFromColor:(NSColor*)color
{
	CIColor *ciColor = [CIColor colorWithCGColor:color.CGColor];
	return [ciColor stringRepresentation];
	return [color hexadecimalValue];
	
	
	CGFloat r, g, b, a;
	r = [color redComponent];
	g = [color greenComponent];
	b = [color blueComponent];
	a = [color alphaComponent];
	
	return [NSString stringWithFormat:@"%f-%f-%f-%f", r, g, b, a];
}

+ (NSColor*)colorFromString:(NSString*)string
{
    if (![string hasPrefix:@"#"]) {
     
        NSArray *colors = [[DPStyleManager sharedInstance] colorVariables];
        NSPredicate *pred= [NSPredicate predicateWithFormat:@"colorName == %@", string];
        NSArray *filters = [colors filteredArrayUsingPredicate:pred];
        if (filters && filters.count > 0) {
            return filters[0];
        }
    }

	CIColor *ciColor = [CIColor colorWithString:string];
	return [NSColor colorWithCIColor:ciColor];
	return [NSColor colorFromHexadecimalValue:string];
	
	NSArray *components = [string componentsSeparatedByString:@"-"];
	
	CGFloat r, g, b, a;
	r = [components[0] floatValue];
	g = [components[1] floatValue];
	b = [components[2] floatValue];
	a = [components[3] floatValue];
	
	NSColor *color = [NSColor colorWithSRGBRed:r green:g blue:b alpha:a];
	return color;
	
}

@end
