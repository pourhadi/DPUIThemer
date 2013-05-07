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
    }
    
    return self;
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
    
	CGSize size = dirtyRect.size;
	
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];

    NSBezierPath *path;
    
    if (!CGSizeEqualToSize(self.style.cornerRadii, CGSizeZero)) {
		
		CGFloat tl = ((self.style.roundedCorners & UIRectCornerTopLeft) > 0 ? self.style.cornerRadius : 0);
		CGFloat tr = ((self.style.roundedCorners & UIRectCornerTopRight) > 0 ? self.style.cornerRadius : 0);
		CGFloat bl = ((self.style.roundedCorners & UIRectCornerBottomLeft) > 0 ? self.style.cornerRadius : 0);
		CGFloat br = ((self.style.roundedCorners & UIRectCornerBottomRight) > 0 ? self.style.cornerRadius : 0);
		path = [NSBezierPath gtm_bezierPathWithRoundRect:dirtyRect topLeftCornerRadius:tl topRightCornerRadius:tr bottomLeftCornerRadius:bl bottomRightCornerRadius:br];
		
		//NSLog(@"tl: %f, tr: %f, bl: %f, br: %f", tl, tr, bl, br);
		
		//   path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:self.style.cornerRadii.width yRadius:self.style.cornerRadii.height];
    } else {
        path = [NSBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
    }

        [path addClip];
	//CGContextTranslateCTM(context, 0.0f, size.height);
	//CGContextScaleCTM(context, 1.0f, -1.0f);
        if (self.style.bgColors.count > 1) {
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
            
            CGContextDrawLinearGradient(context, gradient, CGPointMake(0.5*size.width, 1*size.height), CGPointMake(0.5*size.width, 0*size.height), 0);
		} else if (self.style.bgColors.count > 0){
            NSColor *fill = [self.style.bgColors[0] color];
            [fill setFill];
            [path fill];
        }
        
        if (self.style.innerShadow.opacity > 0) {
            //// Shadow Declarations
            NSColor* shadowColor = self.style.innerShadow.color;
            CGSize shadowOffset = self.style.innerShadow.offset;
            CGFloat shadowBlurRadius = self.style.innerShadow.radius;
            
            //// Shadow Declarations
			NSShadow* shadow = [[NSShadow alloc] init];
			[shadow setShadowColor: shadowColor];
			[shadow setShadowOffset: NSMakeSize(shadowOffset.width, shadowOffset.height)];
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
        
        CGFloat currentY = 0;
        for (int x = 0; x < self.style.bottomInnerBorders.count; x++) {
            DPStyleInnerBorder *innerBorder = self.style.bottomInnerBorders[x];
            CGRect border = CGRectMake(0, currentY, size.width, innerBorder.height);
            [innerBorder.color.color setFill];
            CGContextFillRect(context, border);
            
            currentY += innerBorder.height;
        }
        
        if (self.style.topInnerBorders.count > 0) {
            currentY = size.height;
            for (int x = 0; x < self.style.topInnerBorders.count; x++) {
                DPStyleInnerBorder *innerBorder = self.style.topInnerBorders[x];
                currentY -= innerBorder.height;
                CGRect border = CGRectMake(0, currentY, size.width, innerBorder.height);
                [innerBorder.color.color setFill];
                CGContextFillRect(context, border);
            }
        }
        
        
    
    
    if (self.style.shadow.opacity > 0) {
		self.shadow = nil;
        self.layer.masksToBounds = NO;
        [self.style.shadow addShadowToView:self];
        
    } else {
		self.shadow = nil;
	}
    
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
