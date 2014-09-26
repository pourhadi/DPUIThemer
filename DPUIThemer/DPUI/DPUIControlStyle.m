//
//  DPUIControlStyle.m
//  DPUIThemer
//
//  Created by Daniel Pourhadi on 5/9/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import "DPUIControlStyle.h"

static NSString * const kDPUINormalTextStyle = @"normalTextStyle";
static NSString * const kDPUIHighlightedStyleName = @"highlightedStyleName";
static NSString * const kDPUIHighlightedTextStyle = @"highlightedTextStyle";
static NSString * const kDPUISelectedStyleName = @"selectedStyleName";
static NSString * const kDPUISelectedTextStyle = @"selectedTextStyle";
static NSString * const kDPUIDisabledStyleName = @"disabledStyleName";
static NSString * const kDPUIDisabledTextStyle = @"disabledTextStyle";

@implementation DPUIControlStyle

//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.normalTextStyle forKey:@"normalTextStyle"];
    [encoder encodeObject:self.highlightedStyleName forKey:@"highlightedStyleName"];
    [encoder encodeObject:self.highlightedTextStyle forKey:@"highlightedTextStyle"];
    [encoder encodeObject:self.selectedStyleName forKey:@"selectedStyleName"];
    [encoder encodeObject:self.selectedTextStyle forKey:@"selectedTextStyle"];
    [encoder encodeObject:self.disabledStyleName forKey:@"disabledStyleName"];
    [encoder encodeObject:self.disabledTextStyle forKey:@"disabledTextStyle"];
    [encoder encodeObject:self.superStyleName forKey:@"superStyleName"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.normalTextStyle = [decoder decodeObjectForKey:@"normalTextStyle"];
        self.highlightedStyleName = [decoder decodeObjectForKey:@"highlightedStyleName"];
        self.highlightedTextStyle = [decoder decodeObjectForKey:@"highlightedTextStyle"];
        self.selectedStyleName = [decoder decodeObjectForKey:@"selectedStyleName"];
        self.selectedTextStyle = [decoder decodeObjectForKey:@"selectedTextStyle"];
        self.disabledStyleName = [decoder decodeObjectForKey:@"disabledStyleName"];
        self.disabledTextStyle = [decoder decodeObjectForKey:@"disabledTextStyle"];
        self.superStyleName = [decoder decodeObjectForKey:@"superStyleName"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    id theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
	
    [theCopy setNormalTextStyle:[self.normalTextStyle copy]];
    [theCopy setHighlightedStyleName:[self.highlightedStyleName copy]];
    [theCopy setHighlightedTextStyle:[self.highlightedTextStyle copy]];
    [theCopy setSelectedStyleName:[self.selectedStyleName copy]];
    [theCopy setSelectedTextStyle:[self.selectedTextStyle copy]];
    [theCopy setDisabledStyleName:[self.disabledStyleName copy]];
    [theCopy setDisabledTextStyle:[self.disabledTextStyle copy]];
    [theCopy setSuperStyleName:[self.superStyleName copy]];
	
    return theCopy;
}
- (id)jsonValue
{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    if (self.normalTextStyle) {
        [dictionary setObject:self.normalTextStyle forKey:kDPUINormalTextStyle];
    }
    
    if (self.highlightedStyleName) {
        [dictionary setObject:self.highlightedStyleName forKey:kDPUIHighlightedStyleName];
    }
    
    if (self.highlightedTextStyle) {
        [dictionary setObject:self.highlightedTextStyle forKey:kDPUIHighlightedTextStyle];
    }
    
    if (self.selectedStyleName) {
        [dictionary setObject:self.selectedStyleName forKey:kDPUISelectedStyleName];
    }
    
    if (self.selectedTextStyle) {
        [dictionary setObject:self.selectedTextStyle forKey:kDPUISelectedTextStyle];
    }
    
    if (self.disabledStyleName) {
        [dictionary setObject:self.disabledStyleName forKey:kDPUIDisabledStyleName];
    }
    
    if (self.disabledTextStyle) {
        [dictionary setObject:self.disabledTextStyle forKey:kDPUIDisabledTextStyle];
    }
    
    return dictionary;
}

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        if ([dictionary objectForKey:kDPUINormalTextStyle]) {
            self.normalTextStyle = [dictionary objectForKey:kDPUINormalTextStyle];
        }
        if ([dictionary objectForKey:kDPUIHighlightedTextStyle]) {
            self.highlightedTextStyle = [dictionary objectForKey:kDPUIHighlightedTextStyle];
        }
        if ([dictionary objectForKey:kDPUISelectedTextStyle]) {
            self.selectedTextStyle = [dictionary objectForKey:kDPUISelectedTextStyle];
        }
        if ([dictionary objectForKey:kDPUIDisabledTextStyle]) {
            self.disabledTextStyle = [dictionary objectForKey:kDPUIDisabledTextStyle];
        }
        
        if ([dictionary objectForKey:kDPUIHighlightedStyleName]) {
            self.highlightedStyleName = [dictionary objectForKey:kDPUIHighlightedStyleName];
        }
        if ([dictionary objectForKey:kDPUISelectedStyleName]) {
            self.selectedStyleName = [dictionary objectForKey:kDPUISelectedStyleName];
        }
        if ([dictionary objectForKey:kDPUIDisabledStyleName]) {
            self.disabledStyleName = [dictionary objectForKey:kDPUIDisabledStyleName];
        }
        
    }
    return self;
}

@end
