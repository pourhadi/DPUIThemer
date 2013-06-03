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
#import "ImageAndTextCell.h"
#import "NSTableView+ColorWell.h"
#import "NSBezierPath+SVG.h"
#import "DYNClassStyle.h"
static NSString *kGROUPED_TABLE_TOP_CELL_KEY = @"groupedTableTopCell";
static NSString *kGROUPED_TABLE_MIDDLE_CELL_KEY = @"groupedTableMiddleCell";
static NSString *kGROUPED_TABLE_SINGLE_CELL_KEY = @"groupedTableSingleCell";
static NSString *kGROUPED_TABLE_BOTTOM_CELL_KEY = @"groupedTableBottomCell";

@interface NSObject (Fake)

- (id)observedObject;

@end

@implementation NSObject (Fake)



@end

@implementation DYNNode




@end


@implementation DYNMoreOption



@end
@implementation DPUIStyle
@synthesize strokeWidth = _strokeWidth;
@synthesize children=_children;
#pragma mark -
#pragma mark NSPasteboardWriting support

/*NSString *const NSPasteboardTypeString;
 NSString *const NSPasteboardTypePDF;
 NSString *const NSPasteboardTypeTIFF;
 NSString *const NSPasteboardTypePNG;
 NSString *const NSPasteboardTypeRTF;
 NSString *const NSPasteboardTypeRTFD;
 NSString *const NSPasteboardTypeHTML;
 NSString *const NSPasteboardTypeTabularText;
 NSString *const NSPasteboardTypeFont;
 NSString *const NSPasteboardTypeRuler;
 NSString *const NSPasteboardTypeColor;
 NSString *const NSPasteboardTypeSound;
 NSString *const NSPasteboardTypeMultipleTextSelection;
 NSString *const NSPasteboardTypeFindPanelSearchOptions;*/

- (NSArray *)writableTypesForPasteboard:(NSPasteboard *)pasteboard {
    // These are the types we can write.
    NSArray *ourTypes = [NSArray arrayWithObjects:NSPasteboardTypeString, nil];

    return ourTypes;
}

- (NSPasteboardWritingOptions)writingOptionsForType:(NSString *)type pasteboard:(NSPasteboard *)pasteboard {
    if ([type isEqualToString:NSPasteboardTypeString]) {
        return 0;
    }

    
    return 0;
}

- (id)pasteboardPropertyListForType:(NSString *)type {
    NSDictionary *dict = self.jsonValue;

    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    return data;
}

#pragma mark -
#pragma mark  NSPasteboardReading support

+ (NSArray *)readableTypesForPasteboard:(NSPasteboard *)pasteboard {
    // We allow creation from URLs so Finder items can be dragged to us
    return [NSArray arrayWithObjects:(id)kUTTypeURL, NSPasteboardTypeString, nil];
}

+ (NSPasteboardReadingOptions)readingOptionsForType:(NSString *)type pasteboard:(NSPasteboard *)pasteboard {
        return NSPasteboardReadingAsString;
    
}

- (id)initWithPasteboardPropertyList:(id)propertyList ofType:(NSString *)type {
    // See if an NSURL can be created from this type
    NSData *data = [(NSString*)propertyList dataUsingEncoding:NSASCIIStringEncoding];
    self = [self initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]];
    return self;
}


