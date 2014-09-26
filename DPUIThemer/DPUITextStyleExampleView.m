//
//  DPUITextStyleExampleView.m
//  DPUIThemer
//
//  Created by Dan Pourhadi on 5/4/13.
//  Copyright (c) 2013 Daniel Pourhadi. All rights reserved.
//

#import "DPUITextStyleExampleView.h"

static NSString *kExampleText = @"Aa Bb Cc Dd Ee Ff";

@implementation DPUITextStyleExampleView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)setStyle:(DPUITextStyle *)style
{
	_style = style;
	[self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
	if (self.style) {
		
		//[self.bgColor setFill];
		//NSRectFill(dirtyRect);
		
		[self.style.textColor.color setFill];
		
		CGSize size = [kExampleText sizeWithAttributes:@{NSFontAttributeName:self.style.font}];
		
		CGFloat y = (dirtyRect.size.height - size.height)/2;
		CGFloat x = (dirtyRect.size.width - size.width)/2;
		
		NSShadow *shadow = [[NSShadow alloc] init];
		shadow.shadowColor = self.style.shadowColor.color;
		shadow.shadowOffset = NSSizeFromCGSize(self.style.shadowOffset);
		shadow.shadowBlurRadius = 0;
		
		if (self.style && self.style.textColor.color && self.style.font)
			[kExampleText drawAtPoint:NSMakePoint(x, y) withAttributes:@{NSFontAttributeName:self.style.font, NSForegroundColorAttributeName:self.style.textColor.color, NSShadowAttributeName:shadow}];
		
	}
	
	
}

@end
