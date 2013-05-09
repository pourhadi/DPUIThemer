//
//  DPStyleManager.m
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import "DPStyleManager.h"
#import "DPUIDocument.h"
@interface DPStyleManager ()
{
	NSMutableArray *_styles;
}
@end
@implementation DPStyleManager
@synthesize colorVariables=_colorVariables;
+ (DPStyleManager*)sharedInstance
{
    static dispatch_once_t onceQueue;
    static DPStyleManager *instance = nil;
	
    dispatch_once(&onceQueue, ^{ instance = [[self alloc] init]; });
    return instance;
}

- (NSMutableArray*)styles
{
	if (!_styles) {
		_styles = [NSMutableArray new];
	}
	
	return _styles;
}

- (void)styleApplied
{
	if (!self.viewsSwizzled) {
		self.viewsSwizzled = YES;
	}
}

- (DPUITextStyle*)textStyleForName:(NSString*)name
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"styleName == %@", name];
    NSArray *filtered = [self.textStyles filteredArrayUsingPredicate:pred];
    if (filtered) {
        if (filtered.count > 0) {
            return filtered[0];
        }
    }
    return nil;
}

- (DPStyleObject*)styleForName:(NSString*)name
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name == %@", name];
    NSArray *filtered = [self.styles filteredArrayUsingPredicate:pred];
    if (filtered) {
        if (filtered.count > 0) {
            return filtered[0];
        }
    }
    return nil;
}

- (NSArray*)colorVariables
{
   return [self.delegate colorVarArray];
}

- (void)setColorVariables:(NSArray *)colorVariables
{
	_colorVariables = colorVariables;
	
	self.colorVariableNames = [self.colorVariables valueForKeyPath:@"colorName"];
}

- (void)setStyles:(NSMutableArray *)styles
{
	_styles = styles;
	self.styleNames = [self.styles valueForKeyPath:@"styleName"];
}

- (void)setTextStyles:(NSArray*)textStyles{
	_textStyles = textStyles;
	self.textStyleNames = [self.textStyles valueForKeyPath:@"styleName"];
}


@end
