//
//  DPUICustomSetting.m
//  DPUIThemer
//
//  Created by Dan Pourhadi on 5/24/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import "DPUICustomSetting.h"
#import "DPStyleManager.h"

/*static NSString * const kDYNKeyPathTypeView = @"UIView";
 static NSString * const kDYNKeyPathTypeLabel = @"UILabel";
 static NSString * const kDYNKeyPathTypeFont = @"UIFont";
 static NSString * const kDYNKeyPathTypeColor = @"UIColor";
 static NSString * const kDYNKeyPathTypeImage = @"UIImage";
*/

@implementation DPUICustomSetting

- (id)init
{
	self = [super init];
	if (self) {
		self.keyPath = @"";
		self.value = @"";
		self.keyPathType = @"";
	}
	return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	self = [self init];
	if (self) {
		
		if ([dictionary objectForKey:@"keyPath"])
			self.keyPath = [dictionary objectForKey:@"keyPath"];
		
		if ([dictionary objectForKey:@"keyPathType"])
			self.keyPathType = [dictionary objectForKey:@"keyPathType"];
		
		if ([dictionary objectForKey:@"keyPathType"])
			self.value = [dictionary objectForKey:@"value"];
	}
	return self;
}

- (id)jsonValue
{
	return @{@"keyPath":self.keyPath,
		  @"keyPathType":self.keyPathType,
		  @"value":self.value};
}

+ (NSArray*)keyPathTypes
{
	return @[kDYNKeyPathTypeView,
		  kDYNKeyPathTypeLabel,
		  kDYNKeyPathTypeFont,
		  kDYNKeyPathTypeColor,
		  kDYNKeyPathTypeImage];
}

- (NSArray*)possibleValues{

	if ([self.keyPathType isEqualToString:kDYNKeyPathTypeView]) {
		return [[DPStyleManager sharedInstance] styleNames];
	}
	
	if ([self.keyPathType isEqualToString:kDYNKeyPathTypeLabel]) {
		return [[DPStyleManager sharedInstance] textStyleNames];
	}
	
	if ([self.keyPathType isEqualToString:kDYNKeyPathTypeFont]) {
		return [[DPStyleManager sharedInstance] textStyleNames];
	}
	
	if ([self.keyPathType isEqualToString:kDYNKeyPathTypeImage]) {
		return [[DPStyleManager sharedInstance] imageStyleNames];
	}
	
	if ([self.keyPathType isEqualToString:kDYNKeyPathTypeColor]) {
		return [[DPStyleManager sharedInstance] colorVariableNames];

	}
	return nil;
}

@end
