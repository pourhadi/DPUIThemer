//
//  DYNInsets.m
//  DPUIThemer
//
//  Created by Dan Pourhadi on 6/13/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import "DYNInsets.h"

@implementation DYNInsets

- (id)init
{
	self = [super init];
	if (self) {
		self.top = @(0);
		self.bottom = @(0);
		self.left = @(0);
		self.right = @(0);
	}
	return self;
}

- (id)initWithDictionary:(NSDictionary*)dictionary
{
	self = [self init];
	if (self) {
		
		if ([dictionary objectForKey:@"top"])
			self.top = [dictionary objectForKey:@"top"];
		
		if ([dictionary objectForKey:@"bottom"])
			self.bottom = [dictionary objectForKey:@"bottom"];
		
		if ([dictionary objectForKey:@"left"])
			self.left = [dictionary objectForKey:@"left"];
		
		if ([dictionary objectForKey:@"right"])
			self.right = [dictionary objectForKey:@"right"];
	}
	return self;
}

- (id)jsonValue
{
	NSMutableDictionary *dict = [NSMutableDictionary new];
	[dict setObject:self.top forKey:@"top"];
	[dict setObject:self.bottom forKey:@"bottom"];
	[dict setObject:self.left forKey:@"left"];
	[dict setObject:self.right forKey:@"right"];
	return dict;
}

@end
