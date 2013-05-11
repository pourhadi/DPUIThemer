//
//  DPStyleBackground.m
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import "DPStyleBackground.h"
#import "ColorTransformer.h"
#import "DPStyleManager.h"
#import "DPUIDocument.h"

@interface DPStyleColor ()
{
    NSString *_colorName;
}
@property (nonatomic, strong) NSMutableArray *observing;

@end

@implementation DPStyleColor

- (NSMutableArray*)observing
{
    if (!_observing) {
        _observing = [NSMutableArray arrayWithCapacity:1];
    }
    return _observing;
}

- (id)copyWithZone:(NSZone *)zone
{
	id copy = [[[self class] alloc] init];
	if (copy){
        if (_colorName)
            [copy setColorName:[self.colorName copyWithZone:zone]];
        [copy setColor:[self.color copyWithZone:zone]];
	}
	return copy;
}

- (NSString*)colorName
{
    if (!_colorName) {
        if (self.colorVar) {
            return self.colorVar;
        } else {
            return self.colorDisplayString;
        }
    }
    
    return _colorName;
}

- (id)init
{
	self = [super init];
	if (self) {
		self.color = [NSColor colorWithSRGBRed:0 green:0 blue:0 alpha:1];
	}
	return self;
}

//- (NSString*)colorName
//{
//    if (!_colorName) {
//        return self.colorString;
//    }
//    
//    return _colorName;
//}

- (void)unobserve
{
    for (DPStyleColor *color in self.observing) {
        [color removeObserver:self forKeyPath:@"color"];
        [color removeObserver:self forKeyPath:@"parameter"];
        [color removeObserver:self forKeyPath:@"colorName"];
    }

        [self.observing removeAllObjects];

}

- (void)dealloc
{
	[self unobserve];
}

- (void)setColorVar:(NSString *)colorVar
{
    [self unobserve];
    
    self.parameterName = nil;
    if (colorVar && ![colorVar hasPrefix:@"#"]) {
        NSArray *colors = [[DPStyleManager sharedInstance] colorVariables];
        NSPredicate *pred= [NSPredicate predicateWithFormat:@"colorName == %@", colorVar];
        NSArray *filters = [colors filteredArrayUsingPredicate:pred];
        if (filters && filters.count > 0) {
            DPStyleColor *styleColor = filters[0];
            self.color = [styleColor color];
            [styleColor addObserver:self forKeyPath:@"color" options:0 context:nil];
            [styleColor addObserver:self forKeyPath:@"parameter" options:0 context:nil];
            [styleColor addObserver:self forKeyPath:@"colorName" options:0 context:nil];
            [self.observing addObject:styleColor];
			
			self.parameter = styleColor.parameter;
        }
    }
    
    [self willChangeValueForKey:@"colorVar"];
    _colorVar = colorVar;
    [self didChangeValueForKey:@"colorVar"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"color"]) {
        self.color = [object color];
    } else if ([keyPath isEqualToString:@"colorName"]) {
        self.colorVar = [object colorName];
    } else {
        self.parameter = [object parameter];
    }
}

- (NSString*)colorVariableName
{
	if (!_colorName) {
		self.colorName = [DPStyleColor newColorVariableName];
	}
	return _colorName;
}

- (void)setColorVariableName:(NSString *)colorVariableName
{
	self.colorName = colorVariableName;
}

+ (NSString*)newColorVariableName
{
	NSInteger x = 1;
	BOOL found = NO;
	NSString *name;
	
	while (!found) {
		
		name = [NSString stringWithFormat:@"Color%ld", (long)x];
		if (![[[DPStyleManager sharedInstance] colorVariableNames] containsObject:name]) {
			found = YES;
		} else {
			x += 1;
		}
		
	}
	
	return name;
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key NS_AVAILABLE(10_5, 2_0)
{
	NSSet *paths = [super keyPathsForValuesAffectingValueForKey:key];
	if ([key isEqualToString:@"colorName"] || [key isEqualToString:@"colorString"] || [key isEqualToString:@"colorVariableName"] || [key isEqualToString:@"colorDisplayString"]) {
		
		NSMutableSet *mpaths = [paths mutableCopy];
		if (![mpaths containsObject:@"color"]) {
			[mpaths addObject:@"color"];
		}
        
        if (![mpaths containsObject:@"colorVar"]) {
            [mpaths addObject:@"colorVar"];
        }
	paths = mpaths;
	}

	return paths;
}

- (void)setColor:(NSColor *)color
{
    self.colorVar = nil;
    
	[self willChangeValueForKey:@"color"];
	_color = color;
	[self didChangeValueForKey:@"color"];
	_colorString = [ColorTransformer stringFromColor:color];
    
}

- (void)setColorString:(NSString *)colorString
{
    _colorString = colorString;
    
    self.color = [ColorTransformer colorFromString:colorString];
}

- (NSString*)colorDisplayString
{
	CGFloat r,g,b,a;
	[self.color getRed:&r green:&g blue:&b alpha:&a];
	r *= 255;
	g *= 255;
	b *= 255;
	
	return [NSString stringWithFormat:@"%d,%d,%d,%0.1f", (int)r, (int)g, (int)b, a];
}

- (id)jsonValue
{
	NSDictionary *dict = @{@"colorString":self.colorString, @"colorVar":(self.colorVar ? self.colorVar : @""), @"colorName":(_colorName ? _colorName :@""), @"definedAtRuntime":@(self.parameter)};
    return dict;
}

- (id)initWithColorString:(NSString *)color
{
	self = [super init];
	if (self) {
		self.color = [ColorTransformer colorFromString:color];
	}
	return self;
}

- (id)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        
        NSString *colorVar = [dict objectForKey:@"colorVar"];
        if (![colorVar isEqualToString:@""]) {
            self.colorVar = colorVar;
        } else {
            self.colorString = [dict objectForKey:@"colorString"];
            NSString *colorName = [dict objectForKey:@"colorName"];
            if (![colorName isEqualToString:@""])
            {
                self.colorName = colorName;
            }
        }
        
        self.parameter = [[dict objectForKey:@"definedAtRuntime"] boolValue];
    }
    
    return self;
}

@end
@implementation DPStyleBackground

- (id)init
{
    self = [super init];
    if (self) {
        self.startPoint = CGPointMake(0.5, 0);
        self.endPoint = CGPointMake(0.5, 1);
        self.locations = nil;
		self.colors = @[[NSColor blackColor]];
    }
    return self;
}

@end