- (id)initWithDictionary:(NSDictionary*)style
{
	self = [self init];
	if (self) {
		DPUIStyle *new = self;
		
		new.styleName = [style objectForKey:@"name"];
		
		if ([style objectForKey:@"isLeaf"]) {
		new.isLeaf = [[style objectForKey:@"isLeaf"] boolValue];
		} else {
			new.isLeaf = YES;
		}
		if (!new.isLeaf) {
			
			NSMutableArray *children = [NSMutableArray new];
			for (NSDictionary *child in [style objectForKey:@"children"]) {
				[children addObject:[[DPUIStyle alloc] initWithDictionary:child]];
			}
	
	new.children = children;
            return self;
}

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
			new.tableCellTitleTextStyle = [style objectForKey:@"tableCellTitleTextStyle"];
		}
		if ([style objectForKey:@"tableCellDetailTextStyle"]){
			new.tableCellDetailTextStyle = [style objectForKey:@"tableCellDetailTextStyle"];
		}
		
		if ([style objectForKey:@"tableCellSelectedStyleName"])
			{
				new.tableCellSelectedStyleName = [style objectForKey:@"tableCellSelectedStyleName"];
			}
		
		if ([style objectForKey:@"navBarTitleTextStyle"]) {
			new.navBarTitleTextStyle = [style objectForKey:@"navBarTitleTextStyle"];
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
			new.segmentDividerWidth = [style objectForKey:@"segmentDividerWidth"];
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
		
		if ([style objectForKey:@"customSettings"]) {
			NSMutableArray *tmpSettings = [NSMutableArray new];
			for (NSDictionary *setting in [style objectForKey:@"customSettings"]) {
				[tmpSettings addObject:[[DPUICustomSetting alloc] initWithDictionary:setting]];
			}
	new.customSettings = tmpSettings;
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
    
    [dictionary setObject:@(self.isLeaf) forKey:@"isLeaf"];

    if (!self.isLeaf) {
		NSMutableArray *children = [NSMutableArray new];
        
        
		for (DPUIStyle *childStyle in self.children) {
			[children addObject:childStyle.jsonValue];
		}
		
		[dictionary setObject:children forKey:@"children"];

        return dictionary;
}

    
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
		[dictionary setObject:style.navBarTitleTextStyle forKey:@"navBarTitleTextStyle"];
	}
	
	if (style.tableCellTitleTextStyle) {
		[dictionary setObject:style.tableCellTitleTextStyle forKey:@"tableCellTitleTextStyle"];
	}
	
	if (style.tableCellDetailTextStyle) {
		[dictionary setObject:style.tableCellDetailTextStyle forKey:@"tableCellDetailTextStyle"];
	}
	
	if (style.tableCellSelectedStyleName) {
		[dictionary setObject:style.tableCellSelectedStyleName forKey:@"tableCellSelectedStyleName"];
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
		
		[dictionary setObject:style.segmentDividerWidth forKey:@"segmentDividerWidth"];
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
	
	if (style.customSettings.count > 0) {
		NSMutableArray *tmpSettings = [NSMutableArray new];
		for (DPUICustomSetting *setting in style.customSettings) {
			[tmpSettings addObject:setting.jsonValue];
		}
[dictionary setObject:tmpSettings forKey:@"customSettings"];
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
	[theCopy setCustomSettings:[self.customSettings copy]];
    
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
		self.segmentDividerWidth = @(0);
		self.isLeaf = YES;
		self.children = [NSMutableArray new];
		self.customSettings = [NSMutableArray new];
		//self.navBarTitleTextStyle = [[DPUITextStyle alloc] init];
		//self.tableCellTitleTextStyle = [[DPUITextStyle alloc] init];
		//self.tableCellDetailTextStyle = [[DPUITextStyle alloc] init];
        
	}
	return self;
}


- (NSMutableArray*)children
{
    if (!_children) {
        _children = [NSMutableArray arrayWithCapacity:1];
    }
    [_children makeObjectsPerformSelector:@selector(setParentNode:) withObject:self];
    return _children;
}

- (void)setChildren:(NSMutableArray *)children
{
    [self willChangeValueForKey:@"children"];
    _children = children;
    [self didChangeValueForKey:@"children"];
    [self.children makeObjectsPerformSelector:@selector(setParentNode:) withObject:self];  
}

- (void)dealloc
{
  //  [self removeObserver:self forKeyPath:@"children.count"];
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
    NSArray *_draggedNodes;
    DPUIStyle *_selectedNode;

}
@property (nonatomic, strong) NSTimer *updateTimer;
@property (nonatomic, strong) ColorCell *backgroundColorCell;
@property (nonatomic, strong) ColorCell *topInnerBorderColorCell;
@property (nonatomic, strong) ColorCell *bottomInnerBorderColorCell;

@property (nonatomic, assign) NSTableView* selectedColorCell;

@property (nonatomic, weak) IBOutlet NSView *customView;
@property (nonatomic, weak) IBOutlet NSView *mainView;

@property (nonatomic, strong) DPUIStyle *flippedStyle;

@property (nonatomic) BOOL isKey;
@end

@implementation DPUIDocument
@synthesize styleOutlineView=_outlineView;
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
#define LOCAL_REORDER_PASTEBOARD_TYPE @"MyCustomOutlineViewPboardType"

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.styleOutlineView registerForDraggedTypes:[NSArray arrayWithObjects:LOCAL_REORDER_PASTEBOARD_TYPE, NSStringPboardType, nil]];
    [self.styleOutlineView setDraggingSourceOperationMask:NSDragOperationEvery forLocal:YES];
	
	self.styleOutlineView.delegate = self;
	self.classStylesListTable.delegate = self;
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
//	if (object == self.stylesController) {
//
//		if (self.stylesController.selectedObjects.count > 0) {
//
//			[self.sliderStylesController setSelectedObjects:nil];
//			[self.imageStylesController setSelectedObjects:nil];
//			[self.classStylesListController setSelectedObjects:nil];
//
//			if (!self.viewStyleTabs.window) {
//				[self emptyPropertiesContainer];
//				
//				self.viewStyleTabs.frame = self.propertiesContainerView.bounds;
//				[self.propertiesContainerView addSubview:self.viewStyleTabs];
//			}
//		}
//		
//	} else if (object == self.sliderStylesController) {
//		if (self.sliderStylesController.selectedObjects.count > 0) {
//			[self.stylesController setSelectedObjects:nil];
//			[self.imageStylesController setSelectedObjects:nil];
//			[self.classStylesListController setSelectedObjects:nil];
//
//			if (!self.sliderStyleTabs.window) {
//				[self emptyPropertiesContainer];
//				
//				self.sliderStyleTabs.frame = self.propertiesContainerView.bounds;
//				[self.propertiesContainerView addSubview:self.sliderStyleTabs];
//			}
//		}
//		
//	} else if (object == self.imageStylesController) {
//		if (self.imageStylesController.selectedObjects.count > 0) {
//			[self.stylesController setSelectedObjects:nil];
//			[self.sliderStylesController setSelectedObjects:nil];
//			[self.classStylesListController setSelectedObjects:nil];
//
//
//			if (!self.imageStyleTabs.window) {
//				[self emptyPropertiesContainer];
//				
//				self.imageStyleTabs.frame = self.propertiesContainerView.bounds;
//				[self.propertiesContainerView addSubview:self.imageStyleTabs];
//			}
//		}
//	} else if (object == self.classStylesListController) {
//		NSLog(@"class styles list");
//
//		if (self.classStylesListController.selectedObjects.count > 0) {
//			NSLog(@"class styles list more than 0");
//
//			[self.stylesController setSelectedObjects:nil];
//			[self.sliderStylesController setSelectedObjects:nil];
//			[self.imageStylesController setSelectedObjects:nil];
//			
//			if (!self.classStyleView.window) {
//				[self emptyPropertiesContainer];
//				
//				self.classStyleView.frame = self.propertiesContainerView.bounds;
//				[self.propertiesContainerView addSubview:self.classStyleView];
//			}
//		}
//	} else if (object == self.styleTreeController) {
//        self.flatStylesArray = [self stylesForParent:self.rootNode];
//    }
//    else {
//		[self updateChangeCount:NSChangeDone];
//	}
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
		
		DYNMoreOption *custom = [[DYNMoreOption alloc] init];
		custom.name = @"Custom";
		custom.index = @(7);
		
        self.moreSelectionOptions = @[navbar,
                 tablecell,
                 searchbar,
                 textField,
				 seg,
                                      groupedTable,
                 controls,
									  custom];
		
		
		self.classStyles = [NSArray array];
	}
    return self;
}

