//
//  DYNGradient.m
//  DPUIThemer
//
//  Created by Daniel Pourhadi on 6/7/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import "DYNGradient.h"
#import "DPStyleManager.h"
#import "DPStyleBackground.h"
@implementation DYNGradient


- (id)init
{
    self = [super init];
    if (self) {
        self.locations = @[@(0),@(1)];
        NSArray *colors = @[[[NSColor whiteColor] colorUsingColorSpace:[NSColorSpace genericRGBColorSpace]], [[NSColor blackColor] colorUsingColorSpace:[NSColorSpace genericRGBColorSpace]]];
        
        DPStyleColor *whiteColor = [[DPStyleColor alloc] init];
        whiteColor.color = colors[0];
        DPStyleColor *blackColor = [[DPStyleColor alloc] init];
        blackColor.color = colors[0];
        self.colors = @[whiteColor, blackColor];
        self.gradientAngle = @(180);
        self.gradientName = [DYNGradient newGradientName];
        
        [self addObserver:self forKeyPath:@"associatedGradient.colors" options:0 context:nil];
        [self addObserver:self forKeyPath:@"associatedGradient.locations" options:0 context:nil];
        [self addObserver:self forKeyPath:@"associatedGradient.gradientAngle" options:0 context:nil];

    }
    return self;
}

- (void)dealloc
{
	[self removeObserver:self forKeyPath:@"associatedGradient.colors"];
	[self removeObserver:self forKeyPath:@"associatedGradient.locations"];
	[self removeObserver:self forKeyPath:@"associatedGradient.gradientAngle"];

}

+ (NSString*)newGradientName
{
	NSInteger x = 1;
	BOOL found = NO;
	NSString *name;
	
	while (!found) {
		
		name = [NSString stringWithFormat:@"Gradient%ld", (long)x];
		if (![[[DPStyleManager sharedInstance] gradientNames] containsObject:name]) {
			found = YES;
		} else {
			x += 1;
		}
		
	}
	
	return name;
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self.associatedGradient) {
    if ([keyPath isEqualToString:@"associatedGradient.colors"]) {
        [self willChangeValueForKey:@"colors"];
        _colors = self.associatedGradient.colors;
        [self didChangeValueForKey:@"colors"];
    } else if ([keyPath isEqualToString:@"associatedGradient.locations"]) {
        [self willChangeValueForKey:@"locations"];
        _locations = self.associatedGradient.locations;
        [self didChangeValueForKey:@"locations"];
    } else if ([keyPath isEqualToString:@"gradientAngle"]) {
        [self willChangeValueForKey:@"associatedGradient.gradientAngle"];
        _gradientAngle = self.associatedGradient.gradientAngle;
        [self didChangeValueForKey:@"gradientAngle"];
    }
    }
}

- (void)removeObservers
{
//    if (self.associatedGradient) {
//        [self.associatedGradient removeObserver:self forKeyPath:@"colors"];
//        [self.associatedGradient removeObserver:self forKeyPath:@"locations"];
//        [self.associatedGradient removeObserver:self forKeyPath:@"gradientAngle"];
//    }
}

- (void)setGradientVariableName:(NSString *)gradientVariableName
{
    [self willChangeValueForKey:@"gradientVariableName"];
    _gradientVariableName = gradientVariableName;
    [self didChangeValueForKey:@"gradientVariableName"];
    
    [self removeObservers];
    
    if (gradientVariableName) {
        NSArray *gradients = [[DPStyleManager sharedInstance] gradients];
        NSPredicate *pred= [NSPredicate predicateWithFormat:@"gradientName == %@", gradientVariableName];
        NSArray *filters = [gradients filteredArrayUsingPredicate:pred];
        
        if (filters.count > 0) {
            
            DYNGradient *gradient = filters[0];
            
            self.associatedGradient = gradient;
            [self willChangeValueForKey:@"colors"];
            _colors = self.associatedGradient.colors;
            [self didChangeValueForKey:@"colors"];
            [self willChangeValueForKey:@"locations"];
            _locations = self.associatedGradient.locations;
            [self didChangeValueForKey:@"locations"];
            [self willChangeValueForKey:@"associatedGradient.gradientAngle"];
            _gradientAngle = self.associatedGradient.gradientAngle;
            [self didChangeValueForKey:@"gradientAngle"];
            

            
        } else {
            [self removeObservers];
            self.associatedGradient = nil;
        }
    } else {
        [self removeObservers];
        self.associatedGradient = nil;
    }

}

