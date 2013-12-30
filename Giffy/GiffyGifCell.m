//
//  GiffyCell.m
//  Giffy
//
//  Created by Conn on 12/23/13.
//  Copyright (c) 2013 Conn. All rights reserved.
//

#import "GiffyGifCell.h"

@implementation GiffyGifCell

@synthesize imageView;
@synthesize gif;
@synthesize index;

#define kBorderWidth 3

- (id)initWithFrame:(CGRect)rect {
	if ((self = [super initWithFrame:rect])) {
		UIView *frame = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 93, 93)];
		frame.backgroundColor = [UIColor colorWithRed:0.925 green:0.941 blue:0.945 alpha:1.0];
		[frame.layer setCornerRadius:kBorderWidth];
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kBorderWidth,
		                                                          kBorderWidth,
		                                                          frame.frame.size.width - kBorderWidth * 2,
		                                                          frame.frame.size.height - kBorderWidth * 2)];
		imageView.contentMode = UIViewContentModeScaleAspectFill;
		imageView.clipsToBounds = YES;
		[frame addSubview:imageView];
        
        
		[self.contentView addSubview:frame];
	}
	return self;
}

@end
