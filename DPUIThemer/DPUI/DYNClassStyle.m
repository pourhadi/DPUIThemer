//
//  DYNClassStyle.m
//  DPUIThemer
//
//  Created by Dan Pourhadi on 6/2/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import "DYNClassStyle.h"

#import "DPUICustomSetting.h"

@implementation DYNClassStyle

static NSString *kCLASS_NAME_KEY = @"className";
static NSString *kATTRIBUTES_KEY = @"attributes";
static NSString *kAUTO_APPLY_KEY = @"autoApply";



//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.className forKey:kCLASS_NAME_KEY];
    [encoder encodeObject:self.attributes forKey:kATTRIBUTES_KEY];
    [encoder encodeObject:self.autoApply forKey:kAUTO_APPLY_KEY];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.className = [decoder decodeObjectForKey:kCLASS_NAME_KEY];
        self.attributes = [decoder decodeObjectForKey:kATTRIBUTES_KEY];
        self.autoApply = [decoder decodeObjectForKey:kAUTO_APPLY_KEY];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    id theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
	
    [theCopy setClassName:[self.className copy]];
    [theCopy setAttributes:[self.attributes copy]];
    [theCopy setAutoApply:[self.autoApply copy]];
	
    return theCopy;
}

- (id)init
{
	self = [super init];
	if (self) {
		self.className = @"ClassStyle";
		self.attributes = [NSArray array];
		self.autoApply = @(YES);
	}
	
	return self;
}

- (id)initWithDictionary:(NSDictionary*)dictionary
{
	self = [self init];
	if (self) {
		
		
		self.className = [dictionary objectForKey:@"className"];
		NSMutableArray *tmp = [NSMutableArray new];
	
		for (NSDictionary *attribute in [dictionary objectForKey:@"attributes"]) {
			[tmp addObject:[[DPUICustomSetting alloc] initWithDictionary:attribute]];
		}
		
		self.attributes = tmp;
		
		self.autoApply = [dictionary objectForKey:@"autoApply"];
		
	}
	return self;
}

- (id)jsonValue
{
	NSMutableDictionary *dict = [NSMutableDictionary new];
	
	[dict setObject:self.className forKey:@"className"];
	
	NSMutableArray *tmp = [NSMutableArray new];
	
	for (DPUICustomSetting *attribute in self.attributes) {
		[tmp addObject:attribute.jsonValue];
	}
	
	[dict setObject:tmp forKey:@"attributes"];
	
	[dict setObject:self.autoApply forKey:@"autoApply"];

	return dict;
}

@end