- (void)windowDidBecomeKey:(NSNotification *)notification
{
	self.isKey = YES;
    [[DPStyleManager sharedInstance] setDelegate:self];
	[self startObservingObject:self];
}

- (void)windowDidResignKey:(NSNotification *)notification
{
	self.isKey = NO;
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
    [self.styleTreeController addObserver:self forKeyPath:@"arrangedObjects" options:0 context:nil];
    [self.classStylesListController addObserver:self forKeyPath:@"arrangedObjects" options:0 context:nil];

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
	
	NSMutableArray *tmpClassStyles = [NSMutableArray new];
	for (NSDictionary *classStyle in [dict objectForKey:@"classStyles"]) {
		[tmpClassStyles addObject:[[DYNClassStyle alloc] initWithDictionary:classStyle]];
	}
	
	self.classStyles = tmpClassStyles;
	
	
	self.imageStyles = tmpImage;
	self.sliderStyles = tmpSlider;
	self.styles = newStyles;
	
    self.rootNode = [[DPUIStyle alloc] init];
    self.rootNode.isLeaf = NO;
    self.rootNode.children = self.styles;
    
	[self.colorTable reloadData];
	[self.styleTable reloadData];
    
    self.sliderStylesController.selectedObjects = nil;
    if (self.styles.count > 0) {
        self.stylesController.selectedObjects = @[self.styles[0]];
    }
}

