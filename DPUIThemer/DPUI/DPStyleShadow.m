//
//  DPStyleShadow.m
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import "DPStyleShadow.h"
#import "ColorTransformer.h"

@implementation DPStyleShadow

- (id)init
{
    self = [super init];
    if (self) {
        //self.offset = CGSizeMake(0, 1);
        self.xOffset = 0;
		self.yOffset = 1;
		self.radius = 0;
        self.color = [NSColor blackColor];
        self.opacity = 0;
    }
    return self;
}

- (CGSize)offset
{
	return CGSizeMake(self.xOffset, self.yOffset);
}

- (void)setYOffsetDisplay:(CGFloat)yOffsetDisplay
{
    [self willChangeValueForKey:@"yOffsetDisplay"];
    self.yOffset = oppositeSign(yOffsetDisplay);
    [self didChangeValueForKey:@"yOffsetDisplay"];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSSet *set = [super keyPathsForValuesAffectingValueForKey:key];
    
    if ([key isEqualToString:@"yOffsetDisplay"]) {
    NSMutableSet *new = [set mutableCopy];
    [new addObject:@"yOffset"];
        set = new;
    }
    return set;
}

- (CGFloat)yOffsetDisplay
{
    return oppositeSign(self.yOffset);
}

- (void)drawShadow
{
	NSShadow* shadow = [[NSShadow alloc] init];
	[shadow setShadowColor: [self.color colorWithAlphaComponent:self.opacity]];
	[shadow setShadowOffset: NSMakeSize(self.xOffset*2, self.yOffset*2)];
	[shadow setShadowBlurRadius: self.radius*2];
	[shadow set];
}

- (void)addShadowToView:(NSView*)view
{
	view.wantsLayer = YES;
	view.layer.masksToBounds = NO;
//	view.layer.shadowColor = self.color.CGColor;
//	view.layer.shadowOffset = NSMakeSize(self.xOffset, self.yOffset);
//	view.layer.shadowOpacity = self.opacity;
//	view.layer.shadowRadius = self.radius;
	
	NSShadow* shadow = [[NSShadow alloc] init];
	[shadow setShadowColor: self.color];
	[shadow setShadowOffset: NSMakeSize(self.xOffset, self.yOffset)];
	[shadow setShadowBlurRadius: self.radius];
	[view setShadow:shadow];
	//UIBezierPath *path = [UIBezierPath bezierPathWithRect:view.bounds];
	//	view.layer.shadowPath = path.CGPath;
}

- (id)jsonValue
{
	NSMutableDictionary *dict = [NSMutableDictionary new];
	//CGFloat xoff = (self.xOffset > 0 ? -self.xOffset : fabs(self.xOffset));
	
    CGFloat xoff = self.xOffset;
    CGFloat yoff = (self.yOffset > 0 ? -self.yOffset : fabs(self.yOffset));

	[dict setObject:@(xoff) forKey:@"xOffset"];
	[dict setObject:@(yoff) forKey:@"yOffset"];
	[dict setObject:@(self.radius) forKey:@"radius"];
	[dict setObject:@(self.opacity) forKey:@"opacity"];
	[dict setObject:[ColorTransformer stringFromColor:self.color] forKey:@"color"];
	
	return dict;
}

- (id)initWithDictionary:(NSDictionary*)dictionary
{
	self = [super init];
	if (self) {
		
		self.xOffset = [[dictionary objectForKey:@"xOffset"] floatValue];
	//	self.xOffset = (self.xOffset > 0 ? -self.xOffset : fabs(self.xOffset));
		
		self.yOffset = [[dictionary objectForKey:@"yOffset"] floatValue];
		self.yOffset = (self.yOffset > 0 ? -self.yOffset : fabs(self.yOffset));

		self.radius = [[dictionary objectForKey:@"radius"] floatValue];
		self.opacity = [[dictionary objectForKey:@"opacity"] floatValue];
		self.color = [ColorTransformer colorFromString:[dictionary objectForKey:@"color"]];
	}
	return self;
}

@end
