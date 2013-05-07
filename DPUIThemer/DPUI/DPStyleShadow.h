//
//  DPStyleShadow.h
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import <Foundation/Foundation.h>

@interface DPStyleShadow : NSObject

@property (nonatomic, strong) NSColor *color;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGSize offset;
@property (nonatomic) CGFloat opacity;


@property (nonatomic) CGFloat xOffset;
@property (nonatomic) CGFloat yOffset;

- (void)addShadowToView:(NSView*)view;

- (id)jsonValue;

- (id)initWithDictionary:(NSDictionary*)dictionary;

@end
