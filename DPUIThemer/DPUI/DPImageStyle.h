//
//  DPImageStyle.h
//  TheQ
//
//  Created by Daniel Pourhadi on 4/29/13.
//
//

#import <Foundation/Foundation.h>
#import "DPStyleObject.h"
#import "DPStyleBackground.h"
#import "DPStyleShadow.h"
#import "DPStyleInnerBorder.h"

static NSString *kDYN_OVERLAY_KEY = @"overlay";
static NSString *kDYN_STROKE_WIDTH_KEY = @"strokeWidth";
static NSString *kDYN_STROKE_COLOR_KEY = @"strokeColor";
static NSString *kDYN_BG_COLORS_KEY = @"bgColors";
static NSString *kDYN_GRADIENT_ANGLE_KEY = @"gradientAngle";
static NSString *kDYN_CANVAS_BACKGROUND_TYPE_KEY = @"canvasBackgroundType";
static NSString *kDYN_CANVAS_BACKGROUND_COLOR_KEY = @"canvasBackgroundColor";
static NSString *kDYN_TOP_INNER_BORDERS_KEY = @"topInnerBorders";
static NSString *kDYN_BOTTOM_INNER_BORDERS_KEY = @"bottomInnerBorders";
static NSString *kDYN_INNER_SHADOW_KEY = @"innerShadow";
static NSString *kDYN_OUTER_SHADOW_KEY = @"outerShadow";


@interface DPImageStyle : DPStyleObject

@property (nonatomic, strong) DPStyleBackground *overlay;

@property (nonatomic) CGFloat strokeWidth;
@property (nonatomic, strong) DPStyleColor *strokeColor;

@property (nonatomic, strong) NSMutableArray *bgColors;
@property (nonatomic) CGFloat gradientAngle;

@property (nonatomic, strong) NSString *canvasBackgroundType;
@property (nonatomic, strong) NSColor *canvasBackgroundColor;

@property (nonatomic, strong) NSMutableArray *topInnerBorders;
@property (nonatomic, strong) NSMutableArray *bottomInnerBorders;

@property (nonatomic, strong) DPStyleShadow *innerShadow;
@property (nonatomic, strong) DPStyleShadow *outerShadow; // equal padding on all four sides of the image will be added to accomodate the shadow while keeping the image centered in the frame

- (id)initWithDictionary:(NSDictionary*)dictionary;
- (id)jsonValue;

@end
