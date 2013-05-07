//
//  DPStyleInnerBorder.h
//  TheQ
//
//  Created by Dan Pourhadi on 4/27/13.
//
//

#import <Foundation/Foundation.h>
#import "DPStyleBackground.h"
@interface DPStyleInnerBorder : NSObject <NSCopying>

@property (nonatomic, strong) DPStyleColor *color;
@property (nonatomic) CGBlendMode blendMode;
@property (nonatomic) CGFloat height;

- (id)jsonValue;

- (id)initWithDictionary:(NSDictionary*)dictionary;

@end
