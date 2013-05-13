//
//  DYNSliderStyle.h
//  DPUIThemer
//
//  Created by Dan Pourhadi on 5/11/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPStyleBackground.h"
#import "DPStyleShadow.h"
#import "DPStyleObject.h"
@interface DYNSliderStyle : DPStyleObject <NSCopying, NSCoding>

@property (nonatomic) CGFloat strokeWidth;
@property (nonatomic, strong) DPStyleColor *strokeColor;
@property (nonatomic, strong) DPStyleShadow *outerShadow;
@property (nonatomic) CGFloat trackHeight; // in points
@property (nonatomic) CGFloat thumbHeight; // multiplier value; actual height of thumb is calculated as trackHeight * thumbHeight. default is 1.5

// minimum track image

@property (nonatomic, strong) DPStyleBackground *minimumTrackBackground;
@property (nonatomic, strong) DPStyleShadow *minimumTrackInnerShadow;

// maximum track image

@property (nonatomic, strong) DPStyleBackground *maximumTrackBackground;
@property (nonatomic, strong) DPStyleShadow *maximumTrackInnerShadow;

// thumb

@property (nonatomic, strong) NSString *thumbStyleName;

- (id)jsonValue;
- (id)initWithDictionary:(NSDictionary*)dictionary;


/// DPUITHEMER ONLY

@property (nonatomic, strong) NSMutableArray *minTrackBgColors;
@property (nonatomic, strong) NSMutableArray *maxTrackBgColors;

@end
