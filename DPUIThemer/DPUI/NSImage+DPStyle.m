//
//  NSImage+DPStyle.m
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import "NSImage+DPStyle.h"
#import "DPImageStyle.h"
#import "DPStyleManager.h"
@implementation NSImage (DPStyle)

+ (CGImageRef)createMaskFromAlphaChannel:(NSImage *)image
{
	size_t width = image.size.width;
	size_t height = image.size.height;
    
	NSMutableData *data = [NSMutableData dataWithLength:width*height];
    CGImageRef maskRef = [image CGImageForProposedRect:nil context:nil hints:nil];
	CGContextRef context = CGBitmapContextCreate(
                                                 [data mutableBytes], width, height, 8, width, NULL, kCGImageAlphaOnly);
    
	// Set the blend mode to copy to avoid any alteration of the source data
	CGContextSetBlendMode(context, kCGBlendModeCopy);
    
	// Draw the image to extract the alpha channel
	CGContextDrawImage(context, CGRectMake(0.0, 0.0, width, height), maskRef);
	CGContextRelease(context);
    
	CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((__bridge CFMutableDataRef)data);

    CGImageRef maskingImage = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        8,
                                        CGImageGetBitsPerPixel(maskRef),
                                        width,
                                        CGImageGetDataProvider(maskRef), NULL, false);
    CGDataProviderRelease(dataProvider);
    
	return maskingImage;
}

@end
