//
//  DPStyleManager.h
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import <Foundation/Foundation.h>
#import "DPImageStyle.h"
#import "DPViewStyle.h"
#import "DPStyleBackground.h"
#import "DPStyleShadow.h"
#import "DYNGradient.h"
@class DPStyleObject;
@class DPUIStyle;
@class DPUITextStyle;

@protocol ManagerDelegate <NSObject>

- (NSArray*)colorVarArray;
- (NSArray*)parameters;

@end

@interface DPStyleManager : NSObject

+ (DPStyleManager*)sharedInstance;

@property (nonatomic) BOOL viewsSwizzled;
@property (nonatomic, weak) id<ManagerDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *styles;
@property (nonatomic, strong) DPUIStyle *currentStyle;
@property (nonatomic, strong) NSArray *colorVariables;

@property (nonatomic, strong) NSArray *styleNames;
@property (nonatomic, strong) NSArray *colorVariableNames;
@property (nonatomic, strong) NSArray *textStyleNames;
@property (nonatomic, strong) NSArray *sliderStyleNames;
@property (nonatomic, strong) NSArray *imageStyleNames;
@property (nonatomic, strong) NSArray *gradientNames;

@property (nonatomic, strong) NSArray *imageStyles;
@property (nonatomic, strong) NSArray *textStyles;
@property (nonatomic, strong) NSArray *parameters;
@property (nonatomic, strong) NSArray *gradients;

@property (nonatomic, strong) NSMutableArray *sliderStyles;

@property (nonatomic, strong) id globalDraggedItem;
- (id)valueForStyleParameter:(NSString*)parameter;
- (void)styleApplied;

- (DPStyleObject*)styleForName:(NSString*)name;
- (DPUITextStyle*)textStyleForName:(NSString*)name;
@end
