//
//  DPUITextStyle.m
//  DPUIThemer
//
//  Created by Dan Pourhadi on 5/4/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import "DPUITextStyle.h"
#import "DPStyleManager.h"

@implementation TextStyleTransformer

+ (Class)transformedValueClass { return [NSString class]; }
+ (BOOL)allowsReverseTransformation { return NO; }
- (id)transformedValue:(id)value {
    return (value == nil) ? nil : [(DPUITextStyle*)value styleName];
}

- (id)reverseTransformedValue:(id)value
{
	return [[DPStyleManager sharedInstance] textStyleForName:value];
}

@end



@implementation DPUITextStyle
@synthesize alignment=_alignment;

- (id)init
{
	self = [super init];
	if (self) {
		self.styleName = [DPUITextStyle newStyleVariableName];
		self.font = [NSFont fontWithName:@"Helvetica" size:12];
		self.textColor = [[DPStyleColor alloc] init];
		self.shadowColor = [[DPStyleColor alloc] init];
		self.shadowOffset = CGSizeZero;
	}
	return self;
}

- (id)jsonValue
{
	NSMutableDictionary *dict = [NSMutableDictionary new];
	
	[dict setObject:@(self.shadowOffset.width) forKey:@"shadowXOffset"];
	[dict setObject:@(self.shadowOffset.height) forKey:@"shadowYOffset"];
	[dict setObject:self.styleName forKey:@"styleName"];
	[dict setObject:self.textColor.jsonValue forKey:@"textColor"];
	[dict setObject:self.shadowColor.jsonValue forKey:@"shadowColor"];
	[dict setObject:self.font.fontName forKey:@"fontName"];
	[dict setObject:@(self.font.pointSize) forKey:@"fontSize"];
	[dict setObject:@(_alignment) forKey:@"alignment"];
	return dict;
}

- (id)initWithDictionary:(NSDictionary*)dict
{
	self = [super init];
	if (self) {
		
		self.styleName = [dict objectForKey:@"styleName"];
		self.font = [NSFont fontWithName:[dict objectForKey:@"fontName"] size:[[dict objectForKey:@"fontSize"] floatValue]];
		self.textColor = [[DPStyleColor alloc] initWithDictionary:[dict objectForKey:@"textColor"]];
		self.shadowColor = [[DPStyleColor alloc] initWithDictionary:[dict objectForKey:@"shadowColor"]];
		self.shadowOffset = CGSizeMake([[dict objectForKey:@"shadowXoffset"] floatValue], [[dict objectForKey:@"shadowYOffset"] floatValue]);
		_alignment = [[dict objectForKey:@"alignment"] intValue];
	}
	
	return self;
}

+ (NSString*)newStyleVariableName
{
	NSInteger x = 1;
	BOOL found = NO;
	NSString *name;
	
	while (!found) {
		
		name = [NSString stringWithFormat:@"TextStyle%ld", (long)x];
		if (![[[DPStyleManager sharedInstance] textStyleNames] containsObject:name]) {
			found = YES;
		} else {
			x += 1;
		}
		
	}
	
	return name;
}

- (void)setAlignment:(NSTextAlignment)alignment
{
	if (alignment == 0) {
		_alignment = NSLeftTextAlignment;
	} else if (alignment == 1) {
		_alignment = NSCenterTextAlignment;
	} else if (alignment == 2) {
		_alignment = NSRightTextAlignment;
	}
}

- (NSTextAlignment)alignment
{
	if (_alignment == NSLeftTextAlignment) {
		return 0;
	} else if (_alignment == NSCenterTextAlignment) {
		return 1;
	} else if (_alignment == NSRightTextAlignment) {
		return 2;
	}
	
	return 0;
}

- (CGFloat)xShadowOffset
{
	return self.shadowOffset.width;
}

- (void)setXShadowOffset:(CGFloat)xShadowOffset
{
	//xShadowOffset = (xShadowOffset > 0 ? -xShadowOffset : fabsf(xShadowOffset));
	self.shadowOffset = CGSizeMake(xShadowOffset, self.shadowOffset.height);
}

- (CGFloat)yShadowOffset
{
	return (self.shadowOffset.height > 0 ? -self.shadowOffset.height : fabsf(self.shadowOffset.height));
}

- (void)setYShadowOffset:(CGFloat)yShadowOffset
{
	yShadowOffset = (yShadowOffset > 0 ? -yShadowOffset : fabsf(yShadowOffset));
	self.shadowOffset = CGSizeMake(self.shadowOffset.width, yShadowOffset);
}

- (NSInteger)fontSize
{
	return (int)self.font.pointSize;
}

- (void)setFontSize:(NSInteger)fontSize
{
	self.font = [NSFont fontWithName:self.font.fontName size:fontSize];
}

- (NSString*)fontString
{
	return [NSString stringWithFormat:@"%@ %d", self.font.fontName, (int)self.font.pointSize];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
	NSSet *original = [super keyPathsForValuesAffectingValueForKey:key];
	NSMutableSet *mutable = [original mutableCopy];
	if ([key isEqualToString:@"xShadowOffset"] || [key isEqualToString:@"yShadowOffset"]) {
		[mutable addObject:@"shadowOffset"];
	}
	
	if ([key isEqualToString:@"fontString"] || [key isEqualToString:@"fontSize"]) {
		[mutable addObject:@"font"];
	}
	
	if ([key isEqualToString:@"font"]) {
		[mutable addObject:@"fontSize"];
	}
	
	return mutable;
}

@end
