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

- (void)drawRect:(NSRect)dirtyRect
{
	//NSLog(@"%@", NSStringFromRect(dirtyRect));
	CGFloat width = self.xScale * dirtyRect.size.width;
	CGFloat height = self.yScale * dirtyRect.size.height;
	CGFloat baseX = (dirtyRect.size.width - width) / 2;
	CGFloat baseY = (dirtyRect.size.height - height) / 2;
    NSRect newRect = NSMakeRect(baseX, baseY, width, height);
	CGSize size = newRect.size;
	//NSLog(@"%@", NSStringFromRect(newRect));

    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];

    NSBezierPath *path;
    
    if (!CGSizeEqualToSize(self.style.cornerRadii, CGSizeZero)) {
		
		CGFloat tl = ((self.style.roundedCorners & UIRectCornerTopLeft) > 0 ? self.style.cornerRadius : 0);
		CGFloat tr = ((self.style.roundedCorners & UIRectCornerTopRight) > 0 ? self.style.cornerRadius : 0);
		CGFloat bl = ((self.style.roundedCorners & UIRectCornerBottomLeft) > 0 ? self.style.cornerRadius : 0);
		CGFloat br = ((self.style.roundedCorners & UIRectCornerBottomRight) > 0 ? self.style.cornerRadius : 0);
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
		[path setLineWidth:self.style.strokeWidth*2];
		[self.style.strokeColor.color setStroke];
		[path stroke];
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
//    }
}

@end
