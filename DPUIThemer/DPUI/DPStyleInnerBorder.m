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
	}
	return self;
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
