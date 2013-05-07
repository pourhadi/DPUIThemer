//
//  DPUITextStyle.h
//  DPUIThemer
//
//  Created by Dan Pourhadi on 5/4/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPStyleBackground.h"

@interface TextStyleTransformer : NSValueTransformer

@end

@interface DPUITextStyle : NSObject


@property (nonatomic, strong) NSString *styleName;
@property (nonatomic, strong) DPStyleColor *textColor;
@property (nonatomic, strong) NSFont *font;
@property (nonatomic) CGSize shadowOffset;
@property (nonatomic, strong) DPStyleColor *shadowColor;
@property (nonatomic) NSTextAlignment alignment;




@property (nonatomic) CGFloat xShadowOffset;
@property (nonatomic) CGFloat yShadowOffset;

@property (nonatomic) NSInteger fontSize;

@property (nonatomic, strong) NSString *fontString;


- (id)jsonValue;
- (id)initWithDictionary:(NSDictionary*)dict;

@end
