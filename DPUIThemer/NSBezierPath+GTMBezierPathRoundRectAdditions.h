//
//  NSBezierPath+GTMBezierPathRoundRectAdditions.h
//  DPUIThemer
//
//  Created by Dan Pourhadi on 5/3/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
typedef NS_OPTIONS(NSUInteger, UIRectCorner) {
    UIRectCornerTopLeft     = 1 << 0,
    UIRectCornerTopRight    = 1 << 1,
    UIRectCornerBottomLeft  = 1 << 2,
    UIRectCornerBottomRight = 1 << 3,
    UIRectCornerAllCorners  = ~0UL
};
@interface NSBezierPath (GTMBezierPathRoundRectAdditions)

///  Inscribe a round rectangle inside of rectangle |rect| with a corner radius of |radius|
//
//  Args:
//    rect: outer rectangle to inscribe into
//    radius: radius of the corners. |radius| is clamped internally
//            to be no larger than the smaller of half |rect|'s width or height
//
//  Returns:
//    Auto released NSBezierPath
+ (NSBezierPath *)gtm_bezierPathWithRoundRect:(NSRect)rect
                                 cornerRadius:(CGFloat)radius;

///  Inscribe a round rectangle inside of rectangle |rect| with corner radii specified
//
//  Args:
//    rect: outer rectangle to inscribe into
//    radius*: radii of the corners
//
//  Returns:
//    Auto released NSBezierPath
+ (NSBezierPath *)gtm_bezierPathWithRoundRect:(NSRect)rect
                          topLeftCornerRadius:(CGFloat)radiusTL
                         topRightCornerRadius:(CGFloat)radiusTR
                       bottomLeftCornerRadius:(CGFloat)radiusBL
                      bottomRightCornerRadius:(CGFloat)radiusBR;

///  Adds a path which is a round rectangle inscribed inside of rectangle |rect| with a corner radius of |radius|
//
//  Args:
//    rect: outer rectangle to inscribe into
//    radius: radius of the corners. |radius| is clamped internally
//            to be no larger than the smaller of half |rect|'s width or height
- (void)gtm_appendBezierPathWithRoundRect:(NSRect)rect
                             cornerRadius:(CGFloat)radius;

///  Adds a path which is a round rectangle inscribed inside of rectangle |rect| with a corner radii specified
//
//  Args:
//    rect: outer rectangle to inscribe into
//    radius*: radii of the corners
- (void)gtm_appendBezierPathWithRoundRect:(NSRect)rect
                      topLeftCornerRadius:(CGFloat)radiusTL
                     topRightCornerRadius:(CGFloat)radiusTR
                   bottomLeftCornerRadius:(CGFloat)radiusBL
                  bottomRightCornerRadius:(CGFloat)radiusBR;
@end
