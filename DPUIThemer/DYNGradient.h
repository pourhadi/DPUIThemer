//
//  DYNGradient.h
//  DPUIThemer
//
//  Created by Daniel Pourhadi on 6/7/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACTGradientEditor.h"
#import "GradientViewViewController.h"
@interface DYNGradient : NSObject <GradientViewControllerDelegate>

@property (nonatomic, strong) NSGradient *gradient;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *locations;
@property (nonatomic, strong) NSNumber *gradientAngle;

@property (nonatomic, strong) NSString *gradientVariableName;
@property (nonatomic, strong) NSString *gradientName;

@property (nonatomic, assign) DYNGradient *associatedGradient;

@property (nonatomic, strong) NSImage *gradientImage;

- (id)jsonValue;
- (id)initWithDictionary:(NSDictionary*)dictionary;

@end
