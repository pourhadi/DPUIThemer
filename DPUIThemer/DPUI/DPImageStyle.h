//
//  DPImageStyle.h
//  TheQ
//
//  Created by Daniel Pourhadi on 4/29/13.
//
//

#import <Foundation/Foundation.h>
#import "DPStyleObject.h"
#import "DPStyleBackground.h"
#import "DPStyleShadow.h"
@interface DPImageStyle : DPStyleObject

@property (nonatomic, strong) DPStyleBackground *overlay;

@property (nonatomic, strong) DPStyleShadow *innerShadow;
@property (nonatomic, strong) DPStyleShadow *outerShadow; // equal padding on all four sides of the image will be added to accomodate the shadow while keeping the image centered in the frame


@end
