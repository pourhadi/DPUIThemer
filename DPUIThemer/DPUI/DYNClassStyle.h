//
//  DYNClassStyle.h
//  DPUIThemer
//
//  Created by Dan Pourhadi on 6/2/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYNClassStyle : NSObject <NSCopying>

@property (nonatomic, strong) NSString *className;

@property (nonatomic, strong) NSArray *attributes;

@property (nonatomic, strong) NSNumber *autoApply;

- (id)initWithDictionary:(NSDictionary*)dictionary;
- (id)jsonValue;

@end
