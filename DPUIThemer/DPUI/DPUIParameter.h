//
//  DPUIParameter.h
//  DPUIThemer
//
//  Created by Daniel Pourhadi on 5/10/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DPUIParameterType) {
  
    DPUIParameterTypeColor,
    
};

@interface DPUIParameter : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) id value;

@property (nonatomic) DPUIParameterType parameterType;


@property (nonatomic, strong, readonly) NSColor *color;

@end
