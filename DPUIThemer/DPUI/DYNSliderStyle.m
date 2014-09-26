//
//  DYNSliderStyle.m
//  DPUIThemer
//
//  Created by Dan Pourhadi on 5/11/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import "DYNSliderStyle.h"
#import "DPStyleManager.h"
@implementation DYNSliderStyle
@synthesize strokeWidth=_strokeWidth;
//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeFloat:self.strokeWidth forKey:@"strokeWidth"];
    [encoder encodeObject:self.strokeColor forKey:@"strokeColor"];
    [encoder encodeObject:self.outerShadow forKey:@"outerShadow"];
    [encoder encodeFloat:self.trackHeight forKey:@"trackHeight"];
    [encoder encodeFloat:self.thumbHeight forKey:@"thumbHeight"];
    [encoder encodeObject:self.minimumTrackBackground forKey:@"minimumTrackBackground"];
    [encoder encodeObject:self.minimumTrackInnerShadow forKey:@"minimumTrackInnerShadow"];
    [encoder encodeObject:self.maximumTrackBackground forKey:@"maximumTrackBackground"];
    [encoder encodeObject:self.maximumTrackInnerShadow forKey:@"maximumTrackInnerShadow"];
    [encoder encodeObject:self.thumbStyleName forKey:@"thumbStyleName"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.strokeWidth = [decoder decodeFloatForKey:@"strokeWidth"];
        self.strokeColor = [decoder decodeObjectForKey:@"strokeColor"];
        self.outerShadow = [decoder decodeObjectForKey:@"outerShadow"];
        self.trackHeight = [decoder decodeFloatForKey:@"trackHeight"];
        self.thumbHeight = [decoder decodeFloatForKey:@"thumbHeight"];
        self.minimumTrackBackground = [decoder decodeObjectForKey:@"minimumTrackBackground"];
        self.minimumTrackInnerShadow = [decoder decodeObjectForKey:@"minimumTrackInnerShadow"];
        self.maximumTrackBackground = [decoder decodeObjectForKey:@"maximumTrackBackground"];
        self.maximumTrackInnerShadow = [decoder decodeObjectForKey:@"maximumTrackInnerShadow"];
        self.thumbStyleName = [decoder decodeObjectForKey:@"thumbStyleName"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    id theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
	
    [theCopy setStrokeWidth:self.strokeWidth];
    [theCopy setStrokeColor:[self.strokeColor copy]];
    [theCopy setOuterShadow:[self.outerShadow copy]];
    [theCopy setTrackHeight:self.trackHeight];
    [theCopy setThumbHeight:self.thumbHeight];
    [theCopy setMinimumTrackBackground:[self.minimumTrackBackground copy]];
    [theCopy setMinimumTrackInnerShadow:[self.minimumTrackInnerShadow copy]];
    [theCopy setMaximumTrackBackground:[self.maximumTrackBackground copy]];
    [theCopy setMaximumTrackInnerShadow:[self.maximumTrackInnerShadow copy]];
    [theCopy setThumbStyleName:[self.thumbStyleName copy]];
	
    return theCopy;
}
- (id)jsonValue
{
	NSMutableDictionary *dictionary = [NSMutableDictionary new];
	
	[dictionary setObject:self.name forKey:@"styleName"];
	[dictionary setObject:@(self.strokeWidth) forKey:@"strokeWidth"];
	[dictionary setObject:self.strokeColor.jsonValue forKey:@"strokeColor"];
	[dictionary setObject:self.outerShadow.jsonValue forKey:@"outerShadow"];
	[dictionary setObject:@(self.trackHeight) forKey:@"trackHeight"];
	[dictionary setObject:@(self.thumbHeight) forKey:@"thumbHeight"];
	[dictionary setObject:self.minimumTrackInnerShadow.jsonValue forKey:@"minimumTrackInnerShadow"];
	[dictionary setObject:self.maximumTrackInnerShadow.jsonValue forKey:@"maximumTrackInnerShadow"];
	
	NSMutableArray *tmp = [NSMutableArray new];
	
	for (DPStyleColor *color in self.maxTrackBgColors) {
		[tmp addObject:color.jsonValue];
	}
	
	[dictionary setObject:tmp forKey:@"maxTrackBgColors"];
	
	tmp = [NSMutableArray new];
	
	for (DPStyleColor *color in self.minTrackBgColors) {
		[tmp addObject:color.jsonValue];
	}
	
	[dictionary setObject:tmp forKey:@"minTrackBgColors"];
	
	if (self.thumbStyleName) {
		[dictionary setObject:self.thumbStyleName forKey:@"thumbStyleName"];
	}
	
	return dictionary;
	
}

- (id)initWithDictionary:(NSDictionary*)dictionary
{
	self = [super init];
	if (self) {
		self.name = [dictionary objectForKey:@"styleName"];
		self.strokeWidth = [[dictionary objectForKey:@"strokeWidth"] floatValue];
		self.strokeColor = [[DPStyleColor alloc] initWithDictionary:[dictionary objectForKey:@"strokeColor"]];
		self.outerShadow = [[DPStyleShadow alloc] initWithDictionary:[dictionary objectForKey:@"outerShadow"]];
		self.trackHeight = [[dictionary objectForKey:@"trackHeight"] floatValue];
		self.thumbHeight = [[dictionary objectForKey:@"thumbHeight"] floatValue];
		self.minimumTrackInnerShadow = [[DPStyleShadow alloc] initWithDictionary:[dictionary objectForKey:@"minimumTrackInnerShadow"]];
		self.maximumTrackInnerShadow = [[DPStyleShadow alloc] initWithDictionary:[dictionary objectForKey:@"maximumTrackInnerShadow"]];
		if ([dictionary objectForKey:@"thumbStyleName"])
		self.thumbStyleName = [dictionary objectForKey:@"thumbStyleName"];
		NSMutableArray *tmp;
		
		tmp = [NSMutableArray new];
		for (NSDictionary *color in [dictionary objectForKey:@"maxTrackBgColors"]) {
			[tmp addObject:[[DPStyleColor alloc] initWithDictionary:color]];
		}
		
		self.maximumTrackBackground = [[DPStyleBackground alloc] init];
		self.maximumTrackBackground.colors = tmp;
		self.maxTrackBgColors = tmp;
				
		tmp = [NSMutableArray new];
		for (NSDictionary *color in [dictionary objectForKey:@"minTrackBgColors"]) {
			[tmp addObject:[[DPStyleColor alloc] initWithDictionary:color]];
		}
		
		self.minimumTrackBackground = [[DPStyleBackground alloc] init];
		self.minimumTrackBackground.colors = tmp;
		self.minTrackBgColors = tmp;
		
	}
	
	return self;
}

- (id)init
{
	self = [super init];
	if (self) {
		
		self.name = [DYNSliderStyle newSliderStyleName];
		self.minimumTrackBackground = [[DPStyleBackground alloc] init];
		self.maximumTrackBackground = [[DPStyleBackground alloc] init];
		self.minimumTrackInnerShadow = [[DPStyleShadow alloc] init];
		self.maximumTrackInnerShadow = [[DPStyleShadow alloc] init];
		self.outerShadow = [[DPStyleShadow alloc] init];
		self.trackHeight = 11;
		self.thumbHeight = 1.5;
		self.strokeColor = [[DPStyleColor alloc] init];
		self.minTrackBgColors = [NSMutableArray new];
		self.maxTrackBgColors = [NSMutableArray new];
	}
	return self;
}

+ (NSString*)newSliderStyleName
{
	NSInteger x = 1;
	BOOL found = NO;
	NSString *name;
	
	while (!found) {
		
		name = [NSString stringWithFormat:@"Slider%ld", (long)x];
		if (![[[DPStyleManager sharedInstance] sliderStyleNames] containsObject:name]) {
			found = YES;
		} else {
			x += 1;
		}
		
	}
	
	return name;
}

//- (void)setStrokeWidth:(CGFloat)strokeWidth
//{
//	[self willChangeValueForKey:@"strokeWidth"];
//	_strokeWidth = 2*strokeWidth;
//	[self didChangeValueForKey:@"strokeWidth"];
//}
//
//- (CGFloat)strokeWidth
//{
//	return _strokeWidth/2;
//}

@end
