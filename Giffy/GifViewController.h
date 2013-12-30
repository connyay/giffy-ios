//
//  ViewGifController.h
//  Giffy
//
//  Created by Conn on 12/23/13.
//  Copyright (c) 2013 Conn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "SWRevealViewController.h"
#import "Gif.h"
#import "ViewMenuController.h"

@interface GifViewController : UIViewController {
	Gif *gif;
}

- (Gif *)getGif;
- (void)setGif:(Gif *)value;

@property (nonatomic, weak) IBOutlet UIImageView *iv;


@end
