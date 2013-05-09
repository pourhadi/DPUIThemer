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

@class DPUIStyle;
@interface DPUIExampleView : NSView
@property (nonatomic, strong) DPUIStyle *style;
@property (nonatomic) CGFloat xScale;
@property (nonatomic) CGFloat yScale;
@end
