//
//  DPStyleBackground.h
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import <Foundation/Foundation.h>

@interface DPStyleColor : NSObject <NSCopying>
@property (nonatomic, strong) NSString *colorName;
@property (nonatomic, strong) NSColor *color;
@property (nonatomic, strong) NSString *colorString;
@property (nonatomic, strong) NSString *colorVar;

@property (nonatomic, strong) NSString *colorDisplayString;
@property (nonatomic, strong) NSString *colorVariableName;
- (id)jsonValue;
- (id)initWithColorString:(NSString *)color;
- (id)initWithDictionary:(NSDictionary*)dict;
@end
@interface DPStyleBackground : NSObject

@property (nonatomic, strong) NSArray *colors; // multiple colors for gradient; single for solid color

// if colors.count > 1, the properties below are used
@property (nonatomic, strong) NSArray *locations;
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;

@end
