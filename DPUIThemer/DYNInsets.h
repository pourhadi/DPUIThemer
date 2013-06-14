//
//  DYNInsets.h
//  DPUIThemer
//
//  Created by Dan Pourhadi on 6/13/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYNInsets : NSObject

@property (nonatomic, strong) NSNumber *top;
@property (nonatomic, strong) NSNumber *bottom;
@property (nonatomic, strong) NSNumber *left;
@property (nonatomic, strong) NSNumber *right;
- (id)jsonValue;
- (id)initWithDictionary:(NSDictionary*)dictionary;
@end
