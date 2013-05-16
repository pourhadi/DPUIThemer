//
//  DPUIDocument.m
//  DPUIThemer
//
//  Created by Daniel Pourhadi on 4/30/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import "DPUIDocument.h"
#import "ColorCell.h"
#import "ColorTransformer.h"
#import "DPStyleManager.h"
#import <QuartzCore/QuartzCore.h>
static NSString *kGROUPED_TABLE_TOP_CELL_KEY = @"groupedTableTopCell";
static NSString *kGROUPED_TABLE_MIDDLE_CELL_KEY = @"groupedTableMiddleCell";
static NSString *kGROUPED_TABLE_SINGLE_CELL_KEY = @"groupedTableSingleCell";
static NSString *kGROUPED_TABLE_BOTTOM_CELL_KEY = @"groupedTableBottomCell";
@implementation DYNMoreOption



@end
@implementation DPUIStyle
@synthesize strokeWidth = _strokeWidth;

- (id)initWithDictionary:(NSDictionary*)style
{
	self = [super init];
	if (self) {
		DPUIStyle *new = self;
		
		new.styleName = [style objectForKey:@"name"];
		NSDictionary *bg = [style objectForKey:@"background"];
        
		//        new.startX = [[bg objectForKey:@"startPointX"] floatValue];
		//        new.startY = [[bg objectForKey:@"startPointY"] floatValue];
		//        new.endX = [[bg objectForKey:@"endPointX"] floatValue];
		//        new.endY = [[bg objectForKey:@"endPointY"] floatValue];
        
        new.gradientAngle = [[bg objectForKey:@"gradientAngle"] floatValue];
        
		NSArray *colors = [bg objectForKey:@"colors"];
		NSMutableArray *tmp = [NSMutableArray new];
		
		for (NSDictionary *color in colors ) {
			[tmp addObject:[[DPStyleColor alloc] initWithDictionary:color]];
		}
		new.bgColors = tmp;
		
		tmp = [NSMutableArray new];
		NSArray *top = [style objectForKey:@"topInnerBorders"];
		for (NSDictionary *border in top) {
			[tmp addObject:[[DPStyleInnerBorder alloc] initWithDictionary:border]];
		}
		new.topInnerBorders = tmp;
		tmp = [NSMutableArray new];
		NSArray *bottom = [style objectForKey:@"bottomInnerBorders"];
		for (NSDictionary *border in bottom) {
			[tmp addObject:[[DPStyleInnerBorder alloc] initWithDictionary:border]];
		}
		new.bottomInnerBorders = tmp;
		
        tmp = [NSMutableArray new];
		NSArray *left = [style objectForKey:@"leftInnerBorders"];
		for (NSDictionary *border in left) {
			[tmp addObject:[[DPStyleInnerBorder alloc] initWithDictionary:border]];
		}
		new.leftInnerBorders = tmp;
        
        tmp = [NSMutableArray new];
		NSArray *right = [style objectForKey:@"rightInnerBorders"];
		for (NSDictionary *border in right) {
			[tmp addObject:[[DPStyleInnerBorder alloc] initWithDictionary:border]];
		}
		new.rightInnerBorders = tmp;
        
		new.shadow = [[DPStyleShadow alloc] initWithDictionary:[style objectForKey:@"shadow"]];
		new.innerShadow = [[DPStyleShadow alloc] initWithDictionary:[style objectForKey:@"innerShadow"]];
		
		new.roundedCorners = [[style objectForKey:@"roundedCorners"] unsignedIntegerValue];
		new.cornerRadius = [[style objectForKey:@"cornerRadius"] floatValue];
		
		new.canvasBackgroundType = [style objectForKey:@"canvasBackgroundType"];
		new.canvasBackgroundColor = [ColorTransformer colorFromString:[style objectForKey:@"canvasBackgroundColor"]];
		
		if ([style objectForKey:@"tableCellTitleTextStyle"]) {
			new.tableCellTitleTextStyle = [[DPUITextStyle alloc] initWithDictionary:[style objectForKey:@"tableCellTitleTextStyle"]];
		}
		if ([style objectForKey:@"tableCellDetailTextStyle"]){
			new.tableCellDetailTextStyle = [[DPUITextStyle alloc] initWithDictionary:[style objectForKey:@"tableCellDetailTextStyle"]];
		}
		if ([style objectForKey:@"navBarTitleTextStyle"]) {
			new.navBarTitleTextStyle = [[DPUITextStyle alloc] initWithDictionary:[style objectForKey:@"navBarTitleTextStyle"]];
		}
		
		if ([style objectForKey:@"barButtonItemStyleName"]) {
			new.barButtonItemStyleName = [style objectForKey:@"barButtonItemStyleName"];
		}
		
		if ([style objectForKey:@"strokeColor"]) {
			new.strokeColor = [[DPStyleColor alloc] initWithDictionary:[style objectForKey:@"strokeColor"]];
			new.strokeWidth = [[style objectForKey:@"strokeWidth"] floatValue];
		}
        
        if ([style objectForKey:@"controlStyle"]) {
            new.controlStyle = [[DPUIControlStyle alloc] initWithDictionary:[style objectForKey:@"controlStyle"]];
        }
        
        if ([style objectForKey:@"maskToCorners"]) {
            new.maskToCorners = [[style objectForKey:@"maskToCorners"] boolValue];
        }
		
		if ([style objectForKey:@"cornerRadiusType"]) {
			new.cornerRadiusType = [style objectForKey:@"cornerRadiusType"];
		}
		
		if ([style objectForKey:@"searchFieldStyleName"]) {
			new.searchBarTextFieldStyleName = [style objectForKey:@"searchFieldStyleName"];
		}
		
		if ([style objectForKey:@"searchFieldTextStyleName"]) {
			new.searchFieldTextStyleName = [style objectForKey:@"searchFieldTextStyleName"];
		}
        
        if ([style objectForKey:@"textFieldTextStyleName"]) {
            new.textFieldTextStyleName = [style objectForKey:@"textFieldTextStyleName"];
        }
		
		if ([style objectForKey:@"segmentedControlStyle"]) {
			new.segmentedControlStyle = [[DPUIControlStyle alloc] initWithDictionary:[style objectForKey:@"segmentedControlStyle"]];
		}
        
		if ([style objectForKey:@"segmentDividerColor"]) {
			new.segmentDividerColor = [[DPStyleColor alloc] initWithDictionary:[style objectForKey:@"segmentDividerColor"]];
		}
		
		if ([style objectForKey:@"segmentDividerWidth"]) {
			new.segmentDividerWidth = [[style objectForKey:@"segmentDividerWidth"] floatValue];
		}
		
        if ([style objectForKey:kGROUPED_TABLE_TOP_CELL_KEY]) {
            new.groupedTableTopCell = [style objectForKey:kGROUPED_TABLE_TOP_CELL_KEY];
        }
        if ([style objectForKey:kGROUPED_TABLE_BOTTOM_CELL_KEY]) {
            new.groupedTableBottomCell = [style objectForKey:kGROUPED_TABLE_BOTTOM_CELL_KEY];
        }
        if ([style objectForKey:kGROUPED_TABLE_MIDDLE_CELL_KEY]) {
            new.groupedTableMiddleCell = [style objectForKey:kGROUPED_TABLE_MIDDLE_CELL_KEY];
        }
        if ([style objectForKey:kGROUPED_TABLE_SINGLE_CELL_KEY]) {
            new.groupedTableSingleCell = [style objectForKey:kGROUPED_TABLE_SINGLE_CELL_KEY];
        }
		new.drawAsynchronously = [[style objectForKey:@"drawAsynchronously"] boolValue];

	}
	return self;
}
- (id)jsonValue
{
	DPUIStyle *style = self;
	
	NSMutableDictionary *dictionary = [NSMutableDictionary new];
	[dictionary setObject:style.styleName forKey:@"name"];
	NSMutableDictionary *bg = [NSMutableDictionary new];
	NSMutableArray *bgColors = [NSMutableArray new];
	for (DPStyleColor *color in style.bgColors) {
		[bgColors addObject:color.jsonValue];
	}
	// background
	[bg setObject:bgColors forKey:@"colors"];
	
	//        [bg setObject:@(style.startX) forKey:@"startPointX"];
	//        [bg setObject:@(style.startY) forKey:@"startPointY"];
	//        [bg setObject:@(style.endX) forKey:@"endPointX"];
	//        [bg setObject:@(style.endY) forKey:@"endPointY"];
	//
	[bg setObject:@(style.gradientAngle) forKey:@"gradientAngle"];
	
	[dictionary setObject:bg forKey:@"background"];
	
	// top inner borders
	NSArray *topinnerborders = [style.topInnerBorders valueForKeyPath:@"jsonValue"];
	[dictionary setObject:topinnerborders forKey:@"topInnerBorders"];
	
	// bottom inner borders
	NSArray *bottom = [style.bottomInnerBorders valueForKeyPath:@"jsonValue"];
	[dictionary setObject:bottom forKey:@"bottomInnerBorders"];
	
    NSArray *left = [style.leftInnerBorders valueForKeyPath:@"jsonValue"];
	[dictionary setObject:left forKey:@"leftInnerBorders"];
    
    NSArray *right = [style.rightInnerBorders valueForKeyPath:@"jsonValue"];
	[dictionary setObject:right forKey:@"rightInnerBorders"];
    
	//NSDictionary *cornerRadii = (__bridge NSDictionary *)(CGSizeCreateDictionaryRepresentation(style.cornerRadii));
	[dictionary setObject:@(style.cornerRadius) forKey:@"cornerRadius"];
	[dictionary setObject:@(style.roundedCorners) forKey:@"roundedCorners"];
	[dictionary setObject:style.innerShadow.jsonValue forKey:@"innerShadow"];
	[dictionary setObject:style.shadow.jsonValue forKey:@"shadow"];
	
	NSColor *canvasBgColor = [NSColor clearColor];
	if ([style.canvasBackgroundType isEqualToString:kBackgroundPreviewColor]) {
		//canvasBgColor = self.exampleContainerBgColor;
	} else if ([style.canvasBackgroundType isEqualToString:kBackgroundCustomColor]) {
		canvasBgColor = style.canvasBackgroundColor;
	} else if (!style.canvasBackgroundType) {
		style.canvasBackgroundType = kBackgroundTransparent;
	}
	
	[dictionary setObject:style.canvasBackgroundType forKey:@"canvasBackgroundType"];
	[dictionary setObject:[ColorTransformer stringFromColor:canvasBgColor] forKey:@"canvasBackgroundColor"];
	
	if (style.navBarTitleTextStyle) {
		[dictionary setObject:style.navBarTitleTextStyle.jsonValue forKey:@"navBarTitleTextStyle"];
	}
	
	if (style.tableCellTitleTextStyle) {
		[dictionary setObject:style.tableCellTitleTextStyle.jsonValue forKey:@"tableCellTitleTextStyle"];
	}
	
	if (style.tableCellDetailTextStyle) {
		[dictionary setObject:style.tableCellDetailTextStyle.jsonValue forKey:@"tableCellDetailTextStyle"];
	}
	
	
	if (style.barButtonItemStyleName) {
		[dictionary setObject:style.barButtonItemStyleName forKey:@"barButtonItemStyleName"];
	}
	
	if (style.strokeColor) {
		[dictionary setObject:style.strokeColor.jsonValue forKey:@"strokeColor"];
		[dictionary setObject:@(style.strokeWidth) forKey:@"strokeWidth"];
	}
	
	if (style.controlStyle) {
		[dictionary setObject:style.controlStyle.jsonValue forKey:@"controlStyle"];
	}
	
	[dictionary setObject:@(style.maskToCorners) forKey:@"maskToCorners"];
	
	[dictionary setObject:@(style.drawAsynchronously) forKey:@"drawAsynchronously"];
	
	if (style.cornerRadiusType) {
		[dictionary setObject:style.cornerRadiusType forKey:@"cornerRadiusType"];
	}
	
	if (style.searchBarTextFieldStyleName) {
		[dictionary setObject:style.searchBarTextFieldStyleName forKey:@"searchFieldStyleName"];
	}
	
	if (style.searchFieldTextStyleName) {
		[dictionary setObject:style.searchFieldTextStyleName forKey:@"searchFieldTextStyleName"];
	}
	
	if (style.textFieldTextStyleName) {
		[dictionary setObject:style.textFieldTextStyleName forKey:@"textFieldTextStyleName"];
	}
	
	if (style.segmentedControlStyle.selectedStyleName) {
		[dictionary setObject:style.segmentedControlStyle.jsonValue forKey:@"segmentedControlStyle"];
		
		[dictionary setObject:@(style.segmentDividerWidth) forKey:@"segmentDividerWidth"];
		[dictionary setObject:style.segmentDividerColor.jsonValue forKey:@"segmentDividerColor"];
	}
    
    if (style.groupedTableTopCell) {
        [dictionary setObject:style.groupedTableTopCell forKey:kGROUPED_TABLE_TOP_CELL_KEY];
    }
    
    if (style.groupedTableMiddleCell) {
        [dictionary setObject:style.groupedTableMiddleCell forKey:kGROUPED_TABLE_MIDDLE_CELL_KEY];
    }
    
    if (style.groupedTableBottomCell) {
        [dictionary setObject:style.groupedTableBottomCell forKey:kGROUPED_TABLE_BOTTOM_CELL_KEY];
    }
    
    if (style.groupedTableSingleCell) {
        [dictionary setObject:style.groupedTableSingleCell forKey:kGROUPED_TABLE_SINGLE_CELL_KEY];
    }
	    
	return dictionary;
}
//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.styleName forKey:@"styleName"];
    [encoder encodeObject:self.bgColors forKey:@"bgColors"];
    [encoder encodeInteger:self.bgDegrees forKey:@"bgDegrees"];
    [encoder encodeObject:self.topInnerBorders forKey:@"topInnerBorders"];
    [encoder encodeObject:self.bottomInnerBorders forKey:@"bottomInnerBorders"];
    [encoder encodeObject:self.innerShadow forKey:@"innerShadow"];
    [encoder encodeObject:self.shadow forKey:@"shadow"];
    [encoder encodeFloat:self.cornerRadius forKey:@"cornerRadius"];
	[encoder encodeInteger:self.roundedCorners forKey:@"roundedCorners"];
    [encoder encodeBool:self.maskToCorners forKey:@"maskToCorners"];
    [encoder encodeObject:self.canvasBackgroundType forKey:@"canvasBackgroundType"];
    [encoder encodeObject:self.canvasBackgroundColor forKey:@"canvasBackgroundColor"];
    [encoder encodeObject:self.topLeftValue forKey:@"topLeftValue"];
    [encoder encodeObject:self.topRightValue forKey:@"topRightValue"];
    [encoder encodeObject:self.bottomLeftValue forKey:@"bottomLeftValue"];
    [encoder encodeObject:self.bottomRightValue forKey:@"bottomRightValue"];
    [encoder encodeObject:self.strokeColor forKey:@"strokeColor"];
    [encoder encodeFloat:self.strokeWidth forKey:@"strokeWidth"];
    [encoder encodeBool:self.drawAsynchronously forKey:@"drawAsynchronously"];
    [encoder encodeObject:self.navBarTitleTextStyle forKey:@"navBarTitleTextStyle"];
    [encoder encodeObject:self.tableCellTitleTextStyle forKey:@"tableCellTitleTextStyle"];
    [encoder encodeObject:self.tableCellDetailTextStyle forKey:@"tableCellDetailTextStyle"];
    [encoder encodeObject:self.barButtonItemStyleName forKey:@"barButtonItemStyleName"];
    [encoder encodeObject:self.controlStyle forKey:@"controlStyle"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.styleName = [decoder decodeObjectForKey:@"styleName"];
        self.bgColors = [decoder decodeObjectForKey:@"bgColors"];
        self.bgDegrees = [decoder decodeIntegerForKey:@"bgDegrees"];
        self.topInnerBorders = [decoder decodeObjectForKey:@"topInnerBorders"];
        self.bottomInnerBorders = [decoder decodeObjectForKey:@"bottomInnerBorders"];
        self.innerShadow = [decoder decodeObjectForKey:@"innerShadow"];
        self.shadow = [decoder decodeObjectForKey:@"shadow"];
		// self.cornerRadii = [decoder decodeCGSizeForKey:@"cornerRadii"];
        self.cornerRadius = [decoder decodeFloatForKey:@"cornerRadius"];
		[self setRoundedCorners:[decoder decodeIntegerForKey:@"roundedCorners"]];
        self.maskToCorners = [decoder decodeBoolForKey:@"maskToCorners"];
        self.canvasBackgroundType = [decoder decodeObjectForKey:@"canvasBackgroundType"];
        self.canvasBackgroundColor = [decoder decodeObjectForKey:@"canvasBackgroundColor"];
        self.topLeftValue = [decoder decodeObjectForKey:@"topLeftValue"];
        self.topRightValue = [decoder decodeObjectForKey:@"topRightValue"];
        self.bottomLeftValue = [decoder decodeObjectForKey:@"bottomLeftValue"];
        self.bottomRightValue = [decoder decodeObjectForKey:@"bottomRightValue"];
        self.strokeColor = [decoder decodeObjectForKey:@"strokeColor"];
        self.strokeWidth = [decoder decodeFloatForKey:@"strokeWidth"];
        self.drawAsynchronously = [decoder decodeBoolForKey:@"drawAsynchronously"];
        self.navBarTitleTextStyle = [decoder decodeObjectForKey:@"navBarTitleTextStyle"];
        self.tableCellTitleTextStyle = [decoder decodeObjectForKey:@"tableCellTitleTextStyle"];
        self.tableCellDetailTextStyle = [decoder decodeObjectForKey:@"tableCellDetailTextStyle"];
        self.barButtonItemStyleName = [decoder decodeObjectForKey:@"barButtonItemStyleName"];
        self.controlStyle = [decoder decodeObjectForKey:@"controlStyle"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    id theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
    
    [theCopy setGradientAngle:self.gradientAngle];
    [theCopy setStyleName:[self.styleName copy]];
    [theCopy setBgColors:[self.bgColors copy]];
    [theCopy setBgLocations:[self.bgLocations copy]];
    [theCopy setBgDegrees:self.bgDegrees];
    [theCopy setTopInnerBorders:[self.topInnerBorders copy]];
    [theCopy setBottomInnerBorders:[self.bottomInnerBorders copy]];
    [theCopy setLeftInnerBorders:[self.leftInnerBorders copy]];
    [theCopy setRightInnerBorders:[self.rightInnerBorders copy]];
    [theCopy setInnerShadow:[self.innerShadow copy]];
    [theCopy setShadow:[self.shadow copy]];
    [theCopy setCornerRadii:self.cornerRadii];
    [theCopy setCornerRadius:self.cornerRadius];
    [theCopy setCornerRadiusType:[self.cornerRadiusType copy]];
    [theCopy setRoundedCorners:self.roundedCorners];
    [theCopy setMaskToCorners:self.maskToCorners];
    [theCopy setCanvasBackgroundType:[self.canvasBackgroundType copy]];
    [theCopy setCanvasBackgroundColor:[self.canvasBackgroundColor copy]];
    [theCopy setTopLeftValue:[self.topLeftValue copy]];
    [theCopy setTopRightValue:[self.topRightValue copy]];
    [theCopy setBottomLeftValue:[self.bottomLeftValue copy]];
    [theCopy setBottomRightValue:[self.bottomRightValue copy]];
    [theCopy setStrokeColor:[self.strokeColor copy]];
    [theCopy setStrokeWidth:self.strokeWidth];
    [theCopy setDrawAsynchronously:self.drawAsynchronously];
    [theCopy setStartX:self.startX];
    [theCopy setStartY:self.startY];
    [theCopy setEndX:self.endX];
    [theCopy setEndY:self.endY];
    [theCopy setSearchBarTextFieldStyleName:[self.searchBarTextFieldStyleName copy]];
    [theCopy setSearchFieldTextStyleName:[self.searchFieldTextStyleName copy]];
    [theCopy setNavBarTitleTextStyle:[self.navBarTitleTextStyle copy]];
    [theCopy setTableCellTitleTextStyle:[self.tableCellTitleTextStyle copy]];
    [theCopy setTableCellDetailTextStyle:[self.tableCellDetailTextStyle copy]];
    [theCopy setTableCellSelectedStyleName:[self.tableCellSelectedStyleName copy]];
    [theCopy setBarButtonItemStyleName:[self.barButtonItemStyleName copy]];
    [theCopy setControlStyle:[self.controlStyle copy]];
    [theCopy setTextFieldTextStyleName:[self.textFieldTextStyleName copy]];
    [theCopy setSegmentedControlStyle:[self.segmentedControlStyle copy]];
    [theCopy setSegmentDividerWidth:self.segmentDividerWidth];
    [theCopy setSegmentDividerColor:[self.segmentDividerColor copy]];
    [theCopy setGroupedTableTopCell:[self.groupedTableTopCell copy]];
    [theCopy setGroupedTableMiddleCell:[self.groupedTableMiddleCell copy]];
    [theCopy setGroupedTableSingleCell:[self.groupedTableSingleCell copy]];
    [theCopy setGroupedTableBottomCell:[self.groupedTableBottomCell copy]];
    
    return theCopy;

}
- (id)init
{
	self = [super init];
	if (self) {
		self.bgColors = [NSMutableArray new];
		DPStyleColor *color = [[DPStyleColor alloc] init];
		[self.bgColors addObject:color];
		self.topInnerBorders = [NSMutableArray new];
		self.bottomInnerBorders = [NSMutableArray new];
        self.leftInnerBorders = [NSMutableArray new];
        self.rightInnerBorders = [NSMutableArray new];
		self.innerShadow = [[DPStyleShadow alloc] init];
		self.shadow = [[DPStyleShadow alloc] init];
		self.bgDegrees = 0;
        self.styleName = [DPUIStyle newStyleVariableName];
		self.canvasBackgroundColor = [NSColor clearColor];
		self.strokeWidth = 0;
		self.strokeColor = [[DPStyleColor alloc] init];
        self.controlStyle = [[DPUIControlStyle alloc] init];
        self.controlStyle.superStyleName = self.styleName;
		self.canvasBackgroundType = @"Transparent";
		self.startX = 0.5;
		self.startY = 0;
		self.endX = 0.5;
		self.endY = 1;
        self.gradientAngle = 180;
		self.segmentedControlStyle = [[DPUIControlStyle alloc] init];
		self.segmentDividerColor = [[DPStyleColor alloc] init];
		self.segmentDividerWidth = 1;
		//self.navBarTitleTextStyle = [[DPUITextStyle alloc] init];
		//self.tableCellTitleTextStyle = [[DPUITextStyle alloc] init];
		//self.tableCellDetailTextStyle = [[DPUITextStyle alloc] init];
	}
	return self;
}

- (void)setStyleName:(NSString *)styleName
{
    [self willChangeValueForKey:@"styleName"];
    _styleName = styleName;
    [self didChangeValueForKey:@"styleName"];
    
    self.controlStyle.superStyleName = styleName;
}

- (void)setStrokeWidth:(CGFloat)strokeWidth
{
	[self willChangeValueForKey:@"strokeWidth"];
	_strokeWidth = strokeWidth*2;
	[self didChangeValueForKey:@"strokeWidth"];
}

- (CGFloat)strokeWidth
{
	return _strokeWidth/2;
}

+ (NSString*)newStyleVariableName
{
	NSInteger x = 1;
	BOOL found = NO;
	NSString *name;
	
	while (!found) {
		
		name = [NSString stringWithFormat:@"Style%ld", (long)x];
		if (![[[DPStyleManager sharedInstance] styleNames] containsObject:name]) {
			found = YES;
		} else {
			x += 1;
		}
		
	}
	
	return name;
}

- (CGSize)cornerRadii
{
	return CGSizeMake(self.cornerRadius/2, self.cornerRadius/2);
}

- (NSNumber*)bottomLeftValue
{
	return @(((self.roundedCorners & UIRectCornerBottomLeft) == UIRectCornerBottomLeft) ? YES : NO);
}

- (NSNumber*)bottomRightValue
{
	return @(((self.roundedCorners & UIRectCornerBottomRight) == UIRectCornerBottomRight) ? YES : NO);
}

- (NSNumber*)topLeftValue
{
	return @(((self.roundedCorners & UIRectCornerTopLeft) == UIRectCornerTopLeft) ? YES: NO);
}

- (NSNumber*)topRightValue
{
	return @(((self.roundedCorners & UIRectCornerTopRight) == UIRectCornerTopRight) ? YES : NO);
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key NS_AVAILABLE(10_5, 2_0)
{
	NSSet *current = [super keyPathsForValuesAffectingValueForKey:key];
	NSMutableSet *new = [current mutableCopy];
	if ([key isEqualToString:@"bottomLeftValue"] || [key isEqualToString:@"bottomRightValue"] || [key isEqualToString:@"topLeftValue"] || [key isEqualToString:@"topRightValue"]) {
		
		[new addObject:@"roundedCorners"];
		
	}
	
	return new;
}




@end

@interface DPUIDocument ()
{
	NSUInteger colorRow_;
}
@property (nonatomic, strong) NSTimer *updateTimer;
@property (nonatomic, strong) ColorCell *backgroundColorCell;
@property (nonatomic, strong) ColorCell *topInnerBorderColorCell;
@property (nonatomic, strong) ColorCell *bottomInnerBorderColorCell;

@property (nonatomic, assign) NSTableView* selectedColorCell;

@property (nonatomic, weak) IBOutlet NSView *customView;
@property (nonatomic, weak) IBOutlet NSView *mainView;

@property (nonatomic, strong) DPUIStyle *flippedStyle;
@end

@implementation DPUIDocument
//===========================================================
// - (NSArray *)keyPaths
//
//===========================================================
- (NSArray *)keyPaths
{
    NSArray *result = [NSArray arrayWithObjects:
					   @"exampleView",
					   @"textExampleView",
					   @"style",
					   @"stylesController",
					   @"textStylesController",
					   @"styleTable",
					   @"colorTable",
					   @"backgroundColorsTable",
					   @"topInnerBorderTable",
					   @"bottomInnerBorderTable",
					   @"colorVars",
					   @"colorAndParamVars",
					   @"currentStyle",
					   @"topLeftCorner",
					   @"topRightCorner",
					   @"bottomLeftCorner",
					   @"bottomRightCorner",
					   @"viewCanvasBackgroundTypes",
					   @"viewCanvasBackgroundValues",
					   @"styles",
					   @"controlStyles",
					   @"textStyles",
					   @"exampleContainerBgColor",
					   @"textExampleContainerBgColor",
					   @"constantsPanel",
					   @"constantsTextView",
					   @"constants",
					   @"blendModes",
					   @"parameters",
					   @"parameterPanel",
					   nil];
	
    return result;
}

//===========================================================
// - (void)startObservingObject:
//
//===========================================================
- (void)startObservingObject:(id)thisObject
{
    if ([thisObject respondsToSelector:@selector(keyPaths)]) {
        NSArray *keyPathsArray = [thisObject keyPaths];
        for (NSString *keyPath in keyPathsArray) {
            [thisObject addObserver:self
						 forKeyPath:keyPath
							options:NSKeyValueObservingOptionOld
							context:NULL];
        }
    }
	
	
}
- (void)stopObservingObject:(id)thisObject
{
    if ([thisObject respondsToSelector:@selector(keyPaths)]) {
        NSArray *keyPathsArray = [thisObject keyPaths];
        for (NSString *keyPath in keyPathsArray) {
            [thisObject removeObserver:self forKeyPath:keyPath];
        }
    }
}

- (void)emptyPropertiesContainer
{
	for (NSView *sub in self.propertiesContainerView.subviews) {
		[sub removeFromSuperview];
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (object == self.stylesController) {
		if (self.stylesController.selectedObjects.count > 0) {
			[self.sliderStylesController setSelectedObjects:nil];
			[self.imageStylesController setSelectedObjects:nil];

			if (!self.viewStyleTabs.window) {
				[self emptyPropertiesContainer];
				
				self.viewStyleTabs.frame = self.propertiesContainerView.bounds;
				[self.propertiesContainerView addSubview:self.viewStyleTabs];
			}
		}
		
	} else if (object == self.sliderStylesController) {
		if (self.sliderStylesController.selectedObjects.count > 0) {
			[self.stylesController setSelectedObjects:nil];
			[self.imageStylesController setSelectedObjects:nil];
			if (!self.sliderStyleTabs.window) {
				[self emptyPropertiesContainer];
				
				self.sliderStyleTabs.frame = self.propertiesContainerView.bounds;
				[self.propertiesContainerView addSubview:self.sliderStyleTabs];
			}
		}
		
	} else if (object == self.imageStylesController) {
		if (self.imageStylesController.selectedObjects.count > 0) {
			[self.stylesController setSelectedObjects:nil];
			[self.sliderStylesController setSelectedObjects:nil];

			if (!self.imageStyleTabs.window) {
				[self emptyPropertiesContainer];
				
				self.imageStyleTabs.frame = self.propertiesContainerView.bounds;
				[self.propertiesContainerView addSubview:self.imageStyleTabs];
			}
		}
	}else {
		[self updateChangeCount:NSChangeDone];
	}
}

- (id)init
{
    self = [super init];
    if (self) {
        [[DPStyleManager sharedInstance] setDelegate:self];
		[[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
		[[NSColorPanel sharedColorPanel] setContinuous:YES];
		[NSColor setIgnoresAlpha:NO];
		[NSValueTransformer setValueTransformer:[[ColorTransformer alloc] init] forName: @"ColorTransformer"];
		self.styles = [NSMutableArray new];
		self.exampleContainerBgColor = [NSColor colorWithCalibratedHue:0 saturation:0 brightness:0.2 alpha:1];
		self.colorVars = [NSMutableArray new];
        
		
		self.textStyles = [NSMutableArray new];
		self.textExampleContainerBgColor = [NSColor whiteColor];
        self.flippedStyle = [[DPUIStyle alloc] init];
        self.flippedStyle.styleName = @"Current w/Flipped Gradient";
        self.parameters = [NSMutableArray new];
		self.sliderStyles = [NSMutableArray new];
		self.imageStyles = [NSMutableArray new];
		//	[self startObservingObject:self];
        
        DYNMoreOption *navbar = [[DYNMoreOption alloc] init];
        navbar.index = @(0);
        navbar.name = @"UINavigationBar";
        
        
        DYNMoreOption *tablecell = [[DYNMoreOption alloc] init];
        tablecell.index = @(1);
        tablecell.name = @"UITableViewCell";
        
        DYNMoreOption *searchbar = [[DYNMoreOption alloc] init];
        searchbar.index = @(2);
        searchbar.name = @"UISearchBar";
        
        DYNMoreOption *textField = [[DYNMoreOption alloc] init];
        textField.name = @"UITextField";
        textField.index = @(3);
		
		DYNMoreOption *seg = [[DYNMoreOption alloc] init];
		seg.name = @"UISegmentedControl";
		seg.index = @(4);
		
        DYNMoreOption *groupedTable = [[DYNMoreOption alloc] init];
        groupedTable.name = @"UITableView - Grouped";
        groupedTable.index = @(5);
        
        DYNMoreOption *controls = [[DYNMoreOption alloc] init];
        controls.name = @"Control States";
        controls.index = @(6);
		
        self.moreSelectionOptions = @[navbar,
                 tablecell,
                 searchbar,
                 textField,
				 seg,
                                      groupedTable,
                 controls];
	}
    return self;
}

- (void)windowDidBecomeKey:(NSNotification *)notification
{
    [[DPStyleManager sharedInstance] setDelegate:self];
	[self startObservingObject:self];
}

- (void)windowDidResignKey:(NSNotification *)notification
{
	[self stopObservingObject:self];
}

- (NSArray*)colorVarArray
{
    return self.colorVars;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"DPUIDocument";
}

- (NSArray*)viewCanvasBackgroundTypes
{
	if (!_viewCanvasBackgroundTypes) {
		_viewCanvasBackgroundTypes = @[kBackgroundTransparent, kBackgroundPreviewColor, kBackgroundCustomColor];
	}
	
	return _viewCanvasBackgroundTypes;
}

- (NSArray*)viewCanvasBackgroundValues
{
	if (!_viewCanvasBackgroundValues) {
		_viewCanvasBackgroundValues = @[@(0),@(1),@(2)];
	}
	
	return _viewCanvasBackgroundValues;
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];

	if (self.updateTimer) {
		[self.updateTimer invalidate];
		self.updateTimer = nil;
	}
	self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(styleChanged) userInfo:nil repeats:YES];
    
	
	[self.stylesController addObserver:self forKeyPath:@"selectedObjects" options:0 context:nil];
	[self.sliderStylesController addObserver:self forKeyPath:@"selectedObjects" options:0 context:nil];
	[self.imageStylesController addObserver:self forKeyPath:@"selectedObjects" options:0 context:nil];
}
+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
   
	return [self getJSON];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
	if (self.updateTimer) {
		[self.updateTimer invalidate];
		self.updateTimer = nil;
	}
	self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(styleChanged) userInfo:nil repeats:YES];

    [self convertFromJSON:data];
    return YES;
}

- (void)convertFromJSON:(NSData*)data
{
	NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
	
	if ([dict objectForKey:@"exampleContainerBgColor"]) {
		self.exampleContainerBgColor = [ColorTransformer colorFromString:[dict objectForKey:@"exampleContainerBgColor"]];
	}
	if ([dict objectForKey:@"textExampleContainerBgColor"]) {
		self.textExampleContainerBgColor = [ColorTransformer colorFromString:[dict objectForKey:@"textExampleContainerBgColor"]];
	}
	
	NSMutableArray *tmp = [NSMutableArray new];
	NSArray *colorVars = [dict objectForKey:@"colors"];
	for (NSDictionary *colorVar in colorVars) {
		[tmp addObject:[[DPStyleColor alloc] initWithDictionary:colorVar]];
	}
	
	self.colorVars = tmp;
	[[DPStyleManager sharedInstance] setColorVariables:self.colorVars];

	tmp = [NSMutableArray new];
	NSArray *textStyles = [dict objectForKey:@"textStyles"];
	for (NSDictionary *textStyle in textStyles) {
		[tmp addObject:[[DPUITextStyle alloc] initWithDictionary:textStyle]];
		
	}
	
	self.textStyles = tmp;
	[[DPStyleManager sharedInstance] setTextStyles:self.textStyles];
	
	NSArray *styles = [dict objectForKey:@"styles"];
	NSMutableArray *newStyles = [NSMutableArray new];
	for (NSDictionary*style in styles) {
		DPUIStyle *new = [[DPUIStyle alloc] initWithDictionary:style];
        
				
        [newStyles addObject:new];
	}
	
	NSMutableArray *tmpSlider = [NSMutableArray new];
	for (NSDictionary *slider in [dict objectForKey:@"sliderStyles"]) {
		[tmpSlider addObject:[[DYNSliderStyle alloc] initWithDictionary:slider]];
	}
	
	NSMutableArray *tmpImage = [NSMutableArray new];
	for (NSDictionary *imageStyle in [dict objectForKey:@"imageStyles"]) {
		[tmpImage addObject:[[DPUIStyle alloc] initWithDictionary:imageStyle]];
	}
	
	self.imageStyles = tmpImage;
	self.sliderStyles = tmpSlider;
	self.styles = newStyles;
	
	[self.colorTable reloadData];
	[self.styleTable reloadData];
    
    self.sliderStylesController.selectedObjects = nil;
    if (self.styles.count > 0) {
        self.stylesController.selectedObjects = @[self.styles[0]];
    }
}

- (NSMutableArray*)controlStyles
{
    NSMutableArray *tmp = [[self.styles valueForKeyPath:@"styleName"] mutableCopy];
    [tmp insertObject:@"Current - Flipped Gradient" atIndex:0];
    [tmp insertObject:@"Current - 50% Opacity" atIndex:1];
    [tmp insertObject:@"Current - Make Darker" atIndex:2];
    [tmp insertObject:@"Current - Make Lighter" atIndex:3];
    return tmp;
}

- (DPUIStyle*)currentStyle
{
	if (self.stylesController.selectedObjects && self.stylesController.selectedObjects.count > 0) {
		return self.stylesController.selectedObjects[0];
	}
	return nil;
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSMutableSet *set = [[super keyPathsForValuesAffectingValueForKey:key] mutableCopy];
    
    if ([key isEqualToString:@"controlStyles"]) {
        [set addObject:@"styles"];
    }
    
    if ([key isEqualToString:@"colorAndParamVars"]) {
        [set addObject:@"colorVars"];
        [set addObject:@"parameters"];
    }
    return set;
}

- (IBAction)styleChanged
{
	self.exampleView.containerColor = self.exampleContainerBgColor;
	[[DPStyleManager sharedInstance] setColorVariables:self.colorVars];
	[[DPStyleManager sharedInstance] setStyles:self.styles];
	[[DPStyleManager sharedInstance] setSliderStyles:self.sliderStyles];

	if (self.stylesController.selectedObjects && self.stylesController.selectedObjects.count > 0) {
		self.exampleView.sliderStyle = nil;
		[[DPStyleManager sharedInstance] setCurrentStyle:self.stylesController.selectedObjects[0]];
		self.exampleView.style = self.stylesController.selectedObjects[0];
		self.exampleView.imageStyle = nil;
		[self.bottomInnerBorderTable reloadData];
		[self.topInnerBorderTable reloadData];
		[self.backgroundColorsTable reloadData];
	} else if (self.sliderStylesController.selectedObjects && self.sliderStylesController.selectedObjects.count > 0) {
		self.exampleView.style = nil;
		self.exampleView.sliderStyle = self.sliderStylesController.selectedObjects[0];
		self.exampleView.imageStyle = nil;
	} else if (self.imageStylesController.selectedObjects && self.imageStylesController.selectedObjects.count > 0) {
		self.exampleView.imageStyle = self.imageStylesController.selectedObjects[0];
		self.exampleView.style = nil;
		self.exampleView.sliderStyle = nil;
	}
	
if (self.textStylesController.selectedObjects && self.textStylesController.selectedObjects.count > 0) {
	//self.textExampleView.bgColor = self.textExampleContainerBgColor;
	self.textExampleView.style = self.textStylesController.selectedObjects[0];
}
}

- (NSData*)getJSON
{
	NSMutableDictionary *container = [NSMutableDictionary new];
	NSMutableArray *styles = [NSMutableArray new];
	for (DPUIStyle *style in self.styles) {
		NSDictionary *dictionary = style.jsonValue;
		[styles addObject:dictionary];
	}
	
	NSArray *colorVars = self.colorVars;
	NSMutableArray *tmpColorVars = [NSMutableArray new];
	for (DPStyleColor*color in colorVars)
	{
		[tmpColorVars addObject:[color jsonValue]];
	}
	
	[container setObject:tmpColorVars forKey:@"colors"];
	
	[container setObject:styles forKey:@"styles"];
	NSMutableArray *tmpTextStyles = [NSMutableArray new];
	for (DPUITextStyle *textStyle in self.textStyles) {
		
		[tmpTextStyles addObject:textStyle.jsonValue];
		
	}
	[container setObject:tmpTextStyles forKey:@"textStyles"];
	
	[container setObject:[ColorTransformer stringFromColor:self.exampleContainerBgColor] forKey:@"exampleContainerBgColor"];
	[container setObject:[ColorTransformer stringFromColor:self.textExampleContainerBgColor] forKey:@"textExampleContainerBgColor"];
	
	NSMutableArray *tmpSlider = [NSMutableArray new];
	
	for (DYNSliderStyle *slider in self.sliderStyles) {
		[tmpSlider addObject:slider.jsonValue];
	}
	
	[container setObject:tmpSlider forKey:@"sliderStyles"];
	
	NSMutableArray *tmpImageStyles = [NSMutableArray new];
	for (DPUIStyle *style in self.imageStyles) {
		[tmpImageStyles addObject:style.jsonValue];
	}
	
	[container setObject:tmpImageStyles forKey:@"imageStyles"];
	
	NSError *error;
	NSData *json = [NSJSONSerialization dataWithJSONObject:container options:NSJSONWritingPrettyPrinted error:&error];
	return json;
}

- (IBAction)renderToJSON:(id)sender
{
	NSError *error;

	NSData *json = [self getJSON];
	if (error) {
		NSLog(@"%@", error);
	}
	[json writeToFile:@"Styles.dpui" options:0 error:&error];
	if (error)
	{
		NSLog(@"%@", error);
	}
}

- (IBAction)roundCornersChanged:(id)sender
{
	//NSButton *button = (NSButton*)sender;
	UIRectCorner corners = 0;


	
	if (self.topRightCorner.state == 1) {
		corners = corners | UIRectCornerTopRight;
	}
	
	if (self.bottomRightCorner.state == 1) {
		corners = corners | UIRectCornerBottomRight;
	}
	
	if (self.bottomLeftCorner.state == 1) {
		corners = corners | UIRectCornerBottomLeft;
	}
	if (self.topLeftCorner.state == 1) {
		corners = corners | UIRectCornerTopLeft;
	}

	
	[[self.stylesController selectedObjects][0] setRoundedCorners:corners];
	//	self.exampleView.style = self.stylesController.selectedObjects[0];

}

- (void)changeFont:(id)sender
{
	NSFont *oldFont = [self.textStylesController.selectedObjects[0] font];
	NSFont *newFont = [sender convertFont:oldFont];
	[self.textStylesController.selectedObjects[0] setFont:newFont];
}


-(IBAction)showFonts:(id)sender
{
	[[NSFontPanel sharedFontPanel] setEnabled:YES];
	[[NSFontPanel sharedFontPanel] setPanelFont:[self.textStylesController.selectedObjects[0] font] isMultiple:NO];
	//	[[NSFontPanel sharedFontPanel] setFloatingPanel:YES];
	[[NSFontPanel sharedFontPanel] display];
	[[NSFontPanel sharedFontPanel] makeKeyAndOrderFront:nil];
}

- (NSArray*)colorAndParamVars
{
    NSArray *params = [NSArray arrayWithObjects:@"Parameters",@"-------", nil];
    params = [params arrayByAddingObjectsFromArray:[self.parameters valueForKeyPath:@"name"]];
    params = [params arrayByAddingObject:@""];
    params = [params arrayByAddingObject:@"Colors"];
    params = [params arrayByAddingObject:@"-------"];
    params = [params arrayByAddingObjectsFromArray:[self.colorVars valueForKeyPath:@"colorName"]];
    return params;
}

- (IBAction)generateConstants:(id)sender
{
	/*[[NSApplication sharedApplication] beginSheet:self.constantsPanel
								   modalForWindow:[[NSApp delegate] mainWindow]
									modalDelegate:self
								   didEndSelector:nil
									  contextInfo:nil];
	*/
	 
	 [self.constantsPanel display];
	[self.constantsPanel makeKeyAndOrderFront:nil];
	//[self.constantsPanel makeKeyWindow];
	self.constantsTextView.string = [self constants];
}

- (NSString*)constants
{
	NSMutableArray *styleNames = [NSMutableArray new];
	NSMutableArray *colorNames = [NSMutableArray new];
	NSMutableArray *textStyleNames = [NSMutableArray new];
	
	for (DPUIStyle *style in self.styles) {
		[styleNames addObject:[NSString stringWithFormat:@"static NSString * const k%@ViewStyle = @\"%@\";", style.styleName, style.styleName]];
	}
	
	for (DPStyleColor *color in self.colorVars) {
		[colorNames addObject:[NSString stringWithFormat:@"static NSString * const k%@Color = @\"%@\";", color.colorName, color.colorName]];

	}
	
	for (DPUITextStyle *style in self.textStyles) {
		[textStyleNames addObject:[NSString stringWithFormat:@"static NSString * const k%@TextStyle = @\"%@\";", style.styleName, style.styleName]];
	}
	
	NSString *constants = [NSString stringWithFormat:@"//////////  View Styles \r\r%@\r\r//////////  Colors \r\r%@\r\r//////////  Text Styles \r\r%@", [styleNames componentsJoinedByString:@"\r"], [colorNames componentsJoinedByString:@"\r"], [textStyleNames componentsJoinedByString:@"\r"]];
	return constants;
}

- (NSArray*)blendModes
{
	return @[@"kCGBlendModeNormal",
		  @"kCGBlendModeMultiply",
		  @"kCGBlendModeScreen",
		  @"kCGBlendModeOverlay",
		  @"kCGBlendModeDarken",
		  @"kCGBlendModeLighten",
		  @"kCGBlendModeColorDodge",
		  @"kCGBlendModeColorBurn",
		  @"kCGBlendModeSoftLight",
		  @"kCGBlendModeHardLight",
		  @"kCGBlendModeDifference",
		  @"kCGBlendModeExclusion",
		  @"kCGBlendModeHue",
		  @"kCGBlendModeSaturation",
		  @"kCGBlendModeColor",
		  @"kCGBlendModeLuminosity",
		  @"kCGBlendModeClear",
		  @"kCGBlendModeCopy",
		  @"kCGBlendModeSourceIn",
		  @"kCGBlendModeSourceOut",
		  @"kCGBlendModeSourceAtop",
		  @"kCGBlendModeDestinationOver",
		  @"kCGBlendModeDestinationIn",
		  @"kCGBlendModeDestinationOut",
		  @"kCGBlendModeDestinationAtop",
		  @"kCGBlendModeXOR",
		  @"kCGBlendModePlusDarker",
		  @"kCGBlendModePlusLighter"];
}

- (IBAction)showParameters:(id)sender
{
    [self.parameterPanel display];
	[self.parameterPanel makeKeyAndOrderFront:nil];
}

- (IBAction)styleSegTapped:(id)sender
{
	NSSegmentedControl *seg = (NSSegmentedControl*)sender;
	
	if (seg.selectedSegment == 0) {
		[self.stylesController add:nil];
	} else if (seg.selectedSegment == 1) {
		[self.stylesController remove:nil];
	} else if (seg.selectedSegment == 2) {
		DPUIStyle *style = [self.stylesController selectedObjects][0];
		DPUIStyle *newStyle = [style copy];
		newStyle.styleName = [self dupeNameForStyle:style];
		[self.stylesController addObject:newStyle];
		[self.styleTable reloadData];
	}
}


- (IBAction)sliderSegTapped:(id)sender
{
	NSSegmentedControl *seg = (NSSegmentedControl*)sender;
	
	if (seg.selectedSegment == 0) {
		[self.sliderStylesController add:nil];
	} else if (seg.selectedSegment == 1) {
		[self.sliderStylesController remove:nil];
	} else if (seg.selectedSegment == 2) {
//		DPUIStyle *style = [self.stylesController selectedObjects][0];
//		DPUIStyle *newStyle = [style copy];
//		newStyle.styleName = [self dupeNameForStyle:style];
//		[self.stylesController addObject:newStyle];
//		[self.styleTable reloadData];
	}
	
	[self.sliderStylesTable reloadData];
}

- (IBAction)imageStyleSegTapped:(id)sender
{
	NSSegmentedControl *seg = (NSSegmentedControl*)sender;

	if (seg.selectedSegment == 0) {
		[self.imageStylesController add:nil];
	} else if (seg.selectedSegment == 1) {
		[self.imageStylesController remove:nil];
	} else if (seg.selectedSegment == 2) {
	}
[self.imageStylesTable reloadData];
}
- (NSString*)dupeNameForStyle:(DPUIStyle*)style
{
	NSInteger x = 1;
	BOOL found = NO;
	NSString *name;
	
	while (!found) {
		
		name = [NSString stringWithFormat:@"%@%ld", style.styleName, (long)x];
		if (![[[DPStyleManager sharedInstance] styleNames] containsObject:name]) {
			found = YES;
		} else {
			x += 1;
		}
		
	}
	
	return name;

}

- (IBAction)moreSourceSelected:(id)sender
{
    
}
@end