- (NSMutableArray*)controlStyles
{
    NSMutableArray *tmp = [[[self getFlatStylesArray] valueForKeyPath:@"styleName"] mutableCopy];
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
	if (self.isKey) {
		//	self.flatStylesArray = [self getFlatStylesArray];

		self.exampleView.scale = self.scale.floatValue;
	self.exampleView.containerColor = self.exampleContainerBgColor;
	[[DPStyleManager sharedInstance] setColorVariables:self.colorVars];
	[[DPStyleManager sharedInstance] setStyles:[[self getFlatStylesArray] mutableCopy]];
	[[DPStyleManager sharedInstance] setSliderStyles:self.sliderStyles];
	[[DPStyleManager sharedInstance] setImageStyles:self.imageStyles];

	if (self.stylesController.selectedObjects && self.stylesController.selectedObjects.count > 0) {
		[self.iconPopup setHidden:YES];

		self.exampleView.sliderStyle = nil;
		[[DPStyleManager sharedInstance] setCurrentStyle:self.stylesController.selectedObjects[0]];
		self.exampleView.style = self.stylesController.selectedObjects[0];
		self.exampleView.imageStyle = nil;
		[self.bottomInnerBorderTable reloadData];
		[self.topInnerBorderTable reloadData];
		[self.backgroundColorsTable reloadData];
	} else if (self.sliderStylesController.selectedObjects && self.sliderStylesController.selectedObjects.count > 0) {
		[self.iconPopup setHidden:YES];

		self.exampleView.style = nil;
		self.exampleView.sliderStyle = self.sliderStylesController.selectedObjects[0];
		self.exampleView.imageStyle = nil;
	} else if (self.imageStylesController.selectedObjects && self.imageStylesController.selectedObjects.count > 0) {
		self.exampleView.imageStyle = self.imageStylesController.selectedObjects[0];
		self.exampleView.style = nil;
		self.exampleView.sliderStyle = nil;
		
		[self.iconPopup setHidden:NO];
	}
	
if (self.textStylesController.selectedObjects && self.textStylesController.selectedObjects.count > 0) {
	//self.textExampleView.bgColor = self.textExampleContainerBgColor;
	self.textExampleView.style = self.textStylesController.selectedObjects[0];
}
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
	
	NSMutableArray *tmpClassStyles = [NSMutableArray new];
	for (DYNClassStyle *classStyle in self.classStyles) {
		[tmpClassStyles addObject:classStyle.jsonValue];
	}
	
	[container setObject:tmpClassStyles forKey:@"classStyles"];
	
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
	[json writeToFile:@"Styles.dyn" options:0 error:&error];
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

- (DPUIStyle*)selectedNode
{
    DPUIStyle *node = [_outlineView itemAtRow:[_outlineView selectedRow]];
    return node;
}

- (IBAction)classStylesSegTapped:(id)sender
{
	NSSegmentedControl *seg = (NSSegmentedControl*)sender;

	if (seg.selectedSegment == 0) {
		[self.classStylesListController add:nil];
	} else if (seg.selectedSegment == 1) {
		[self.classStylesListController remove:nil];
	}
}

- (IBAction)styleSegTapped:(id)sender
{
	NSSegmentedControl *seg = (NSSegmentedControl*)sender;
	
	if (seg.selectedSegment == 0) {
		DPUIStyle *style = [self selectedNode];
		DPUIStyle *newStyle = [[DPUIStyle alloc] init];
		newStyle.isLeaf = YES;
        if (style.parentNode) {
			
			[style.parentNode.children addObject:newStyle];
			
        } else {
			[self.rootNode.children addObject:newStyle];
		}
	} else if (seg.selectedSegment == 1) {
		
        DPUIStyle *style = [self selectedNode];
        if (style.parentNode) {
            [style.parentNode.children removeObject:style];
        }
        
	} else if (seg.selectedSegment == 2) {
		DPUIStyle *style = [self selectedNode];
        if (style.isLeaf) {
		DPUIStyle *newStyle = [style copy];
		newStyle.styleName = [self dupeNameForStyle:style];
		if (style.parentNode) {
            [style.parentNode.children addObject:newStyle];
        }
        }
	} else if (seg.selectedSegment == 3) {
        DPUIStyle *style = [self selectedNode];

		DPUIStyle *folder = [[DPUIStyle alloc] init];
		folder.isLeaf = NO;
		folder.styleName = @"New Folder";
        
        if (style)
            [style.parentNode.children addObject:folder];
        else {
            [self.rootNode.children addObject:folder];
        }
	}

	self.flatStylesArray = [self getFlatStylesArray];

    [self.styleOutlineView reloadData];
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


#pragma mark NSOutlineView Hacks for Drag and Drop

- (BOOL)outlineView:(NSOutlineView *)outlineView writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pasteboard
{
	return YES;
}


- (BOOL)outlineView:(NSOutlineView *)outlineView shouldReorderColumn:(NSInteger)columnIndex toColumn:(NSInteger)newColumnIndex NS_AVAILABLE_MAC(10_6)
{
	return YES;
}

- (NSDragOperation)outlineView:(NSOutlineView *)ov validateDrop:(id <NSDraggingInfo>)info proposedItem:(id)item proposedChildIndex:(NSInteger)childIndex {
    // To make it easier to see exactly what is called, uncomment the following line:
    //    NSLog(@"outlineView:validateDrop:proposedItem:%@ proposedChildIndex:%ld", item, (long)childIndex);
    
    // This method validates whether or not the proposal is a valid one.
    // We start out by assuming that we will do a "generic" drag operation, which means we are accepting the drop. If we return NSDragOperationNone, then we are not accepting the drop.
    NSDragOperation result = NSDragOperationGeneric;
    

        // Check to see what we are proposed to be dropping on
        DPUIStyle *targetNode = item;
        // A target of "nil" means we are on the main root tree
        if (targetNode == nil) {
            targetNode = self.rootNode;
        }
        DPUIStyle *nodeData = targetNode;
        if (!nodeData.isLeaf) {
            // See if we allow dropping "on" or "between"
            if (childIndex == NSOutlineViewDropOnItemIndex) {

            } else {

            }
        } else {
            // The target node is not a container, but a leaf. See if we allow dropping on a leaf. If we don't, refuse the drop (we may get called again with a between)
            result= NSDragOperationNone;
        }
        
        // If we are allowing the drop, we see if we are draggng from ourselves and dropping into a descendent, which wouldn't be allowed...
        if (result != NSDragOperationNone) {
            // Indicate that we will animate the drop items to their final location
            info.animatesToDestination = YES;
            if ([self _dragIsLocalReorder:info]) {
                if (targetNode != self.rootNode) {
                    for (DPUIStyle *draggedNode in _draggedNodes) {
                        if ([self treeNode:self.rootNode isDescendantOfNode:draggedNode]) {
                            // Yup, it is, refuse it.
                            result = NSDragOperationNone;
                            break;
                        }
                    }
                }
            }
        }
    
    
    // To see what we decide to return, uncomment this line
    //    NSLog(result == NSDragOperationNone ? @" - Refusing drop" : @" + Accepting drop");
    
    return result;
}

- (BOOL)treeNode:(DPUIStyle *)treeNode isDescendantOfNode:(DPUIStyle *)parentNode {
    
    return [parentNode.children containsObject:treeNode];
    
}


- (BOOL)outlineView:(NSOutlineView *)ov acceptDrop:(id <NSDraggingInfo>)info item:(id)item childIndex:(NSInteger)childIndex {
    DPUIStyle *targetNode = item;
    // A target of "nil" means we are on the main root tree
    if (targetNode == nil) {
        targetNode = self.rootNode;
    }
    DPUIStyle *nodeData = targetNode;
	
    // Determine the parent to insert into and the child index to insert at.
    if (nodeData.isLeaf) {
        // If our target is a leaf, and we are dropping on it
        if (childIndex == NSOutlineViewDropOnItemIndex) {
            // If we are dropping on a leaf, we will have to turn it into a container node
            nodeData.isLeaf = YES;
            childIndex = 0;
        } else {
            // We will be dropping on the item's parent at the target index of this child, plus one
            DPUIStyle *oldTargetNode = targetNode;
            targetNode = [targetNode parentNode];
            childIndex = [[targetNode children] indexOfObject:oldTargetNode] + 1;
        }
    } else {
        if (childIndex == NSOutlineViewDropOnItemIndex) {
            // Insert it at the start, if we were dropping on it
            childIndex = 0;
        }
    }
    
    // Group all insert or move animations together
    [self.styleOutlineView beginUpdates];
    // If the source was ourselves, we use our dragged nodes and do a reorder
    if ([self _dragIsLocalReorder:info]) {
        [self _performDragReorderWithDragInfo:info parentNode:targetNode childIndex:childIndex];
    } else {
        [self _performInsertWithDragInfo:info parentNode:targetNode childIndex:childIndex];
    }
    [self.styleOutlineView endUpdates];
	
    // Return YES to indicate we were successful with the drop. Otherwise, it would slide back the drag image.
    return YES;
}

//- (BOOL)_dragIsLocalReorder:(id <NSDraggingInfo>)info {
//    return YES;
//}


- (BOOL)_dragIsLocalReorder:(id <NSDraggingInfo>)info {
    // It is a local drag if the following conditions are met:
    if ([info draggingSource] == self.styleOutlineView) {
        // We were the source
        if (_draggedNodes != nil) {
            // Our nodes were saved off
            if ([[info draggingPasteboard] availableTypeFromArray:[NSArray arrayWithObject:LOCAL_REORDER_PASTEBOARD_TYPE]] != nil) {
                // Our pasteboard marker is on the pasteboard
                return YES;
            }
        }
    }
    return NO;
}

- (void)_performInsertWithDragInfo:(id <NSDraggingInfo>)info parentNode:(DPUIStyle *)parentNode childIndex:(NSInteger)childIndex {
    // NSOutlineView's root is nil
    id outlineParentItem = parentNode == self.rootNode ? nil : parentNode;
    NSMutableArray *childNodeArray = [parentNode children];
    NSInteger outlineColumnIndex = [[_outlineView tableColumns] indexOfObject:[_outlineView outlineTableColumn]];
    
    // Enumerate all items dropped on us and create new model objects for them
    NSArray *classes = [NSArray arrayWithObject:[DPUIStyle class]];
    __block NSInteger insertionIndex = childIndex;
    [info enumerateDraggingItemsWithOptions:0 forView:_outlineView classes:classes searchOptions:nil usingBlock:^(NSDraggingItem *draggingItem, NSInteger index, BOOL *stop) {
        DPUIStyle *newNodeData = (DPUIStyle *)draggingItem.item;
        // Wrap the model object in a tree node
        // Add it to the model
        [childNodeArray insertObject:newNodeData atIndex:insertionIndex];
        [_outlineView insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:insertionIndex] inParent:outlineParentItem withAnimation:NSTableViewAnimationEffectGap];
        // Update the final frame of the dragging item
        NSInteger row = [_outlineView rowForItem:newNodeData];
        draggingItem.draggingFrame = [_outlineView frameOfCellAtColumn:outlineColumnIndex row:row];
        
        // Insert all children one after another
        insertionIndex++;
    }];
    
}

- (void)_performDragReorderWithDragInfo:(id <NSDraggingInfo>)info parentNode:(DPUIStyle *)newParent childIndex:(NSInteger)childIndex {
    // We will use the dragged nodes we saved off earlier for the objects we are actually moving
    
    NSMutableArray *childNodeArray = [newParent children];
    
    // We want to enumerate all things in the pasteboard. To do that, we use a generic NSPasteboardItem class
    NSArray *classes = [NSArray arrayWithObject:[NSPasteboardItem class]];
    __block NSInteger insertionIndex = childIndex;
    [info enumerateDraggingItemsWithOptions:0 forView:self.styleOutlineView classes:classes searchOptions:nil usingBlock:^(NSDraggingItem *draggingItem, NSInteger index, BOOL *stop) {
        // We ignore the draggingItem.item -- it is an NSPasteboardItem. We only care about the index. The index is deterministic, and can directly be used to look into the initial array of dragged items.
        DPUIStyle *draggedTreeNode = [_draggedNodes objectAtIndex:index];
        
        // Remove this node from its old location
        DPUIStyle *oldParent = [draggedTreeNode parentNode];
        NSMutableArray *oldParentChildren = [oldParent children];
        NSInteger oldIndex = [oldParentChildren indexOfObject:draggedTreeNode];
        [oldParentChildren removeObjectAtIndex:oldIndex];
        // Tell the table it is going away; make it pop out with NSTableViewAnimationEffectNone, as we will animate the draggedItem to the final target location.
        // Don't forget that NSOutlineView uses 'nil' as the root parent.
        [self.styleOutlineView removeItemsAtIndexes:[NSIndexSet indexSetWithIndex:oldIndex] inParent:oldParent == self.rootNode ? nil : oldParent withAnimation:NSTableViewAnimationEffectNone];
        
        // Insert this node into the new location and new parent
        if (oldParent == newParent) {
            // Moving it from within the same parent! Account for the remove, if it is past the oldIndex
            if (insertionIndex > oldIndex) {
                insertionIndex--; // account for the remove
            }
        }
        [childNodeArray insertObject:draggedTreeNode atIndex:insertionIndex];
        
        // Tell NSOutlineView about the insertion; let it leave a gap for the drop animation to come into place
        [self.styleOutlineView insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:insertionIndex] inParent:newParent == self.rootNode ? nil : newParent withAnimation:NSTableViewAnimationEffectGap];
        
        insertionIndex++;
    }];
    
    // Now that the move is all done (according to the table), update the draggingFrames for the all the items we dragged. -frameOfCellAtColumn:row: gives us the final frame for that cell
    NSInteger outlineColumnIndex = [[self.styleOutlineView tableColumns] indexOfObject:[self.styleOutlineView outlineTableColumn]];
    [info enumerateDraggingItemsWithOptions:0 forView:self.styleOutlineView classes:classes searchOptions:nil usingBlock:^(NSDraggingItem *draggingItem, NSInteger index, BOOL *stop) {
        DPUIStyle *draggedTreeNode = [_draggedNodes objectAtIndex:index];
        NSInteger row = [self.styleOutlineView rowForItem:draggedTreeNode];
        draggingItem.draggingFrame = [self.styleOutlineView frameOfCellAtColumn:outlineColumnIndex row:row];
    }];
    
}

/* In 10.7 multiple drag images are supported by using this delegate method. */
- (id <NSPasteboardWriting>)outlineView:(NSOutlineView *)outlineView pasteboardWriterForItem:(id)item {
    return (id <NSPasteboardWriting>)item;
}

/* Setup a local reorder. */
- (void)outlineView:(NSOutlineView *)outlineView draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint forItems:(NSArray *)draggedItems {
    _draggedNodes = draggedItems;
    [[DPStyleManager sharedInstance] setGlobalDraggedItem:_draggedNodes];
    [session.draggingPasteboard setData:[NSData data] forType:LOCAL_REORDER_PASTEBOARD_TYPE];
}

- (void)outlineView:(NSOutlineView *)outlineView draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint operation:(NSDragOperation)operation {
    // If the session ended in the trash, then delete all the items
//    if (operation == NSDragOperationDelete) {
//        [_outlineView beginUpdates];
//        
//        [_draggedNodes enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id node, NSUInteger index, BOOL *stop) {
//            id parent = [node parentNode];
//            NSMutableArray *children = [parent mutableChildNodes];
//            NSInteger childIndex = [children indexOfObject:node];
//            [children removeObjectAtIndex:childIndex];
//            [_outlineView removeItemsAtIndexes:[NSIndexSet indexSetWithIndex:childIndex] inParent:parent == _rootTreeNode ? nil : parent withAnimation:NSTableViewAnimationEffectFade];
//        }];
//        
//        [_outlineView endUpdates];
//    }
    
    _draggedNodes = nil;
}

// The NSOutlineView uses 'nil' to indicate the root item. We return our root tree node for that case.
- (NSArray *)childrenForItem:(id)item {
    if (item == nil) {
        return [self.rootNode children];
    } else {
        return [item children];
    }
}

// Required methods.
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    // 'item' may potentially be nil for the root item.
    NSArray *children = [self childrenForItem:item];
    // This will return an NSTreeNode with our model object as the representedObject
    return [children objectAtIndex:index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    // 'item' will always be non-nil. It is an NSTreeNode, since those are always the objects we give NSOutlineView. We access our model object from it.
    DPUIStyle *nodeData = item;
    // We can expand items if the model tells us it is a container
    return !nodeData.isLeaf;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    // 'item' may potentially be nil for the root item.
    NSArray *children = [self childrenForItem:item];
    return [children count];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    id objectValue = nil;
	
	if (outlineView == self.colorOutlineView) {
		DPStyleColor *color = item;
		objectValue = color.colorVar;
	} else {
    DPUIStyle *nodeData = item;
    
    objectValue = nodeData.styleName;
	}
    
    return objectValue;
}

// Optional method: needed to allow editing.
- (void)outlineView:(NSOutlineView *)ov setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item  {
  
	if (ov == self.colorOutlineView) {
		DPStyleColor *color = item;
		color.colorVar = object;
	} else {
	DPUIStyle *nodeData = item;
    
    // Here, we manipulate the data stored in the node.
        nodeData.styleName = object;
	}
}

// We can return a different cell for each row, if we want
- (NSCell *)outlineView:(NSOutlineView *)ov dataCellForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
//    // If we return a cell for the 'nil' tableColumn, it will be used as a "full width" cell and span all the columns
//    if ([useGroupRowLook state] && (tableColumn == nil)) {
//        SimpleNodeData *nodeData = [item representedObject];
//        if (nodeData.container) {
//            // We want to use the cell for the name column, but we could construct a new cell if we wanted to, or return a different cell for each row.
//            return [[_outlineView tableColumnWithIdentifier:COLUMNID_NAME] dataCell];
//        }
//    }
    return nil;
}

- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(ImageAndTextCell *)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    
	if (outlineView == self.styleOutlineView) {
	
    DPUIStyle *style = item;
    if (!style.isLeaf) {
        cell.image = [NSImage imageNamed:@"FolderGeneric.png"];
        cell.stringValue = style.styleName;
    } else {
        cell.image = [NSImage imageNamed:@"styleIcon.png"];
        cell.stringValue = style.styleName;
    }
	} else if (outlineView == self.colorOutlineView) {
		
		DPStyleColor *style = item;
		if (!style.isLeaf) {
			cell.image = [NSImage imageNamed:@"FolderGeneric.png"];
			cell.stringValue = style.colorVar;
		} else {
			cell.image = style.imageRep;
			cell.stringValue = style.colorVar;
		}
	}
    
}

// To get the "group row" look, we implement this method.
- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item {
    return NO;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldExpandItem:(id)item {
    // Query our model for the answer to this question
    DPUIStyle *nodeData = item;
    return !nodeData.isLeaf;
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {

    DPUIStyle *node = [_outlineView itemAtRow:[_outlineView selectedRow]];
    if (node.isLeaf) {
        self.stylesController.selectedObjects = @[node];
    }
}

- (NSArray*)getFlatStylesArray
{
    return [self stylesForParent:self.rootNode];
}

- (NSArray*)stylesForParent:(DPUIStyle*)parent
{
    NSMutableArray *tmp = [NSMutableArray new];
    for (DPUIStyle *style in parent.children) {
        if (style.isLeaf) {
            [tmp addObject:style];
        } else {
            [tmp addObjectsFromArray:[self stylesForParent:style]];
        }
    }
    
    return tmp;
}

#pragma mark - split view delegate
- (NSRect)splitView:(NSSplitView *)splitView effectiveRect:(NSRect)proposedEffectiveRect forDrawnRect:(NSRect)drawnRect ofDividerAtIndex:(NSInteger)dividerIndex
{
    return NSZeroRect;
}

static NSTableView *lastSelectedTableView = nil;

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
	NSTableView *tableView = aNotification.object;
	
	if (tableView != lastSelectedTableView) {
		if ([[NSColorPanel sharedColorPanel] isVisible]) {
            if (![tableView.associatedColorWell isActive]) 
			[tableView.associatedColorWell performClick:nil];
		}
	} else {
	
	if (tableView.associatedColorWell) {
        if (![tableView.associatedColorWell isActive])

		[tableView.associatedColorWell performClick:nil];
	}
	}
	
	lastSelectedTableView = tableView;
}


- (IBAction)tableClicked:(id)sender
{

	id object = sender;
	if (object == self.styleOutlineView) {
		if (self.stylesController.selectedObjects.count > 0) {
			[self.sliderStylesController setSelectedObjects:nil];
			[self.imageStylesController setSelectedObjects:nil];
			[self.classStylesListController setSelectedObjects:nil];
			
			if (!self.viewStyleTabs.window) {
				[self emptyPropertiesContainer];
				
				self.viewStyleTabs.frame = self.propertiesContainerView.bounds;
				[self.propertiesContainerView addSubview:self.viewStyleTabs];
			}
		}
		
	} else if (object == self.sliderStylesTable) {
		if (self.sliderStylesController.selectedObjects.count > 0) {
			[self.stylesController setSelectedObjects:nil];
			[self.imageStylesController setSelectedObjects:nil];
			[self.classStylesListController setSelectedObjects:nil];
			
			if (!self.sliderStyleTabs.window) {
				[self emptyPropertiesContainer];
				
				self.sliderStyleTabs.frame = self.propertiesContainerView.bounds;
				[self.propertiesContainerView addSubview:self.sliderStyleTabs];
			}
		}
		
	} else if (object == self.imageStylesTable) {
		if (self.imageStylesController.selectedObjects.count > 0) {
			[self.stylesController setSelectedObjects:nil];
			[self.sliderStylesController setSelectedObjects:nil];
			[self.classStylesListController setSelectedObjects:nil];
			
			
			if (!self.imageStyleTabs.window) {
				[self emptyPropertiesContainer];
				
				self.imageStyleTabs.frame = self.propertiesContainerView.bounds;
				[self.propertiesContainerView addSubview:self.imageStyleTabs];
			}
		}
	} else if (object == self.classStylesListTable) {
		if (self.classStylesListController.selectedObjects.count > 0) {
			[self.stylesController setSelectedObjects:nil];
			[self.sliderStylesController setSelectedObjects:nil];
			[self.imageStylesController setSelectedObjects:nil];
			
			
			if (!self.classStyleView.window) {
				[self emptyPropertiesContainer];
				
				self.classStyleView.frame = self.propertiesContainerView.bounds;
				[self.propertiesContainerView addSubview:self.classStyleView];
			}
		}
	}
	
	
	NSTableView *tableView = sender;
	if (tableView.associatedColorWell) {
		if (tableView != lastSelectedTableView) {
			if ([[NSColorPanel sharedColorPanel] isVisible]) {
				if (![tableView.associatedColorWell isActive]) {
					
					[tableView.associatedColorWell performClick:nil];
				}
			}
		}
		lastSelectedTableView = tableView;
	}
}

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex
{
	
	return YES;
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn
{

	if (tableView != lastSelectedTableView) {
		if ([[NSColorPanel sharedColorPanel] isVisible]) {
            if (![tableView.associatedColorWell isActive]) {
                [tableView.associatedColorWell performClick:nil];
            }
		}
	}
	lastSelectedTableView = tableView;

}

- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	if ([[tableColumn identifier] isEqualToString:@"valueColumn"]) {
		
		NSPopUpButtonCell *cell = [tableColumn dataCellForRow:row];
		
		DPUICustomSetting *setting = self.customSettingsController.arrangedObjects[row];
		
		[cell removeAllItems];
		[cell addItemsWithTitles:setting.possibleValues];
		
		return cell;
		
		
	} else if ([[tableColumn identifier] isEqualToString:@"classStylesValueColumn"]) {
		
		NSPopUpButtonCell *cell = [tableColumn dataCellForRow:row];
		
		DPUICustomSetting *setting = self.classStylesAttributesController.arrangedObjects[row];
		
		[cell removeAllItems];
		[cell addItemsWithTitles:setting.possibleValues];
		
		return cell;
		
	} else {
		return [tableColumn dataCellForRow:row];
	}
	
	return nil;
}

- (IBAction)newCustomSetting:(id)sender
{
//	DPUICustomSetting *setting = [[DPUICustomSetting alloc] init];
//	
//	DPUIStyle *selectedStyle = self.stylesController.selectedObjects[0];
//	[selectedStyle.customSettings addObject:setting];
//	
//	[self.customSettingsTable reloadData];
	
	
}

- (NSArray*)customSettingTypeKeys
{
	return [DPUICustomSetting keyPathTypes];
}


- (IBAction)deleteCustomSetting:(id)sender
{
	
}

- (void)setIconKey:(NSString *)iconKey
{
	[self willChangeValueForKey:iconKey];
	_iconKey = iconKey;
	[self didChangeValueForKey:iconKey];
	
	self.exampleView.iconKey = iconKey;
}

- (NSArray*)availableIconKeys
{
	if (!_availableIconKeys) {
		[self willChangeValueForKey:@"availableIconKeys"];
		_availableIconKeys = self.exampleView.iconDictionary.allKeys;
		_availableIconKeys = [_availableIconKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
		[self didChangeValueForKey:@"availableIconKeys"];
		
		
	}
	return _availableIconKeys;
}

- (NSArray*)availableIconImages
{
	if (!_availableIconImages) {
		
		NSMutableArray *tmp = [NSMutableArray new];
		for (NSString *key in self.availableIconKeys) {
			[tmp addObject:[self menuImageForIcon:key]];
		}
		_availableIconImages = tmp;
		
	}
	return _availableIconImages;
}

- (NSImage*)menuImageForIcon:(NSString*)icon
{
	NSImage *image = [NSImage imageWithSize:NSMakeSize(35, 35) flipped:NO drawingHandler:^BOOL(NSRect dstRect) {

	NSString *svgString = [self.exampleView.iconDictionary objectForKey:icon];
	
	NSBezierPath *path = [NSBezierPath bezierPathWithSVGString:svgString];
	CGSize size = CGSizeMake(35, 35);
	CGSize currentSize = path.bounds.size;
	
	CGFloat scale;
	
	if (currentSize.width > currentSize.height) {
		scale = (size.width) / currentSize.width/1.5;
	} else {
		scale = (size.height) / currentSize.height/1.5;
	}
	
	NSAffineTransform *trans = [NSAffineTransform transform];
	[trans scaleXBy:scale yBy:-scale];
	[path transformUsingAffineTransform:trans];
	
	trans = [NSAffineTransform transform];
	
	[trans translateXBy:-(path.bounds.origin.x)*(1-(1/size.width)) yBy:-(path.bounds.origin.y) *(1-(1 /size.height))];
	[path transformUsingAffineTransform:trans];
	
	trans = [NSAffineTransform transform];
	
	CGFloat xTrans = ((size.width-path.bounds.size.width)/2);// + path.bounds.size.width/2;
	CGFloat yTrans = ((size.height-path.bounds.size.height)/2);// - path.bounds.size.height;
															   //xTrans = 0;
		//	yTrans = 0;
		[trans translateXBy:(xTrans)*(1-(1/path.bounds.size.width)) yBy:(yTrans) *(1-(1 / path.bounds.size.height))];
	[path transformUsingAffineTransform:trans];
	
		
		[[NSColor blackColor] setFill];
		[path fill];
		return YES;
	}];
	return image;
}

- (void)menuNeedsUpdate:(NSMenu *)menu
{
	int x = 0;
	for (NSMenuItem *item in menu.itemArray) {
		
		if (x >= self.availableIconImages.count) break;
		
		NSImage *img = self.availableIconImages[x];
		[item setImage:img];
		//[item setOffStateImage:img];
		
		x+=1;
	}
}

@end
