//
//  DYNFill.h
//  DPUIThemer
//
//  Created by Dan Pourhadi on 6/8/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DYNFillType) {
	DYNFillTypeColor,
	DYNFillTypeGradient,
	DYNFillTypeTitle,
};

@interface DYNFill : NSObject

@property (nonatomic, strong) id object;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *fillType;

@end
