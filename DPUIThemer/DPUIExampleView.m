//
//  DPUIExampleView.m
//  DPUIThemer
//
//  Created by Daniel Pourhadi on 4/30/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import "DPUIExampleView.h"
#import "DPUIDocument.h"
#import "NSBezierPath+GTMBezierPathRoundRectAdditions.h"
@implementation DPUIExampleView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
		self.xScale = 0.5;
		self.yScale = 0.5;
		
		self.width = self.xScale * frame.size.width;
		self.height = self.yScale * frame.size.height;
    }
    
    return self;
}

- (void)setXScale:(CGFloat)xScale
{
	[self willChangeValueForKey:@"xScale"];
	_xScale = xScale;
	[self didChangeValueForKey:@"xScale"];
	
	[self setNeedsDisplay:YES];
}

- (void)setYScale:(CGFloat)yScale
{
	[self willChangeValueForKey:@"yScale"];
	_yScale = yScale;
	[self didChangeValueForKey:@"yScale"];
	[self setNeedsDisplay:YES];
}

- (void)setStyle:(DPUIStyle *)style
{
	_style = style;
	
	[self setNeedsDisplay:YES];
}

//- (void)viewDidMoveToSuperview
//{
//    [super viewDidMoveToSuperview];
//    
//}

- (void)setFrame:(NSRect)frameRect
{
	[super setFrame:frameRect];
	
	self.frameHeight = frameRect.size.height;
	self.frameWidth = frameRect.size.width;
}

- (CGFloat)frameHeight
{
	return self.frame.size.height;
}

- (void)setContainerColor:(NSColor *)containerColor
{
	_containerColor = containerColor;
	[self setNeedsDisplay:YES];
}

- (CGFloat)frameWidth
{
	return self.frame.size.width;
}

