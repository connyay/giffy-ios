//
//  ViewMenuController.h
//  Giffy
//
//  Created by Conn on 12/28/13.
//  Copyright (c) 2013 Conn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gif.h"
#import "MBProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewMenuController : UITableViewController {
	Gif *gif;
}

- (Gif *)getGif;
- (void)setGif:(Gif *)value;

@end
