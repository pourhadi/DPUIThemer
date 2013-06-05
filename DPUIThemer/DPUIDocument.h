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
#import"DPUICustomSetting.h"
#import "ACTGradientEditor.h"
#import "CNSplitView.h"
#import "XcodeEditor.h"
static NSString * const kBackgroundTransparent = @"Transparent";
static NSString *const kBackgroundPreviewColor = @"Use preview background color";
static NSString *const kBackgroundCustomColor = @"Custom color:";

typedef NS_OPTIONS(NSUInteger, CornerRadiusType) {
	CornerRadiusTypeCustom,
	CornerRadiusTypeHalfHeight,
	CornerRadiusTypeHalfWidth,
};

typedef NS_OPTIONS(NSUInteger, ViewCanvasBackgroundType) {
	ViewCanvasBackgroundTypeTransparent = 0,
	ViewCanvasBackgroundTypePreviewColor = 1,
	ViewCanvasBackgroundTypeCustomColor = 2,
};

@interface GradientColor : NSObject



@end

@interface DYNNode : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *children;

@property (nonatomic) BOOL isLeaf;

@property (nonatomic, strong) id object;

- (NSImage*)image;

@end

@interface DYNMoreOption : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber* index;

@end

@interface DPUIStyle : NSObject <NSCopying, NSCoding, NSPasteboardReading, NSPasteboardWriting>

@property (nonatomic, weak) DPUIStyle *parentNode;
@property (nonatomic) NSInteger count;
@property (nonatomic) BOOL isLeaf;
@property (nonatomic, strong) NSMutableArray *children;

@property (nonatomic) CGFloat gradientAngle;
@property (nonatomic, strong) NSString *styleName;
@property (nonatomic, strong) NSMutableArray *bgColors;
@property (nonatomic, strong) NSMutableArray *bgLocations;
@property (nonatomic) NSInteger bgDegrees;
@property (nonatomic, strong) NSMutableArray *topInnerBorders;
@property (nonatomic, strong) NSMutableArray *bottomInnerBorders;

@property (nonatomic, strong) NSMutableArray *leftInnerBorders;
@property (nonatomic, strong) NSMutableArray *rightInnerBorders;

@property (nonatomic, strong) DPStyleShadow *innerShadow;
@property (nonatomic, strong) DPStyleShadow *shadow;

@property (nonatomic) CGSize cornerRadii;
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic, strong) NSNumber* cornerRadiusType;
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

@property (nonatomic) CGFloat startX;
@property (nonatomic) CGFloat startY;
@property (nonatomic) CGFloat endX;
@property (nonatomic) CGFloat endY;

// UISearchBar

@property (nonatomic, strong) NSString *searchBarTextFieldStyleName;
@property (nonatomic, strong) NSString *searchFieldTextStyleName;
// Navigation bar

@property (nonatomic, strong) NSString *navBarTitleTextStyle;

// UITableViewCell styles

@property (nonatomic, strong) NSString *tableCellTitleTextStyle;
@property (nonatomic, strong) NSString *tableCellDetailTextStyle;
@property (nonatomic, strong) NSString *tableCellSelectedStyleName;

// UIBarButtonItem

@property (nonatomic, strong) NSString *barButtonItemStyleName;

// controls

@property (nonatomic, strong) DPUIControlStyle *controlStyle;

// UITextField

@property (nonatomic, strong) NSString *textFieldTextStyleName;


// UISegmentedControl

@property (nonatomic, strong) DPUIControlStyle *segmentedControlStyle;
@property (nonatomic, strong) NSNumber * segmentDividerWidth;
@property (nonatomic, strong) DPStyleColor *segmentDividerColor;

// UITableView - grouped
@property (nonatomic, strong) NSString *groupedTableTopCell;
@property (nonatomic, strong) NSString *groupedTableMiddleCell;
@property (nonatomic, strong) NSString *groupedTableSingleCell;
@property (nonatomic, strong) NSString *groupedTableBottomCell;

