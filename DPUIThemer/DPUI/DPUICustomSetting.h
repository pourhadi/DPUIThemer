//
//  DPUICustomSetting.h
//  DPUIThemer
//
//  Created by Dan Pourhadi on 5/24/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kDYNCustomSettingTypeStyleKey = @"View Style";
static NSString * const kDYNCustomSettingTypeTextStyleKey = @"Text Style";
static NSString * const kDYNCustomSettingTypeSliderStyleKey = @"Slider Style";
static NSString * const kDYNCustomSettingTypeImageStyleKey = @"Image Style";
static NSString * const kDYNCustomSettingTypeColorKey = @"Color";

static NSString * const kDYNKeyPathTypeView = @"UIView";
static NSString * const kDYNKeyPathTypeLabel = @"UILabel";
static NSString * const kDYNKeyPathTypeFont = @"UIFont";
static NSString * const kDYNKeyPathTypeColor = @"UIColor";
static NSString * const kDYNKeyPathTypeImage = @"UIImage";



typedef NS_ENUM(NSUInteger, DYNCustomSettingType) {
	DYNCustomSettingTypeStyle,
	DYNCustomSettingTypeTextStyle,
	DYNCustomSettingTypeSliderStyle,
	DYNCustomSettingTypeImageStyle,
	DYNCustomSettingTypeColor,
};

@interface DPUICustomSetting : NSObject


- (id)initWithDictionary:(NSDictionary*)dictionary;
- (id)jsonValue;

+ (NSArray*)keyPathTypes;

@property (nonatomic, strong) NSString *keyPath;
@property (nonatomic, strong) NSString *keyPathType;
@property (nonatomic, strong) NSString *value;

@property (nonatomic, strong) NSArray *possibleValues;

@end
