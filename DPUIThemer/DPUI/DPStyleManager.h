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
@class DPStyleObject;
@class DPUIStyle;
@class DPUITextStyle;
@interface DPStyleManager : NSObject

+ (DPStyleManager*)sharedInstance;

@property (nonatomic) BOOL viewsSwizzled;

@property (nonatomic, strong) NSMutableArray *styles;
@property (nonatomic, strong) NSArray *styleNames;
@property (nonatomic, strong) DPUIStyle *currentStyle;
@property (nonatomic, strong) NSArray *colorVariables;
@property (nonatomic, strong) NSArray *colorVariableNames;
@property (nonatomic, strong) NSArray *textStyles;
@property (nonatomic, strong) NSArray *textStyleNames;
- (void)styleApplied;

- (DPStyleObject*)styleForName:(NSString*)name;
- (DPUITextStyle*)textStyleForName:(NSString*)name;
@end
