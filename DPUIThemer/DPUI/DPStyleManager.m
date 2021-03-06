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
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"styleName == %@", name];
    NSArray *filtered = [self.styles filteredArrayUsingPredicate:pred];
    if (filtered) {
        if (filtered.count > 0) {
            return filtered[0];
        }
    }
    return nil;
}

- (void)setGradients:(NSArray *)gradients
{
    [self willChangeValueForKey:@"gradients"];
    _gradients = gradients;
    [self didChangeValueForKey:@"gradients"];
    
    self.gradientNames = [gradients valueForKeyPath:@"gradientName"];
}

- (void)setSliderStyles:(NSMutableArray *)sliderStyles
{
	_sliderStyles = sliderStyles;
	
	self.sliderStyleNames = [sliderStyles valueForKeyPath:@"name"];
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

- (void)setImageStyles:(NSArray *)imageStyles
{
	_imageStyles = imageStyles;
	
	self.imageStyleNames = [self.imageStyles valueForKeyPath:@"styleName"];
}

- (NSArray*)parameters
{
    return [self.delegate parameters];
}

- (id)valueForStyleParameter:(NSString *)parameter
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name == %@", parameter];
    NSArray *filtered = [self.parameters filteredArrayUsingPredicate:pred];
    if (filtered) {
        if (filtered.count > 0) {
            return [(DPUIParameter*)filtered[0] value];
        }
    }
    return nil;
}
@end