- (void)drawRect:(NSRect)dirtyRect
{
	
	[self.containerColor setFill];
	NSRectFill(dirtyRect);
	CGFloat width = self.width;
	CGFloat height = self.height;
	CGFloat baseX = (dirtyRect.size.width - width) / 2;
	CGFloat baseY = (dirtyRect.size.height - height) / 2;
    NSRect newRect = NSMakeRect(baseX, baseY, width, height);
	CGSize size = newRect.size;
	if (self.sliderStyle) {
		
		
		/// Color Declarations

		NSMutableArray *maxColors = [NSMutableArray new];
		
		for (DPStyleColor *dpColor in self.sliderStyle.maxTrackBgColors) {
			[maxColors addObject:dpColor.color];
		}
		
		NSMutableArray *minColors = [NSMutableArray new];
		for (DPStyleColor *dpColor in self.sliderStyle.minTrackBgColors) {
			[minColors addObject:dpColor.color];
		}
		
		//// Gradient Declarations
		NSGradient* maxTrackGrad = [[NSGradient alloc] initWithColors:maxColors];
		NSGradient* minTrackGrad = [[NSGradient alloc] initWithColors:minColors];
		
		CGFloat trackY = (dirtyRect.size.height - self.sliderStyle.trackHeight) / 2;
		
		//// Abstracted Attributes
		NSRect minimumTrackRect = NSMakeRect(baseX, trackY, width/2, self.sliderStyle.trackHeight);
		CGFloat minimumTrackCornerRadius = self.sliderStyle.trackHeight / 2;
		NSRect maximumTrackRect = NSMakeRect(NSMaxX(minimumTrackRect), trackY, width/2, self.sliderStyle.trackHeight);
		CGFloat maximumTrackCornerRadius = self.sliderStyle.trackHeight / 2;
		
		CGFloat thumbHeight = self.sliderStyle.trackHeight * self.sliderStyle.thumbHeight;
		NSRect thumbRect = NSMakeRect((dirtyRect.size.width-thumbHeight)/2, (dirtyRect.size.height-thumbHeight)/2, thumbHeight, thumbHeight);
		
		
		NSRect minimumTrackInnerRect = NSInsetRect(minimumTrackRect, minimumTrackCornerRadius, minimumTrackCornerRadius);
		NSBezierPath* minimumTrackPath = [NSBezierPath bezierPath];
		[minimumTrackPath appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(minimumTrackInnerRect), NSMinY(minimumTrackInnerRect)) radius: minimumTrackCornerRadius startAngle: 180 endAngle: 270];
		[minimumTrackPath lineToPoint: NSMakePoint(NSMaxX(minimumTrackRect), NSMinY(minimumTrackRect))];
		[minimumTrackPath lineToPoint: NSMakePoint(NSMaxX(minimumTrackRect), NSMaxY(minimumTrackRect))];
		[minimumTrackPath appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(minimumTrackInnerRect), NSMaxY(minimumTrackInnerRect)) radius: minimumTrackCornerRadius startAngle: 90 endAngle: 180];
		[minimumTrackPath closePath];
		
		
		//// maximumTrack Drawing
		NSRect maximumTrackInnerRect = NSInsetRect(maximumTrackRect, maximumTrackCornerRadius, maximumTrackCornerRadius);
		NSBezierPath* maximumTrackPath = [NSBezierPath bezierPath];
		[maximumTrackPath moveToPoint: NSMakePoint(NSMinX(maximumTrackRect), NSMinY(maximumTrackRect))];
		[maximumTrackPath appendBezierPathWithArcWithCenter: NSMakePoint(NSMaxX(maximumTrackInnerRect), NSMinY(maximumTrackInnerRect)) radius: maximumTrackCornerRadius startAngle: 270 endAngle: 360];
		[maximumTrackPath appendBezierPathWithArcWithCenter: NSMakePoint(NSMaxX(maximumTrackInnerRect), NSMaxY(maximumTrackInnerRect)) radius: maximumTrackCornerRadius startAngle: 0 endAngle: 90];
		[maximumTrackPath lineToPoint: NSMakePoint(NSMinX(maximumTrackRect), NSMaxY(maximumTrackRect))];
		[maximumTrackPath closePath];
		
		NSBezierPath *combined = [NSBezierPath bezierPath];
		
		[combined appendBezierPath:maximumTrackPath];
		[combined appendBezierPath:minimumTrackPath];
		
		if (self.sliderStyle.outerShadow) {
			NSShadow *shadow = [[NSShadow alloc] init];
			shadow.shadowBlurRadius = self.sliderStyle.outerShadow.radius;
			shadow.shadowOffset = CGSizeMake(self.sliderStyle.outerShadow.xOffset, oppositeSign(self.sliderStyle.outerShadow.yOffset));
			shadow.shadowColor = [self.sliderStyle.outerShadow.color colorWithAlphaComponent:self.sliderStyle.outerShadow.opacity];
			
			[NSGraphicsContext saveGraphicsState];
			[shadow set];
			[[NSColor blackColor] set];
			[combined fill];
			[NSGraphicsContext restoreGraphicsState];
		}
		
		
		[maxTrackGrad drawInBezierPath: maximumTrackPath angle: -90];
		[minTrackGrad drawInBezierPath: minimumTrackPath angle: -90];
		
		NSBezierPath* rectanglePath = maximumTrackPath;
		NSShadow *shadow = [[NSShadow alloc] init];
		shadow.shadowBlurRadius = self.sliderStyle.maximumTrackInnerShadow.radius;
		shadow.shadowOffset = CGSizeMake(self.sliderStyle.maximumTrackInnerShadow.xOffset, oppositeSign(self.sliderStyle.maximumTrackInnerShadow.yOffset));
		shadow.shadowColor = [self.sliderStyle.maximumTrackInnerShadow.color colorWithAlphaComponent:self.sliderStyle.maximumTrackInnerShadow.opacity];

		////// Rectangle Inner Shadow
		NSRect rectangleBorderRect = NSInsetRect([rectanglePath bounds], -shadow.shadowBlurRadius, -shadow.shadowBlurRadius);
		rectangleBorderRect = NSOffsetRect(rectangleBorderRect, -shadow.shadowOffset.width, -shadow.shadowOffset.height);
		rectangleBorderRect = NSInsetRect(NSUnionRect(rectangleBorderRect, [rectanglePath bounds]), -1, -1);
		
		NSBezierPath* rectangleNegativePath = [NSBezierPath bezierPathWithRect: rectangleBorderRect];
		[rectangleNegativePath appendBezierPath: rectanglePath];
		[rectangleNegativePath setWindingRule: NSEvenOddWindingRule];
		
		[NSGraphicsContext saveGraphicsState];
		{
			NSShadow* shadowWithOffset = [shadow copy];
			CGFloat xOffset = shadowWithOffset.shadowOffset.width + round(rectangleBorderRect.size.width);
			CGFloat yOffset = shadowWithOffset.shadowOffset.height;
			shadowWithOffset.shadowOffset = NSMakeSize(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
			[shadowWithOffset set];
			[[NSColor grayColor] setFill];
			[rectanglePath addClip];
			NSAffineTransform* transform = [NSAffineTransform transform];
			[transform translateXBy: -round(rectangleBorderRect.size.width) yBy: 0];
			[[transform transformBezierPath: rectangleNegativePath] fill];
		}
		[NSGraphicsContext restoreGraphicsState];
		
		rectanglePath = minimumTrackPath;
		shadow = [[NSShadow alloc] init];
		shadow.shadowBlurRadius = self.sliderStyle.minimumTrackInnerShadow.radius;
		shadow.shadowOffset = CGSizeMake(self.sliderStyle.minimumTrackInnerShadow.xOffset, oppositeSign(self.sliderStyle.minimumTrackInnerShadow.yOffset));
		shadow.shadowColor = [self.sliderStyle.minimumTrackInnerShadow.color colorWithAlphaComponent:self.sliderStyle.minimumTrackInnerShadow.opacity];
		////// Rectangle Inner Shadow
		rectangleBorderRect = NSInsetRect([rectanglePath bounds], -shadow.shadowBlurRadius, -shadow.shadowBlurRadius);
		rectangleBorderRect = NSOffsetRect(rectangleBorderRect, -shadow.shadowOffset.width, -shadow.shadowOffset.height);
		rectangleBorderRect = NSInsetRect(NSUnionRect(rectangleBorderRect, [rectanglePath bounds]), -1, -1);
		
		rectangleNegativePath = [NSBezierPath bezierPathWithRect: rectangleBorderRect];
		[rectangleNegativePath appendBezierPath: rectanglePath];
		[rectangleNegativePath setWindingRule: NSEvenOddWindingRule];
		
		[NSGraphicsContext saveGraphicsState];
		{
			NSShadow* shadowWithOffset = [shadow copy];
			CGFloat xOffset = shadowWithOffset.shadowOffset.width + round(rectangleBorderRect.size.width);
			CGFloat yOffset = shadowWithOffset.shadowOffset.height;
			shadowWithOffset.shadowOffset = NSMakeSize(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
			[shadowWithOffset set];
			[[NSColor grayColor] setFill];
			[rectanglePath addClip];
			NSAffineTransform* transform = [NSAffineTransform transform];
			[transform translateXBy: -round(rectangleBorderRect.size.width) yBy: 0];
			[[transform transformBezierPath: rectangleNegativePath] fill];
		}
		[NSGraphicsContext restoreGraphicsState];

		if (self.sliderStyle.strokeWidth > 0) {
			
			CGRect bounds = combined.bounds;
			
			CGRect strokeRect = CGRectMake(bounds.origin.x + (self.sliderStyle.strokeWidth/2), bounds.origin.y + (self.sliderStyle.strokeWidth/2), bounds.size.width - self.sliderStyle.strokeWidth, bounds.size.height-self.sliderStyle.strokeWidth);
			
			NSBezierPath *strokePath = [NSBezierPath bezierPathWithRoundedRect:strokeRect xRadius:strokeRect.size.height/2 yRadius:strokeRect.size.height/2];
			
			[self.sliderStyle.strokeColor.color setStroke];
			[strokePath setLineWidth:self.sliderStyle.strokeWidth];
			[strokePath stroke];
		}
		//// Thumb Drawing
		//NSBezierPath* thumbPath = [NSBezierPath bezierPathWithOvalInRect: thumbRect];
	
		if (self.sliderStyle.thumbStyleName) {
			DPUIStyle *style = (DPUIStyle*)[[DPStyleManager sharedInstance] styleForName:self.sliderStyle.thumbStyleName];

			[self drawThumbWithStyle:style WithRect:thumbRect];
		}
		//UIImage *thumbImage =
//		[fillColor setFill];
//		[thumbPath fill];
//		[strokeColor setStroke];
//		[thumbPath setLineWidth: 1];
//		[thumbPath stroke];
		
		

		
		
		
	} else if (self.style) {
	//NSLog(@"%@", NSStringFromRect(dirtyRect));
	
	//NSLog(@"%@", NSStringFromRect(newRect));

    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];

    NSBezierPath *path;
    
    if (!CGSizeEqualToSize(self.style.cornerRadii, CGSizeZero) || (self.style.roundedCorners != 0 && self.style.cornerRadiusType.intValue != 0)) {
		
		CGFloat cornerRadius = self.style.cornerRadius;
		
		if (self.style.cornerRadiusType.intValue > 0) {
			if (self.style.cornerRadiusType.intValue == 1) {
				cornerRadius = .5 * height;
			} else if (self.style.cornerRadiusType.intValue == 2) {
				cornerRadius = .5 * width;
			}
		}
		
		
		CGFloat tl = ((self.style.roundedCorners & UIRectCornerTopLeft) > 0 ? cornerRadius : 0);
		CGFloat tr = ((self.style.roundedCorners & UIRectCornerTopRight) > 0 ? cornerRadius : 0);
		CGFloat bl = ((self.style.roundedCorners & UIRectCornerBottomLeft) > 0 ? cornerRadius : 0);
		CGFloat br = ((self.style.roundedCorners & UIRectCornerBottomRight) > 0 ? cornerRadius : 0);
		path = [NSBezierPath gtm_bezierPathWithRoundRect:newRect topLeftCornerRadius:tl topRightCornerRadius:tr bottomLeftCornerRadius:bl bottomRightCornerRadius:br];
		
		//NSLog(@"tl: %f, tr: %f, bl: %f, br: %f", tl, tr, bl, br);
		
		//   path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:self.style.cornerRadii.width yRadius:self.style.cornerRadii.height];
    } else {
        path = [NSBezierPath bezierPathWithRect:newRect];
    }
	[NSGraphicsContext saveGraphicsState];
	if (self.style.shadow.opacity > 0) {
//		self.shadow = nil;
//        self.layer.masksToBounds = NO;
//		self.layer.shadowPath = [path quartzPath];
//        [self.style.shadow addShadowToView:self];
        
		[self.style.shadow drawShadow];
    } else {
		//self.shadow = nil;
	}
	
	
	//CGContextTranslateCTM(context, 0.0f, size.height);
	//CGContextScaleCTM(context, 1.0f, -1.0f);
        if (self.style.bgColors.count > 1) {
			
			NSColor *fill = [self.style.bgColors[0] color];
            [fill setFill];
            [path fill];
			
            CGGradientRef gradient;
            NSMutableArray *colors = [NSMutableArray new];
			
			float div = 1 / (float)(self.style.bgColors.count-1);
			NSMutableArray *locs = [NSMutableArray new];
			float current = 0;
			for (int x = 0; x < self.style.bgColors.count; x++) {
				[locs addObject:@(current)];
				current += div;
			}
			
            NSMutableArray *locations = locs;
            CGColorSpaceRef myColorspace;
            myColorspace = CGColorSpaceCreateDeviceRGB();
            
            for (DPStyleColor *color in self.style.bgColors) {
                [colors addObject:(id)color.color.CGColor];
            }
            
            CGFloat locArray[locations.count];
            for (int x = 0; x < locations.count; x++) {
                locArray[x] = [(NSNumber*)locations[x] floatValue];
            }
            
            CFArrayRef components = (__bridge CFArrayRef)colors;
            gradient = CGGradientCreateWithColors(myColorspace, components, locArray);
			[NSGraphicsContext saveGraphicsState];
			[path addClip];
            CGContextDrawLinearGradient(context, gradient, CGPointMake(baseX + (0.5*size.width),baseY + (1*size.height)), CGPointMake(baseX + (0.5*size.width), baseY + (0*size.height)), 0);
			[NSGraphicsContext restoreGraphicsState];
		} else if (self.style.bgColors.count > 0){
            NSColor *fill = [self.style.bgColors[0] color];
            [fill setFill];
            [path fill];
        }
	[NSGraphicsContext restoreGraphicsState];
	[NSGraphicsContext saveGraphicsState];
	[path addClip];
	
    
	
        if (self.style.innerShadow.opacity > 0) {
            //// Shadow Declarations
            NSColor* shadowColor = self.style.innerShadow.color;
            CGSize shadowOffset = self.style.innerShadow.offset;
            CGFloat shadowBlurRadius = self.style.innerShadow.radius;
            
            //// Shadow Declarations
			NSShadow* shadow = [[NSShadow alloc] init];
			[shadow setShadowColor: shadowColor];
			[shadow setShadowOffset: NSMakeSize(oppositeSign(shadowOffset.width), oppositeSign(shadowOffset.height))];
			[shadow setShadowBlurRadius: shadowBlurRadius];
			
			//// Rectangle Drawing
			NSBezierPath* rectanglePath = path;
			
			////// Rectangle Inner Shadow
			NSRect rectangleBorderRect = NSInsetRect([rectanglePath bounds], -shadow.shadowBlurRadius, -shadow.shadowBlurRadius);
			rectangleBorderRect = NSOffsetRect(rectangleBorderRect, -shadow.shadowOffset.width, -shadow.shadowOffset.height);
			rectangleBorderRect = NSInsetRect(NSUnionRect(rectangleBorderRect, [rectanglePath bounds]), -1, -1);
			
			NSBezierPath* rectangleNegativePath = [NSBezierPath bezierPathWithRect: rectangleBorderRect];
			[rectangleNegativePath appendBezierPath: rectanglePath];
			[rectangleNegativePath setWindingRule: NSEvenOddWindingRule];
			
			[NSGraphicsContext saveGraphicsState];
			{
				NSShadow* shadowWithOffset = [shadow copy];
				CGFloat xOffset = shadowWithOffset.shadowOffset.width + round(rectangleBorderRect.size.width);
				CGFloat yOffset = shadowWithOffset.shadowOffset.height;
				shadowWithOffset.shadowOffset = NSMakeSize(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
				[shadowWithOffset set];
				[[NSColor grayColor] setFill];
				[rectanglePath addClip];
				NSAffineTransform* transform = [NSAffineTransform transform];
				[transform translateXBy: -round(rectangleBorderRect.size.width) yBy: 0];
				[[transform transformBezierPath: rectangleNegativePath] fill];
			}
			[NSGraphicsContext restoreGraphicsState];
			
			

            
        }
        
        CGFloat currentY = baseY;
        for (int x = 0; x < self.style.bottomInnerBorders.count; x++) {
            DPStyleInnerBorder *innerBorder = self.style.bottomInnerBorders[x];
			
			
			
			NSColor* shadowColor = innerBorder.color.color;
            CGSize shadowOffset = CGSizeMake(0, -innerBorder.height);
            CGFloat shadowBlurRadius = 0;
            
            //// Shadow Declarations
			NSShadow* shadow = [[NSShadow alloc] init];
			[shadow setShadowColor: shadowColor];
			[shadow setShadowOffset: NSMakeSize(oppositeSign(shadowOffset.width), oppositeSign(shadowOffset.height))];
			[shadow setShadowBlurRadius: shadowBlurRadius];
			
			//// Rectangle Drawing
			NSBezierPath* rectanglePath = path;
			
			////// Rectangle Inner Shadow
			NSRect rectangleBorderRect = NSInsetRect([rectanglePath bounds], -shadow.shadowBlurRadius, -shadow.shadowBlurRadius);
			rectangleBorderRect = NSOffsetRect(rectangleBorderRect, -shadow.shadowOffset.width, -shadow.shadowOffset.height);
			rectangleBorderRect = NSInsetRect(NSUnionRect(rectangleBorderRect, [rectanglePath bounds]), -1, -1);
			
			NSBezierPath* rectangleNegativePath = [NSBezierPath bezierPathWithRect: rectangleBorderRect];
			[rectangleNegativePath appendBezierPath: rectanglePath];
			[rectangleNegativePath setWindingRule: NSEvenOddWindingRule];
			
			[NSGraphicsContext saveGraphicsState];
			{
				CGContextSetBlendMode(context, innerBorder.blendMode);

				NSShadow* shadowWithOffset = [shadow copy];
				CGFloat xOffset = shadowWithOffset.shadowOffset.width + round(rectangleBorderRect.size.width);
				CGFloat yOffset = shadowWithOffset.shadowOffset.height;
				shadowWithOffset.shadowOffset = NSMakeSize(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
				[shadowWithOffset set];
				[[NSColor grayColor] setFill];
				[rectanglePath addClip];
				NSAffineTransform* transform = [NSAffineTransform transform];
				[transform translateXBy: -round(rectangleBorderRect.size.width) yBy: 0];
				[[transform transformBezierPath: rectangleNegativePath] fill];
			}
			[NSGraphicsContext restoreGraphicsState];

			
//            CGRect border = CGRectMake(baseX, currentY, size.width, innerBorder.height);
//            [innerBorder.color.color setFill];
//			[NSGraphicsContext saveGraphicsState];
//			CGContextSetBlendMode(context, innerBorder.blendMode);
//            CGContextFillRect(context, border);
//            [NSGraphicsContext restoreGraphicsState];
            currentY += innerBorder.height;
        }
        
        if (self.style.topInnerBorders.count > 0) {
            currentY = size.height - baseY;
            for (int x = 0; x < self.style.topInnerBorders.count; x++) {
                DPStyleInnerBorder *innerBorder = self.style.topInnerBorders[x];
                currentY -= innerBorder.height;				
				
				
				NSColor* shadowColor = innerBorder.color.color;
				CGSize shadowOffset = CGSizeMake(0, innerBorder.height);
				CGFloat shadowBlurRadius = 0;
				
				//// Shadow Declarations
				NSShadow* shadow = [[NSShadow alloc] init];
				[shadow setShadowColor: shadowColor];
				[shadow setShadowOffset: NSMakeSize(oppositeSign(shadowOffset.width), oppositeSign(shadowOffset.height))];
				[shadow setShadowBlurRadius: shadowBlurRadius];
				
				//// Rectangle Drawing
				NSBezierPath* rectanglePath = path;
				
				////// Rectangle Inner Shadow
				NSRect rectangleBorderRect = NSInsetRect([rectanglePath bounds], -shadow.shadowBlurRadius, -shadow.shadowBlurRadius);
				rectangleBorderRect = NSOffsetRect(rectangleBorderRect, -shadow.shadowOffset.width, -shadow.shadowOffset.height);
				rectangleBorderRect = NSInsetRect(NSUnionRect(rectangleBorderRect, [rectanglePath bounds]), -1, -1);
				
				NSBezierPath* rectangleNegativePath = [NSBezierPath bezierPathWithRect: rectangleBorderRect];
				[rectangleNegativePath appendBezierPath: rectanglePath];
				[rectangleNegativePath setWindingRule: NSEvenOddWindingRule];
				
				[NSGraphicsContext saveGraphicsState];
				{
					CGContextSetBlendMode(context, innerBorder.blendMode);
					
					NSShadow* shadowWithOffset = [shadow copy];
					CGFloat xOffset = shadowWithOffset.shadowOffset.width + round(rectangleBorderRect.size.width);
					CGFloat yOffset = shadowWithOffset.shadowOffset.height;
					shadowWithOffset.shadowOffset = NSMakeSize(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
					[shadowWithOffset set];
					[[NSColor grayColor] setFill];
					[rectanglePath addClip];
					NSAffineTransform* transform = [NSAffineTransform transform];
					[transform translateXBy: -round(rectangleBorderRect.size.width) yBy: 0];
					[[transform transformBezierPath: rectangleNegativePath] fill];
				}
				[NSGraphicsContext restoreGraphicsState];
            }
        }
        
    if (self.style.strokeWidth > 0) {
		NSBezierPath *strokePath;
		CGRect strokeRect = CGRectMake(newRect.origin.x + (self.style.strokeWidth/2), newRect.origin.y + (self.style.strokeWidth/2), newRect.size.width-self.style.strokeWidth, newRect.size.height-self.style.strokeWidth);
		if (!CGSizeEqualToSize(self.style.cornerRadii, CGSizeZero) || (self.style.roundedCorners != 0 && self.style.cornerRadiusType.intValue != 0)) {
			
			CGFloat cornerRadius = self.style.cornerRadius;
			
			if (self.style.cornerRadiusType.intValue > 0) {
				if (self.style.cornerRadiusType.intValue == 1) {
					cornerRadius = .5 * height;
				} else if (self.style.cornerRadiusType.intValue == 2) {
					cornerRadius = .5 * width;
				}
			}
			
			
			CGFloat tl = ((self.style.roundedCorners & UIRectCornerTopLeft) > 0 ? cornerRadius : 0);
			CGFloat tr = ((self.style.roundedCorners & UIRectCornerTopRight) > 0 ? cornerRadius : 0);
			CGFloat bl = ((self.style.roundedCorners & UIRectCornerBottomLeft) > 0 ? cornerRadius : 0);
			CGFloat br = ((self.style.roundedCorners & UIRectCornerBottomRight) > 0 ? cornerRadius : 0);
			strokePath = [NSBezierPath gtm_bezierPathWithRoundRect:strokeRect topLeftCornerRadius:tl topRightCornerRadius:tr bottomLeftCornerRadius:bl bottomRightCornerRadius:br];
			
			//NSLog(@"tl: %f, tr: %f, bl: %f, br: %f", tl, tr, bl, br);
			
			//   path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:self.style.cornerRadii.width yRadius:self.style.cornerRadii.height];
		} else {
			strokePath = [NSBezierPath bezierPathWithRect:strokeRect];
		}
		

		[strokePath setLineWidth:self.style.strokeWidth*2];
		[self.style.strokeColor.color setStroke];
		[strokePath stroke];
	}
    [NSGraphicsContext restoreGraphicsState];
    
    
    
//    if (self.clipCorners) {
//        NSImage *mask = [NSImage imageWithSize:size drawnFromBlock:^(CGContextRef context, CGSize size) {
//            
//            [path addClip];
//            [[NSColor blackColor] setFill];
//            [path fill];
//            
//        }];
//        
//        CALayer *layerMask = [CALayer layer];
//        layerMask.frame = view.bounds;
//        layerMask.contents = (id)mask.CGImage;
//        view.layer.mask = layerMask;
		
	}
//    }
}

-(void)drawThumbWithStyle:(DPUIStyle*)style WithRect:(CGRect)rect
{
	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
	CGFloat baseX = rect.origin.x;
	CGFloat baseY = rect.origin.y;
	CGFloat height = rect.size.height;
	CGFloat width = rect.size.width;
	CGSize size = CGSizeMake(width, height);
    NSBezierPath *path;
    
    if (!CGSizeEqualToSize(style.cornerRadii, CGSizeZero) || (style.roundedCorners != 0 && style.cornerRadiusType.intValue != 0)) {
		
		CGFloat cornerRadius = style.cornerRadius;
		
		if (style.cornerRadiusType.intValue > 0) {
			if (style.cornerRadiusType.intValue == 1) {
				cornerRadius = .5 * height;
			} else if (style.cornerRadiusType.intValue == 2) {
				cornerRadius = .5 * width;
			}
		}
		
		
		CGFloat tl = ((style.roundedCorners & UIRectCornerTopLeft) > 0 ? cornerRadius : 0);
		CGFloat tr = ((style.roundedCorners & UIRectCornerTopRight) > 0 ? cornerRadius : 0);
		CGFloat bl = ((style.roundedCorners & UIRectCornerBottomLeft) > 0 ? cornerRadius : 0);
		CGFloat br = ((style.roundedCorners & UIRectCornerBottomRight) > 0 ? cornerRadius : 0);
		path = [NSBezierPath gtm_bezierPathWithRoundRect:rect topLeftCornerRadius:tl topRightCornerRadius:tr bottomLeftCornerRadius:bl bottomRightCornerRadius:br];
		
		//NSLog(@"tl: %f, tr: %f, bl: %f, br: %f", tl, tr, bl, br);
		
		//   path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:style.cornerRadii.width yRadius:style.cornerRadii.height];
    } else {
        path = [NSBezierPath bezierPathWithRect:rect];
    }
	[NSGraphicsContext saveGraphicsState];
	if (style.shadow.opacity > 0) {
		//		self.shadow = nil;
		//        self.layer.masksToBounds = NO;
		//		self.layer.shadowPath = [path quartzPath];
		//        [style.shadow addShadowToView:self];
        
		[style.shadow drawShadow];
    } else {
		//self.shadow = nil;
	}
	
	
	//CGContextTranslateCTM(context, 0.0f, size.height);
	//CGContextScaleCTM(context, 1.0f, -1.0f);
	if (style.bgColors.count > 1) {
		
		NSColor *fill = [style.bgColors[0] color];
		[fill setFill];
		[path fill];
		
		CGGradientRef gradient;
		NSMutableArray *colors = [NSMutableArray new];
		
		float div = 1 / (float)(style.bgColors.count-1);
		NSMutableArray *locs = [NSMutableArray new];
		float current = 0;
		for (int x = 0; x < style.bgColors.count; x++) {
			[locs addObject:@(current)];
			current += div;
		}
		
		NSMutableArray *locations = locs;
		CGColorSpaceRef myColorspace;
		myColorspace = CGColorSpaceCreateDeviceRGB();
		
		for (DPStyleColor *color in style.bgColors) {
			[colors addObject:(id)color.color.CGColor];
		}
		
		CGFloat locArray[locations.count];
		for (int x = 0; x < locations.count; x++) {
			locArray[x] = [(NSNumber*)locations[x] floatValue];
		}
		
		CFArrayRef components = (__bridge CFArrayRef)colors;
		gradient = CGGradientCreateWithColors(myColorspace, components, locArray);
		[NSGraphicsContext saveGraphicsState];
		[path addClip];
		CGContextDrawLinearGradient(context, gradient, CGPointMake(baseX + (0.5*size.width),baseY + (1*size.height)), CGPointMake(baseX + (0.5*size.width), baseY + (0*size.height)), 0);
		[NSGraphicsContext restoreGraphicsState];
	} else if (style.bgColors.count > 0){
		NSColor *fill = [style.bgColors[0] color];
		[fill setFill];
		[path fill];
	}
	[NSGraphicsContext restoreGraphicsState];
	[NSGraphicsContext saveGraphicsState];
	[path addClip];
	
    
	
	if (style.innerShadow.opacity > 0) {
		//// Shadow Declarations
		NSColor* shadowColor = style.innerShadow.color;
		CGSize shadowOffset = style.innerShadow.offset;
		CGFloat shadowBlurRadius = style.innerShadow.radius;
		
		//// Shadow Declarations
		NSShadow* shadow = [[NSShadow alloc] init];
		[shadow setShadowColor: shadowColor];
		[shadow setShadowOffset: NSMakeSize(oppositeSign(shadowOffset.width), oppositeSign(shadowOffset.height))];
		[shadow setShadowBlurRadius: shadowBlurRadius];
		
		//// Rectangle Drawing
		NSBezierPath* rectanglePath = path;
		
		////// Rectangle Inner Shadow
		NSRect rectangleBorderRect = NSInsetRect([rectanglePath bounds], -shadow.shadowBlurRadius, -shadow.shadowBlurRadius);
		rectangleBorderRect = NSOffsetRect(rectangleBorderRect, -shadow.shadowOffset.width, -shadow.shadowOffset.height);
		rectangleBorderRect = NSInsetRect(NSUnionRect(rectangleBorderRect, [rectanglePath bounds]), -1, -1);
		
		NSBezierPath* rectangleNegativePath = [NSBezierPath bezierPathWithRect: rectangleBorderRect];
		[rectangleNegativePath appendBezierPath: rectanglePath];
		[rectangleNegativePath setWindingRule: NSEvenOddWindingRule];
		
		[NSGraphicsContext saveGraphicsState];
		{
			NSShadow* shadowWithOffset = [shadow copy];
			CGFloat xOffset = shadowWithOffset.shadowOffset.width + round(rectangleBorderRect.size.width);
			CGFloat yOffset = shadowWithOffset.shadowOffset.height;
			shadowWithOffset.shadowOffset = NSMakeSize(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
			[shadowWithOffset set];
			[[NSColor grayColor] setFill];
			[rectanglePath addClip];
			NSAffineTransform* transform = [NSAffineTransform transform];
			[transform translateXBy: -round(rectangleBorderRect.size.width) yBy: 0];
			[[transform transformBezierPath: rectangleNegativePath] fill];
		}
		[NSGraphicsContext restoreGraphicsState];
		
		
		
		
	}
	
	CGFloat currentY = baseY;
	for (int x = 0; x < style.bottomInnerBorders.count; x++) {
		DPStyleInnerBorder *innerBorder = style.bottomInnerBorders[x];
		
		
		
		NSColor* shadowColor = innerBorder.color.color;
		CGSize shadowOffset = CGSizeMake(0, -innerBorder.height);
		CGFloat shadowBlurRadius = 0;
		
		//// Shadow Declarations
		NSShadow* shadow = [[NSShadow alloc] init];
		[shadow setShadowColor: shadowColor];
		[shadow setShadowOffset: NSMakeSize(oppositeSign(shadowOffset.width), oppositeSign(shadowOffset.height))];
		[shadow setShadowBlurRadius: shadowBlurRadius];
		
		//// Rectangle Drawing
		NSBezierPath* rectanglePath = path;
		
		////// Rectangle Inner Shadow
		NSRect rectangleBorderRect = NSInsetRect([rectanglePath bounds], -shadow.shadowBlurRadius, -shadow.shadowBlurRadius);
		rectangleBorderRect = NSOffsetRect(rectangleBorderRect, -shadow.shadowOffset.width, -shadow.shadowOffset.height);
		rectangleBorderRect = NSInsetRect(NSUnionRect(rectangleBorderRect, [rectanglePath bounds]), -1, -1);
		
		NSBezierPath* rectangleNegativePath = [NSBezierPath bezierPathWithRect: rectangleBorderRect];
		[rectangleNegativePath appendBezierPath: rectanglePath];
		[rectangleNegativePath setWindingRule: NSEvenOddWindingRule];
		
		[NSGraphicsContext saveGraphicsState];
		{
			CGContextSetBlendMode(context, innerBorder.blendMode);
			
			NSShadow* shadowWithOffset = [shadow copy];
			CGFloat xOffset = shadowWithOffset.shadowOffset.width + round(rectangleBorderRect.size.width);
			CGFloat yOffset = shadowWithOffset.shadowOffset.height;
			shadowWithOffset.shadowOffset = NSMakeSize(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
			[shadowWithOffset set];
			[[NSColor grayColor] setFill];
			[rectanglePath addClip];
			NSAffineTransform* transform = [NSAffineTransform transform];
			[transform translateXBy: -round(rectangleBorderRect.size.width) yBy: 0];
			[[transform transformBezierPath: rectangleNegativePath] fill];
		}
		[NSGraphicsContext restoreGraphicsState];
		
		
		//            CGRect border = CGRectMake(baseX, currentY, size.width, innerBorder.height);
		//            [innerBorder.color.color setFill];
		//			[NSGraphicsContext saveGraphicsState];
		//			CGContextSetBlendMode(context, innerBorder.blendMode);
		//            CGContextFillRect(context, border);
		//            [NSGraphicsContext restoreGraphicsState];
		currentY += innerBorder.height;
	}
	
	if (style.topInnerBorders.count > 0) {
		currentY = size.height - baseY;
		for (int x = 0; x < style.topInnerBorders.count; x++) {
			DPStyleInnerBorder *innerBorder = style.topInnerBorders[x];
			currentY -= innerBorder.height;
			
			
			NSColor* shadowColor = innerBorder.color.color;
			CGSize shadowOffset = CGSizeMake(0, innerBorder.height);
			CGFloat shadowBlurRadius = 0;
			
			//// Shadow Declarations
			NSShadow* shadow = [[NSShadow alloc] init];
			[shadow setShadowColor: shadowColor];
			[shadow setShadowOffset: NSMakeSize(oppositeSign(shadowOffset.width), oppositeSign(shadowOffset.height))];
			[shadow setShadowBlurRadius: shadowBlurRadius];
			
			//// Rectangle Drawing
			NSBezierPath* rectanglePath = path;
			
			////// Rectangle Inner Shadow
			NSRect rectangleBorderRect = NSInsetRect([rectanglePath bounds], -shadow.shadowBlurRadius, -shadow.shadowBlurRadius);
			rectangleBorderRect = NSOffsetRect(rectangleBorderRect, -shadow.shadowOffset.width, -shadow.shadowOffset.height);
			rectangleBorderRect = NSInsetRect(NSUnionRect(rectangleBorderRect, [rectanglePath bounds]), -1, -1);
			
			NSBezierPath* rectangleNegativePath = [NSBezierPath bezierPathWithRect: rectangleBorderRect];
			[rectangleNegativePath appendBezierPath: rectanglePath];
			[rectangleNegativePath setWindingRule: NSEvenOddWindingRule];
			
			[NSGraphicsContext saveGraphicsState];
			{
				CGContextSetBlendMode(context, innerBorder.blendMode);
				
				NSShadow* shadowWithOffset = [shadow copy];
				CGFloat xOffset = shadowWithOffset.shadowOffset.width + round(rectangleBorderRect.size.width);
				CGFloat yOffset = shadowWithOffset.shadowOffset.height;
				shadowWithOffset.shadowOffset = NSMakeSize(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
				[shadowWithOffset set];
				[[NSColor grayColor] setFill];
				[rectanglePath addClip];
				NSAffineTransform* transform = [NSAffineTransform transform];
				[transform translateXBy: -round(rectangleBorderRect.size.width) yBy: 0];
				[[transform transformBezierPath: rectangleNegativePath] fill];
			}
			[NSGraphicsContext restoreGraphicsState];
		}
	}
	
    if (style.strokeWidth > 0) {
		
		CGRect strokeRect = CGRectMake(rect.origin.x + (style.strokeWidth/2), rect.origin.y + (style.strokeWidth/2), rect.size.width-style.strokeWidth, rect.size.height-style.strokeWidth);
		NSBezierPath *strokePath = [NSBezierPath bezierPathWithOvalInRect:strokeRect];
		[strokePath setLineWidth:style.strokeWidth];
		[style.strokeColor.color setStroke];
		[strokePath stroke];
	}
    [NSGraphicsContext restoreGraphicsState];
}

@end
