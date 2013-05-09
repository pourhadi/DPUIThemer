//
//  DPStyleInnerBorder.m
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import "DPStyleInnerBorder.h"

@implementation DPStyleInnerBorder

- (id)copyWithZone:(NSZone *)zone
{
	DPStyleInnerBorder* copy = [[[self class] alloc] init];
	if (copy) {
		copy.color = [self.color copyWithZone:zone];
		copy.blendMode = self.blendMode;
		copy.height = self.height;
	}
	return copy;
}

- (id)init
{
	self = [super init];
	if (self) {
		self.color = [[DPStyleColor alloc] init];
		self.height = 1;
		self.blendMode = kCGBlendModeNormal;
	}
	return self;
}

- (void)setBlendMode:(CGBlendMode)blendMode
{
	[self willChangeValueForKey:@"blendMode"];
	_blendMode = blendMode;
	[self didChangeValueForKey:@"blendMode"];

	self.blendModeString = [self blendModes][blendMode];
}

- (void)setBlendModeString:(NSString *)blendModeString
{
	[self willChangeValueForKey:@"blendModeString"];
	_blendModeString = blendModeString;
	[self didChangeValueForKey:@"blendModeString"];
	
	_blendMode = (CGBlendMode)[[self blendModes] indexOfObject:blendModeString];
}

- (NSArray*)blendModes
{
	return @[@"kCGBlendModeNormal",
		  @"kCGBlendModeMultiply",
		  @"kCGBlendModeScreen",
		  @"kCGBlendModeOverlay",
		  @"kCGBlendModeDarken",
		  @"kCGBlendModeLighten",
		  @"kCGBlendModeColorDodge",
		  @"kCGBlendModeColorBurn",
		  @"kCGBlendModeSoftLight",
		  @"kCGBlendModeHardLight",
		  @"kCGBlendModeDifference",
		  @"kCGBlendModeExclusion",
		  @"kCGBlendModeHue",
		  @"kCGBlendModeSaturation",
		  @"kCGBlendModeColor",
		  @"kCGBlendModeLuminosity",
		  @"kCGBlendModeClear",
		  @"kCGBlendModeCopy",
		  @"kCGBlendModeSourceIn",
		  @"kCGBlendModeSourceOut",
		  @"kCGBlendModeSourceAtop",
		  @"kCGBlendModeDestinationOver",
		  @"kCGBlendModeDestinationIn",
		  @"kCGBlendModeDestinationOut",
		  @"kCGBlendModeDestinationAtop",
		  @"kCGBlendModeXOR",
		  @"kCGBlendModePlusDarker",
		  @"kCGBlendModePlusLighter"];
}

- (id)jsonValue
{
	NSMutableDictionary *dict = [NSMutableDictionary new];
	[dict setObject:@(self.blendMode) forKey:@"blendMode"];
	[dict setObject:@(self.height) forKey:@"height"];
	[dict setObject:self.color.jsonValue forKey:@"color"];
	
	return dict;
}

- (id)initWithDictionary:(NSDictionary*)dictionary
{
	self = [super init];
	if (self) {
		self.blendMode = [[dictionary objectForKey:@"blendMode"] intValue];
		self.height = [[dictionary objectForKey:@"height"] floatValue];
		self.color = [[DPStyleColor alloc] initWithDictionary:[dictionary objectForKey:@"color"]];
	}
	return self;
}

@end
