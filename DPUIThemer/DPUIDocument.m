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


@implementation DPUIStyle

- (id)init
{
	self = [super init];
	if (self) {
		self.bgColors = [NSMutableArray new];
		self.topInnerBorders = [NSMutableArray new];
		self.bottomInnerBorders = [NSMutableArray new];
		self.innerShadow = [[DPStyleShadow alloc] init];
		self.shadow = [[DPStyleShadow alloc] init];
		self.bgDegrees = 0;
        self.styleName = [DPUIStyle newStyleVariableName];
		self.canvasBackgroundColor = [NSColor clearColor];
		//self.navBarTitleTextStyle = [[DPUITextStyle alloc] init];
		//self.tableCellTitleTextStyle = [[DPUITextStyle alloc] init];
		//self.tableCellDetailTextStyle = [[DPUITextStyle alloc] init];
	}
	return self;
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
@end

@implementation DPUIDocument

- (id)init
{
    self = [super init];
    if (self) {
		[[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
		[[NSColorPanel sharedColorPanel] setContinuous:YES];
		[NSColor setIgnoresAlpha:NO];
		[NSValueTransformer setValueTransformer:[[ColorTransformer alloc] init] forName: @"ColorTransformer"];
		self.styles = [NSMutableArray new];
		self.exampleContainerBgColor = [NSColor colorWithCalibratedHue:0 saturation:0 brightness:0.2 alpha:1];
		self.colorVars = [NSMutableArray new];        
		self.textStyles = [NSMutableArray new];
		self.textExampleContainerBgColor = [NSColor whiteColor];
	}
    return self;
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
	
//	
//	self.style = [[DPViewStyle alloc] init];
//	self.style.background = [[DPStyleBackground alloc] init];
//	DPStyleColor *white = [[DPStyleColor alloc] init];
//	white.colorName = @"white";
//	white.color = [NSColor whiteColor];
//	DPStyleColor *black = [[DPStyleColor alloc] init];
//	black.colorName = @"black";
//	black.color = [NSColor blackColor];
//	
//	self.style.background.colors = @[white, black];
//	self.style.background.locations = @[@(0.0),@(1.0)];
//	
//	DPStyleInnerBorder *top = [[DPStyleInnerBorder alloc] init];
//	top.color = black;
//	top.height = 1;
//	top.blendMode = 5;
//	self.style.topInnerBorders = @[top];
//
	if (self.updateTimer) {
		[self.updateTimer invalidate];
		self.updateTimer = nil;
	}
	self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(styleChanged) userInfo:nil repeats:YES];
    
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
		DPUIStyle *new = [[DPUIStyle alloc] init];
        
		new.styleName = [style objectForKey:@"name"];
		NSDictionary *bg = [style objectForKey:@"background"];
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
		
		if ([style objectForKey:@"barButtonItemTextStyle"]) {
			new.barButtonItemTextStyle = [[DPUITextStyle alloc] initWithDictionary:[style objectForKey:@"barButtonItemTextStyle"]];
		}
		
		if ([style objectForKey:@"barButtonItemStyleName"]) {
			new.barButtonItemStyleName = [style objectForKey:@"barButtonItemStyleName"];
		}
		
        [newStyles addObject:new];
	}
	
	self.styles = newStyles;
	
	[self.colorTable reloadData];
	[self.styleTable reloadData];
}

- (DPUIStyle*)currentStyle
{
	if (self.stylesController.selectedObjects && self.stylesController.selectedObjects.count > 0) {
		return self.stylesController.selectedObjects[0];
	}
	return nil;
}

- (IBAction)styleChanged
{
	[[DPStyleManager sharedInstance] setColorVariables:self.colorVars];
	[[DPStyleManager sharedInstance] setStyles:self.styles];
	if (self.stylesController.selectedObjects && self.stylesController.selectedObjects.count > 0) {
		[[DPStyleManager sharedInstance] setCurrentStyle:self.stylesController.selectedObjects[0]];
		self.exampleView.style = self.stylesController.selectedObjects[0];

		[self.bottomInnerBorderTable reloadData];
		[self.topInnerBorderTable reloadData];
		[self.backgroundColorsTable reloadData];
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
		NSMutableDictionary *dictionary = [NSMutableDictionary new];
		[dictionary setObject:style.styleName forKey:@"name"];
		NSMutableDictionary *bg = [NSMutableDictionary new];
		NSMutableArray *bgColors = [NSMutableArray new];
		for (DPStyleColor *color in style.bgColors) {
			[bgColors addObject:color.jsonValue];
		}
		// background
		[bg setObject:bgColors forKey:@"colors"];
		
		[dictionary setObject:bg forKey:@"background"];
		
		// top inner borders
		NSArray *topinnerborders = [style.topInnerBorders valueForKeyPath:@"jsonValue"];
		[dictionary setObject:topinnerborders forKey:@"topInnerBorders"];
		
		// bottom inner borders
		NSArray *bottom = [style.bottomInnerBorders valueForKeyPath:@"jsonValue"];
		[dictionary setObject:bottom forKey:@"bottomInnerBorders"];
		
		//NSDictionary *cornerRadii = (__bridge NSDictionary *)(CGSizeCreateDictionaryRepresentation(style.cornerRadii));
		[dictionary setObject:@(style.cornerRadius) forKey:@"cornerRadius"];
		[dictionary setObject:@(style.roundedCorners) forKey:@"roundedCorners"];
		[dictionary setObject:style.innerShadow.jsonValue forKey:@"innerShadow"];
		[dictionary setObject:style.shadow.jsonValue forKey:@"shadow"];
		
		NSColor *canvasBgColor = [NSColor clearColor];
		if ([style.canvasBackgroundType isEqualToString:kBackgroundPreviewColor]) {
			canvasBgColor = self.exampleContainerBgColor;
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
		
		if (style.barButtonItemTextStyle) {
			[dictionary setObject:style.barButtonItemTextStyle.jsonValue forKey:@"barButtonItemTextStyle"];
		}
		
		if (style.barButtonItemStyleName) {
			[dictionary setObject:style.barButtonItemStyleName forKey:@"barButtonItemStyleName"];
		}
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
	
	NSError *error;
	NSData *json = [NSJSONSerialization dataWithJSONObject:container options:0 error:&error];
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

	self.currentStyle.roundedCorners = corners;
	self.exampleView.style = self.stylesController.selectedObjects[0];

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

@end
