//
//  DPUIDocument.h
//  DPUIThemer
//
//  Created by Daniel Pourhadi on 4/30/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DPViewStyle.h"
#import "DPUIExampleView.h"
#import "NSBezierPath+GTMBezierPathRoundRectAdditions.h"
#import "DPUITextStyleExampleView.h"
#import "DPStyleManager.h"
#import "DPUIControlStyle.h"
#import "DPUIParameter.h"
static NSString *kBackgroundTransparent = @"Transparent";
static NSString *kBackgroundPreviewColor = @"Use preview background color";
static NSString *kBackgroundCustomColor = @"Custom color:";

typedef NS_OPTIONS(NSUInteger, ViewCanvasBackgroundType) {
	ViewCanvasBackgroundTypeTransparent = 0,
	ViewCanvasBackgroundTypePreviewColor = 1,
	ViewCanvasBackgroundTypeCustomColor = 2,
};

@interface DPUIStyle : NSObject <NSCopying, NSCoding>

@property (nonatomic, strong) NSString *styleName;
@property (nonatomic, strong) NSMutableArray *bgColors;
@property (nonatomic) NSInteger bgDegrees;
@property (nonatomic, strong) NSMutableArray *topInnerBorders;
@property (nonatomic, strong) NSMutableArray *bottomInnerBorders;

@property (nonatomic, strong) DPStyleShadow *innerShadow;
@property (nonatomic, strong) DPStyleShadow *shadow;

@property (nonatomic) CGSize cornerRadii;
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) UIRectCorner roundedCorners;
@property (nonatomic) BOOL maskToCorners;

@property (nonatomic, strong) NSString *canvasBackgroundType;
@property (nonatomic, strong) NSColor *canvasBackgroundColor;

@property(nonatomic, strong) NSNumber *topLeftValue;
@property (nonatomic, strong) NSNumber *topRightValue;
@property (nonatomic, strong) NSNumber *bottomLeftValue;
@property (nonatomic, strong) NSNumber *bottomRightValue;

@property (nonatomic, strong) DPStyleColor *strokeColor;
@property (nonatomic) CGFloat strokeWidth;

@property (nonatomic) BOOL drawAsynchronously;


// Navigation bar

@property (nonatomic, strong) DPUITextStyle *navBarTitleTextStyle;

// UITableViewCell styles

@property (nonatomic, strong) DPUITextStyle *tableCellTitleTextStyle;
@property (nonatomic, strong) DPUITextStyle *tableCellDetailTextStyle;

// UIBarButtonItem

@property (nonatomic, strong) NSString *barButtonItemStyleName;

// controls

@property (nonatomic, strong) DPUIControlStyle *controlStyle;
@end

@interface DPUIDocument : NSDocument <NSTableViewDataSource, ManagerDelegate>
{
}
@property (nonatomic, weak) IBOutlet DPUIExampleView *exampleView;
@property (nonatomic, weak) IBOutlet DPUITextStyleExampleView *textExampleView;
@property (nonatomic, strong) IBOutlet DPViewStyle *style;
@property (nonatomic, strong) IBOutlet NSArrayController *stylesController;
@property (nonatomic, strong) IBOutlet NSArrayController *textStylesController;
@property (nonatomic, weak) IBOutlet NSTableView *styleTable;
@property (nonatomic, weak) IBOutlet NSTableView *colorTable;
@property (nonatomic, weak) IBOutlet NSTableView *backgroundColorsTable;
@property (nonatomic, weak) IBOutlet NSTableView *topInnerBorderTable;
@property (nonatomic, weak) IBOutlet NSTableView *bottomInnerBorderTable;
@property (nonatomic, strong) NSMutableArray *colorVars;

@property (nonatomic, strong) NSArray *colorAndParamVars;

@property (nonatomic, weak) DPUIStyle *currentStyle;

@property (nonatomic, weak) IBOutlet NSButton *topLeftCorner;
@property (nonatomic, weak) IBOutlet NSButton *topRightCorner;
@property (nonatomic, weak) IBOutlet NSButton *bottomLeftCorner;
@property (nonatomic, weak) IBOutlet NSButton *bottomRightCorner;

@property (nonatomic, strong) NSArray *viewCanvasBackgroundTypes;
@property (nonatomic, strong) NSArray *viewCanvasBackgroundValues;

@property (nonatomic, strong) NSMutableArray *styles;
@property (nonatomic, strong) NSMutableArray *controlStyles;

@property (nonatomic, strong) NSMutableArray *textStyles;

@property (nonatomic, strong) NSColor *exampleContainerBgColor;
@property (nonatomic, strong) NSColor *textExampleContainerBgColor;

@property (nonatomic, strong) IBOutlet NSPanel *constantsPanel;
@property (nonatomic, strong) IBOutlet NSTextView *constantsTextView;

@property (nonatomic, strong) NSString *constants;

@property (nonatomic, strong) NSArray *blendModes;

@property (nonatomic, strong) NSMutableArray *parameters;

@property (nonatomic, strong) IBOutlet NSPanel *parameterPanel;

@end
