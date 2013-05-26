//
//  DPUIExampleView.h
//  DPUIThemer
//
//  Created by Daniel Pourhadi on 4/30/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DPViewStyle.h"
#import "DPUIDefines.h"
#import "DYNSliderStyle.h"
@class DPUIStyle;
@interface DPUIExampleView : NSView
@property (nonatomic, strong) NSColor *containerColor;
@property (nonatomic, strong) DYNSliderStyle *sliderStyle;
@property (nonatomic, strong) DPUIStyle *style;
@property (nonatomic, strong) DPUIStyle *imageStyle;
@property (nonatomic) CGFloat xScale;
@property (nonatomic) CGFloat yScale;

@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameHeight;

@property (nonatomic) CGRect drawRect;

@property (nonatomic, strong) NSString *iconKey;

@property (nonatomic, strong) NSDictionary *iconDictionary;
@end
