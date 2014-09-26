//
//  GradientViewViewController.h
//  DPUIThemer
//
//  Created by Dan Pourhadi on 6/6/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ACTGradientEditor.h"
#import "DPStyleBackground.h"

@protocol GradientViewControllerDelegate <NSObject>

- (void)updateColors:(NSArray*)colors andLocations:(NSArray*)locations andAngle:(CGFloat)angle;

@end

@interface GradientViewViewController : NSViewController <GradientEditorDelegate>

@property (nonatomic, strong) NSArray *colorVariables;
@property (nonatomic, strong) IBOutlet NSArrayController *colorVariablesController;

@property (nonatomic, strong) NSArray *gradientColors;
@property (nonatomic, strong) IBOutlet NSArrayController *gradientColorsController;

@property (nonatomic, strong) NSArray *bgLocations;

@property (nonatomic) NSInteger selectedColorIndex;

@property (nonatomic, assign) DPStyleColor *selectedColor;

@property (nonatomic, weak) IBOutlet ACTGradientEditor *gradientEditor;

@property (nonatomic, strong) IBOutlet NSPopover *popover;

@property (nonatomic, weak) id<GradientViewControllerDelegate> delegate;

@property (nonatomic, weak) IBOutlet NSColorWell *colorWell;

@property (nonatomic, strong) NSNumber *selectedLocation;
@property (nonatomic, strong) NSNumber *gradientAngle;

@property (nonatomic) BOOL controlsEnabled;

- (void)selectKnobAtIndex:(NSInteger)index;

- (void)setGradientColors:(NSArray*)colors andLocations:(NSArray*)locations andAngle:(CGFloat)angle;

@end
