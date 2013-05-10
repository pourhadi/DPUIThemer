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

@property (nonatomic, strong) NSString *normalTextStyle;

@property (nonatomic, strong) NSString *highlightedStyleName;
@property (nonatomic, strong) NSString *highlightedTextStyle;

@property (nonatomic, strong) NSString *selectedStyleName;
@property (nonatomic, strong) NSString *selectedTextStyle;

@property (nonatomic, strong) NSString *disabledStyleName;
@property (nonatomic, strong) NSString *disabledTextStyle;

@property (nonatomic, strong) NSString *superStyleName;

- (id)jsonValue;
- (id)initWithDictionary:(NSDictionary*)dictionary;
@end
