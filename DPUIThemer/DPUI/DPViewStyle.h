//
//  DPViewStyle.h
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import <Foundation/Foundation.h>
#import "DPStyleObject.h"
#import "DPStyleBackground.h"
#import "DPStyleInnerBorder.h"
#import "DPStyleShadow.h"
@interface DPViewStyle : DPStyleObject

@property (nonatomic, strong) DPStyleBackground *background;

@property (nonatomic, strong) NSArray *topInnerBorders; // DPStyleInnerBorder objects
@property (nonatomic, strong) NSArray *bottomInnerBorders; // DPStyleInnerBorder objects

@property (nonatomic, strong) DPStyleShadow *shadow;
@property (nonatomic, strong) DPStyleShadow *innerShadow; // will be placed underneath inner borders

@property (nonatomic) CGSize cornerRadii;

//@property (nonatomic) NSBezierPath roundedCorners;
@property (nonatomic) BOOL clipCorners; // clip the view's contents to the rounded corners

- (void)applyStyleToView:(NSView*)view;
@end
