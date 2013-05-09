//
//  DPUIControlStyle.h
//  DPUIThemer
//
//  Created by Daniel Pourhadi on 5/9/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPUITextStyle.h"
@interface DPUIControlStyle : NSObject

@property (nonatomic, strong) DPUITextStyle *normalTextStyle;

@property (nonatomic, strong) NSString *highlightedStyleName;
@property (nonatomic, strong) DPUITextStyle *highlightedTextStyle;

@property (nonatomic, strong) NSString *selectedStyleName;
@property (nonatomic, strong) DPUITextStyle *selectedTextStyle;

@property (nonatomic, strong) NSString *disabledStyleName;
@property (nonatomic, strong) DPUITextStyle *disabledTextStyle;

@property (nonatomic, strong) NSString *superStyleName;

- (id)jsonValue;
- (id)initWithDictionary:(NSDictionary*)dictionary;
@end