// Custom settings
@property (nonatomic, strong) NSMutableArray *customSettings;

- (id)initWithDictionary:(NSDictionary*)dictionary;
- (id)jsonValue;



@end

@interface DPUIDocument : NSDocument <NSTableViewDataSource, NSTableViewDelegate, ManagerDelegate, NSOutlineViewDataSource, NSOutlineViewDelegate, NSSplitViewDelegate, NSMenuDelegate, GradientEditorDelegate>
{
}

@property (nonatomic, strong) NSArray *flatStylesArray;
@property (nonatomic, strong) DPUIStyle *rootNode;
@property (nonatomic, weak) IBOutlet NSOutlineView *styleOutlineView;
@property (nonatomic, strong) IBOutlet NSTreeController *styleTreeController;
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

@property (nonatomic, strong) IBOutlet NSTabView *viewStyleTabs;
@property (nonatomic, strong) IBOutlet NSTabView *sliderStyleTabs;

@property (nonatomic, strong) NSMutableArray *sliderStyles;
@property (nonatomic, strong) IBOutlet NSArrayController *sliderStylesController;

@property (nonatomic, strong) IBOutlet NSView *propertiesContainerView;
@property (nonatomic, strong) IBOutlet NSTableView *sliderStylesTable;

@property (nonatomic, strong) IBOutlet NSView *controlStateView;
@property (nonatomic, strong) IBOutlet NSView *searchFieldView;
@property (nonatomic, strong) IBOutlet NSView *navigationBarView;
@property (nonatomic, strong) IBOutlet NSView *tableViewCellView;
@property (nonatomic, strong) IBOutlet NSView *moreContainerView;
@property (nonatomic, strong) IBOutlet NSOutlineView *moreOutlineView;

@property (nonatomic, strong) NSArray *moreSelectionOptions;

@property (nonatomic, strong) NSMutableArray *imageStyles;
@property (nonatomic, strong) IBOutlet NSArrayController *imageStylesController;
@property (nonatomic, strong) IBOutlet NSTabView *imageStyleTabs;
@property (nonatomic, strong) IBOutlet NSTableView *imageStylesTable;
@property (nonatomic, weak) IBOutlet NSOutlineView *colorOutlineView;
@property (nonatomic, weak) IBOutlet NSSegmentedControl *colorsSeg;

@property (nonatomic, weak) IBOutlet NSTableView *customSettingsTable;

@property (nonatomic, strong) NSArray *customSettingTypeKeys;

@property (nonatomic, strong) IBOutlet NSArrayController *customSettingsController;

@property (nonatomic, weak) IBOutlet NSPopUpButton *iconPopup;

@property (nonatomic, strong) NSString *iconKey;

@property (nonatomic, strong) NSArray *availableIconKeys;
@property (nonatomic, strong) NSArray *availableIconImages;

@property (nonatomic, strong) IBOutlet NSBox *classStyleView;
@property (nonatomic, strong) IBOutlet NSTableView *classStylesListTable;
@property (nonatomic, strong) IBOutlet NSArrayController *classStylesListController;
@property (nonatomic, strong) IBOutlet NSArrayController *classStylesAttributesController;

@property (nonatomic, strong) NSArray *classStyles;

@property (nonatomic, strong) NSNumber *scale;

@property (nonatomic, strong) IBOutlet ACTGradientEditor *gradientEditor;

@property (nonatomic, strong) IBOutlet NSArrayController *bgColorsController;

@property (nonatomic, strong) DPStyleColor *currentlySelectedColor;

@property (nonatomic, weak) IBOutlet CNSplitView *mainSplitView;
@property (nonatomic, weak) IBOutlet CNSplitView *sourceSplitView;

@property (nonatomic, strong) NSString *dynUILibraryPath;
@property (nonatomic, strong) NSString *projectPath;

@property (nonatomic, strong) NSArray *projectTargets;
@property (nonatomic, strong) IBOutlet NSArrayController *projectTargetsController;

@property (nonatomic, strong) IBOutlet NSPanel *selectTargetsPanel;

@end
