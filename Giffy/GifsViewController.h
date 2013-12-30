//
//  AllGIfsViewController.h
//  Giffy
//
//  Created by Conn on 12/23/13.
//  Copyright (c) 2013 Conn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiffyService.h"
#import "GiffyGifCell.h"
#import "GifViewController.h"
#import "ViewMenuController.h"
#import "MBProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFNetworking.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "SWRevealViewController.h"
#import "LVDebounce.h"

@interface GifsViewController : UIViewController <GiffyServiceDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
UICollectionViewDelegate> {
	GiffyService *giffyService;
	NSArray *gifArray;
	NSArray *newGifArray;
	NSMutableArray *loadedImages;
	NSString *context;
}

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

- (IBAction)refresh:(id)sender;

- (void)setContext:(NSString *)value;
- (void)fetchGifs;
- (void)showProgress;
- (void)clearProgress;
@end
