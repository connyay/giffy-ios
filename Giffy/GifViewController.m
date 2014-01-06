//
//  ViewGifController.m
//  Giffy
//
//  Created by Conn on 12/23/13.
//  Copyright (c) 2013 Conn. All rights reserved.
//

#import "GifViewController.h"
#import "MenuViewController.h"

@interface GifViewController ()
@property (nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@property (strong, nonatomic) UIViewController *rightViewController;
- (IBAction)longPressDetected:(UILongPressGestureRecognizer *)sender;
@end

@implementation GifViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
	[indicator startAnimating];
    
	indicator.center = CGPointMake(CGRectGetMidX(self.iv.bounds), CGRectGetMidY(self.iv.bounds));
	[self.iv addSubview:indicator];
    
	[self.iv setImageWithURL:[NSURL URLWithString:gif.url]
	        placeholderImage:[UIImage imageNamed:@"black-placeholder"]
	                 options:0
	               completed: ^(UIImage *image, NSError *error, SDImageCacheType cacheType)
     {
         [indicator removeFromSuperview];
     }];
    
    
	[super viewWillAppear:animated];
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
	SWRevealViewController *revealController = [self revealViewController];
	UIBarButtonItem *rightRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
	                                                                          style:UIBarButtonItemStyleBordered target:revealController action:@selector(rightRevealToggle:)];
    
	revealController.navigationItem.rightBarButtonItem = rightRevealButtonItem;
    
	[self.revealButtonItem setTarget:self.revealViewController];
	[self.revealButtonItem setAction:@selector(revealToggle:)];
    
	ViewMenuController *menu = (ViewMenuController *)[[(UINavigationController *)[self.revealViewController rightViewController] viewControllers] firstObject];
	menu.gif = gif;
	[revealController panGestureRecognizer];
	[revealController tapGestureRecognizer];
    
	self.view.tintColor = [UIColor whiteColor];
	revealController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	SDImageCache *imageCache = [SDImageCache sharedImageCache];
	[imageCache clearMemory];
}

- (IBAction)longPressDetected:(UIGestureRecognizer *)sender {
	if (sender.state == UIGestureRecognizerStateBegan) {
		[self.revealViewController rightRevealToggleAnimated:YES];
	}
}

- (Gif *)getGif {
	return gif;
}

- (void)setGif:(id)value {
	gif = value;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