- (void)setColors:(NSArray *)colors
{
    if (colors != _colors) {
    [self willChangeValueForKey:@"colors"];
    _colors = colors;
    [self didChangeValueForKey:@"colors"];
    
    if (self.associatedGradient){
        self.gradientVariableName = nil;
    }
    }
}

- (void)setLocations:(NSArray *)locations
{
    if (locations != _locations) {
    [self willChangeValueForKey:@"locations"];
    _locations = locations;
    [self didChangeValueForKey:@"locations"];
    
    if (self.associatedGradient){
        self.gradientVariableName = nil;
    }
    }
}

- (void)setGradientAngle:(NSNumber *)gradientAngle
{
    if (gradientAngle != _gradientAngle) {
    [self willChangeValueForKey:@"gradientAngle"];
    _gradientAngle = gradientAngle;
    [self didChangeValueForKey:@"gradientAngle"];
    
    if (self.associatedGradient){
        self.gradientVariableName = nil;
    }
    }
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSMutableSet *newSet = [[super keyPathsForValuesAffectingValueForKey:key] mutableCopy];

    if ([key isEqualToString:@"gradient"] || [key isEqualToString:@"gradientImage"]) {
        [newSet addObject:@"colors"];
        [newSet addObject:@"locations"];
        [newSet addObject:@"gradientAngle"];
    }
    
    return newSet;
}

- (NSGradient*)gradient
{
    NSArray *colors = [self.colors valueForKeyPath:@"color"];
    CGFloat locs[self.locations.count];
    
    for (int x = 0; x < self.locations.count; x++) {
        
        locs[x] = [self.locations[x] floatValue];
        
    }
    
    NSGradient *gradient = [[NSGradient alloc] initWithColors:colors atLocations:locs colorSpace:[NSColorSpace genericRGBColorSpace]];
    return gradient;
}

- (NSImage*)gradientImage
{
    return [NSImage imageWithSize:NSMakeSize(40, 20) flipped:NO drawingHandler:^BOOL(NSRect dstRect) {

        [self.gradient drawInRect:dstRect angle:self.gradientAngle.floatValue+90];
        
        return YES;
    }];
}

- (void)updateColors:(NSArray *)colors andLocations:(NSArray *)locations andAngle:(CGFloat)angle
{
    self.colors = colors;
    self.locations = locations;
    self.gradientAngle = @(angle);

}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    if (self) {
        
        NSMutableArray *tmpColors = [NSMutableArray new];
        for (NSDictionary *color in [dictionary objectForKey:@"colors"]) {
            [tmpColors addObject:[[DPStyleColor alloc] initWithDictionary:color]];
        }
        
        self.colors = tmpColors;
        self.locations = [dictionary objectForKey:@"locations"];
        self.gradientAngle = [dictionary objectForKey:@"gradientAngle"];
        
        if ([dictionary objectForKey:@"gradientName"]) {
            self.gradientName = [dictionary objectForKey:@"gradientName"];
        }
        
        if ([dictionary objectForKey:@"gradientVariableName"]) {
            self.gradientVariableName = [dictionary objectForKey:@"gradientVariableName"];
        }

    }
    return self;
}

- (id)jsonValue
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    NSMutableArray *tmpColors = [NSMutableArray new];
    for (DPStyleColor *color in self.colors)     {
        [tmpColors addObject:color.jsonValue];
    }
    
    [dict setObject:tmpColors forKey:@"colors"];
    [dict setObject:self.locations forKey:@"locations"];
    [dict setObject:self.gradientAngle forKey:@"gradientAngle"];
    
    if (self.gradientName)
        [dict setObject:self.gradientName forKey:@"gradientName"];
    
    if (self.gradientVariableName) {
        [dict setObject:self.gradientVariableName forKey:@"gradientVariableName"];
    }
    
    return dict;
}

@end
