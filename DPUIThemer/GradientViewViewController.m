//
//  GradientViewViewController.m
//  DPUIThemer
//
//  Created by Dan Pourhadi on 6/6/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import "GradientViewViewController.h"
@interface GradientViewViewController ()
{
	BOOL _addedObservers;
}
@end

@implementation GradientViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.selectedColorIndex = -1;
    }
    
    return self;
}

- (void)setGradientColors:(NSArray*)colors andLocations:(NSArray*)locations andAngle:(CGFloat)angle
{
	self.gradientColors = colors;
	self.bgLocations = locations;
	self.gradientAngle = @(angle);
	NSArray *nsColors = [self.gradientColors valueForKeyPath:@"color"];

	CGFloat locs[nsColors.count];
	
	for (int x = 0; x < nsColors.count; x++) {
		
		locs[x] = [locations[x] floatValue];
	}
	
	self.gradientEditor.gradient = [[NSGradient alloc] initWithColors:nsColors atLocations:locs colorSpace:[NSColorSpace genericRGBColorSpace]];
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	self.gradientEditor.delegate = self;
}

- (void)selectedColorAtLocation:(NSInteger)locationIndex
{
	self.selectedColorIndex = locationIndex;
	DPStyleColor *color = self.gradientColors[locationIndex];
	
	self.selectedColor = color;
	if (!_addedObservers) {
		[self addObserver:self forKeyPath:@"selectedColor.color" options:0 context:nil];
		_addedObservers = YES;
	}
	
	if (!self.colorWell.isActive) {
		[self.colorWell performClick:nil];
	}
	
	self.selectedLocation = self.bgLocations[locationIndex];
	
	if (locationIndex != -1) {
		self.controlsEnabled = YES;
	} else {
		self.controlsEnabled = NO;
	}
}

- (void)newColor:(NSColor*)color atLocation:(CGFloat)location atIndex:(NSInteger)index
{
	NSMutableArray *muteColors = [self.gradientColors mutableCopy];
	NSMutableArray *muteLocs = [NSMutableArray arrayWithArray:self.bgLocations];
	
	DPStyleColor *newColor = [[DPStyleColor alloc] init];
	newColor.color = color;
	
	[muteColors insertObject:newColor atIndex:index];
	[muteLocs insertObject:@(location) atIndex:index];
	
	self.gradientColors = muteColors;
	self.bgLocations = muteLocs;
	[self.delegate updateColors:self.gradientColors andLocations:self.bgLocations andAngle:self.gradientAngle.floatValue];
}

- (void)removedColorAtIndex:(NSInteger)index
{
	NSMutableArray *muteColors = [self.gradientColors mutableCopy];
	NSMutableArray *muteLocs = [NSMutableArray arrayWithArray:self.bgLocations];
	
	[muteColors removeObjectAtIndex:index];
	[muteLocs removeObjectAtIndex:index];
	
	self.gradientColors = muteColors;
	self.bgLocations = muteLocs;
	[self.delegate updateColors:self.gradientColors andLocations:self.bgLocations andAngle:self.gradientAngle.floatValue];

}

- (void)setGradientAngle:(NSNumber *)gradientAngle
{
	[self willChangeValueForKey:@"gradientAngle"];
	_gradientAngle = gradientAngle;
	[self didChangeValueForKey:@"gradientAngle"];
	
	[self.delegate updateColors:self.gradientColors andLocations:self.bgLocations andAngle:self.gradientAngle.floatValue];

}

- (void)locationsChanged:(NSArray*)locations
{
	self.bgLocations = locations;
	[self.delegate updateColors:self.gradientColors andLocations:self.bgLocations andAngle:self.gradientAngle.floatValue];
	
	if (self.selectedColorIndex != -1) {
		self.selectedLocation = self.bgLocations[self.selectedColorIndex];
	}
}

- (void)selectKnobAtIndex:(NSInteger)index
{
	[self.gradientEditor selectKnobAtIndex:index];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
	[self.gradientEditor setColorForCurrentKnob:self.selectedColor.color];
}

@end
