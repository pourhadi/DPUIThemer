//
//  DPUIParameter.m
//  DPUIThemer
//
//  Created by Daniel Pourhadi on 5/10/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import "DPUIParameter.h"
#import "DPStyleBackground.h"
@implementation DPUIParameter

- (NSColor*)color
{
    if ([self.value isKindOfClass:[DPStyleColor class]]) {
        return [(DPStyleColor*)self.value color];
    } else if ([self.value isKindOfClass:[NSColor class]]) {
        return self.value;
    }
    return nil;
}

- (void)setName:(NSString *)name
{
    [self willChangeValueForKey:@"name"];
    _name = name;
    [self didChangeValueForKey:@"name"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ColorOrParamVarChanged" object:nil];
}

@end
