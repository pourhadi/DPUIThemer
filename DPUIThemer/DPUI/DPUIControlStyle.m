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

- (id)jsonValue
{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    if (self.normalTextStyle) {
        [dictionary setObject:self.normalTextStyle.jsonValue forKey:kDPUINormalTextStyle];
    }
    
    if (self.highlightedStyleName) {
        [dictionary setObject:self.highlightedStyleName forKey:kDPUIHighlightedStyleName];
    }
    
    if (self.highlightedTextStyle) {
        [dictionary setObject:self.highlightedTextStyle.jsonValue forKey:kDPUIHighlightedTextStyle];
    }
    
    if (self.selectedStyleName) {
        [dictionary setObject:self.selectedStyleName forKey:kDPUISelectedStyleName];
    }
    
    if (self.selectedTextStyle) {
        [dictionary setObject:self.selectedTextStyle.jsonValue forKey:kDPUISelectedTextStyle];
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
            self.normalTextStyle = [[DPUITextStyle alloc] initWithDictionary:[dictionary objectForKey:kDPUINormalTextStyle]];
        }
        if ([dictionary objectForKey:kDPUIHighlightedTextStyle]) {
            self.highlightedTextStyle = [[DPUITextStyle alloc] initWithDictionary:[dictionary objectForKey:kDPUIHighlightedTextStyle]];
        }
        if ([dictionary objectForKey:kDPUISelectedTextStyle]) {
            self.selectedTextStyle = [[DPUITextStyle alloc] initWithDictionary:[dictionary objectForKey:kDPUISelectedTextStyle]];
        }
        if ([dictionary objectForKey:kDPUIDisabledTextStyle]) {
            self.disabledTextStyle = [[DPUITextStyle alloc] initWithDictionary:[dictionary objectForKey:kDPUIDisabledTextStyle]];
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
