//
//  NSImage+DPStyle.h
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import <Cocoa/Cocoa.h>
typedef void (^DPStyleDrawImageBlock)(CGContextRef context, CGSize size);
@interface NSImage (DPStyle)
+ (NSImage*)imageWithSize:(CGSize)size drawnWithBlock:(DPStyleDrawImageBlock)block;;

+ (CGImageRef)createMaskFromAlphaChannel:(NSImage *)image;
@end
