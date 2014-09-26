//
//  NSBezierPath+GTMBezierPathRoundRectAdditions.m
//  DPUIThemer
//
//  Created by Dan Pourhadi on 5/3/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import "NSBezierPath+GTMBezierPathRoundRectAdditions.h"

@implementation NSBezierPath (GTMBezierPathRoundRectAdditions)


+ (NSBezierPath *)gtm_bezierPathWithRoundRect:(NSRect)rect
                                 cornerRadius:(CGFloat)radius {
	NSBezierPath *bezier = [NSBezierPath bezierPath];
	[bezier gtm_appendBezierPathWithRoundRect:rect cornerRadius:radius];
	return bezier;
}

+ (NSBezierPath *)gtm_bezierPathWithRoundRect:(NSRect)rect
                          topLeftCornerRadius:(CGFloat)radiusTL
                         topRightCornerRadius:(CGFloat)radiusTR
                       bottomLeftCornerRadius:(CGFloat)radiusBL
                      bottomRightCornerRadius:(CGFloat)radiusBR {
	NSBezierPath *bezier = [NSBezierPath bezierPath];
	[bezier gtm_appendBezierPathWithRoundRect:rect
						  topLeftCornerRadius:radiusTL
						 topRightCornerRadius:radiusTR
					   bottomLeftCornerRadius:radiusBL
					  bottomRightCornerRadius:radiusBR];
	return bezier;
}

- (void)gtm_appendBezierPathWithRoundRect:(NSRect)rect
                             cornerRadius:(CGFloat)radius {
	if (radius > 0.0) {
		// Clamp radius to be no larger than half the rect's width or height.
		radius = MIN(radius, 0.5 * MIN(rect.size.width, rect.size.height));
		
		[self gtm_appendBezierPathWithRoundRect:rect
							topLeftCornerRadius:radius
						   topRightCornerRadius:radius
						 bottomLeftCornerRadius:radius
						bottomRightCornerRadius:radius];
	} else {
		// When radius <= 0.0, use plain rectangle.
		[self appendBezierPathWithRect:rect];
	}
}

- (void)gtm_appendBezierPathWithRoundRect:(NSRect)rect
                      topLeftCornerRadius:(CGFloat)radiusTL
                     topRightCornerRadius:(CGFloat)radiusTR
                   bottomLeftCornerRadius:(CGFloat)radiusBL
                  bottomRightCornerRadius:(CGFloat)radiusBR {
	// Clamp radii to be at least zero. I'd like to clamp both TL+TR and BL+BR to
	// be less than the width and TL+BL and TR+BR to be less than the height, but
	// what to do if they're not? Do we scale them both evenly?
	radiusTL = MAX(0, radiusTL);
	radiusTR = MAX(0, radiusTR);
	radiusBL = MAX(0, radiusBL);
	radiusBR = MAX(0, radiusBR);

	if (!NSIsEmptyRect(rect)) {
		NSPoint topLeft = NSMakePoint(NSMinX(rect), NSMaxY(rect));
		NSPoint topRight = NSMakePoint(NSMaxX(rect), NSMaxY(rect));
		NSPoint bottomRight = NSMakePoint(NSMaxX(rect), NSMinY(rect));
		
		[self moveToPoint:NSMakePoint(NSMidX(rect), NSMaxY(rect))];
		
		
		[self appendBezierPathWithArcFromPoint:topLeft
									   toPoint:rect.origin
										radius:radiusTL];
		[self appendBezierPathWithArcFromPoint:rect.origin
									   toPoint:bottomRight
										radius:radiusBL];
		[self appendBezierPathWithArcFromPoint:bottomRight
									   toPoint:topRight
										radius:radiusBR];
		[self appendBezierPathWithArcFromPoint:topRight
									   toPoint:topLeft
										radius:radiusTR];
		 
		[self closePath];
	}
}
- (CGPathRef)quartzPath
{
    int i, numElements;
	
    // Need to begin a path here.
    CGPathRef           immutablePath = NULL;
	
    // Then draw the path elements.
    numElements = [self elementCount];
    if (numElements > 0)
    {
        CGMutablePathRef    path = CGPathCreateMutable();
        NSPoint             points[3];
        BOOL                didClosePath = YES;
		
        for (i = 0; i < numElements; i++)
        {
            switch ([self elementAtIndex:i associatedPoints:points])
            {
                case NSMoveToBezierPathElement:
                    CGPathMoveToPoint(path, NULL, points[0].x, points[0].y);
                    break;
					
                case NSLineToBezierPathElement:
                    CGPathAddLineToPoint(path, NULL, points[0].x, points[0].y);
                    didClosePath = NO;
                    break;
					
                case NSCurveToBezierPathElement:
                    CGPathAddCurveToPoint(path, NULL, points[0].x, points[0].y,
										  points[1].x, points[1].y,
										  points[2].x, points[2].y);
                    didClosePath = NO;
                    break;
					
                case NSClosePathBezierPathElement:
                    CGPathCloseSubpath(path);
                    didClosePath = YES;
                    break;
            }
        }
		
        // Be sure the path is closed or Quartz may not do valid hit detection.
        if (!didClosePath)
            CGPathCloseSubpath(path);
		
        immutablePath = CGPathCreateCopy(path);
        CGPathRelease(path);
    }
	
    return immutablePath;
}


@end