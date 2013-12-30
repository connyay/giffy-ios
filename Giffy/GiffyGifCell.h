//
//  GiffyCell.h
//  Giffy
//
//  Created by Conn on 12/23/13.
//  Copyright (c) 2013 Conn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gif.h"

@interface GiffyGifCell : UICollectionViewCell {
	UIImageView *imageView;
	Gif *gif;
	NSUInteger index;
}

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) Gif *gif;
@property (assign) NSUInteger index;

@end
