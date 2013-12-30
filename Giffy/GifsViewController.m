//
//  AllGifsViewController.m
//  Giffy
//
//  Created by Conn on 12/23/13.
//  Copyright (c) 2013 Conn. All rights reserved.
//

#import "GifsViewController.h"

@interface GifsViewController ()
@property (nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@property (nonatomic) IBOutlet UIBarButtonItem *refreshBtn;
@end

@implementation GifsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
	}
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidLoad {
	[self.revealButtonItem setTarget:self.revealViewController];
	[self.revealButtonItem setAction:@selector(revealToggle:)];
	[self.revealViewController panGestureRecognizer];
	[self.revealViewController tapGestureRecognizer];
    
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
	[self.collectionView setBackgroundColor:[UIColor clearColor]];
	[self.collectionView registerClass:[GiffyGifCell class]
	        forCellWithReuseIdentifier:@"GiffyCell"];
    
	giffyService = [[GiffyService alloc] init];
	giffyService.delegate = self;
    
	if (context == nil) {
		[self setContext:@"TOP"];
	}
	[giffyService setContext:context];
	[self setTitleFromContext];
	[self fetchGifs];
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
	[super viewDidLoad];
    
	if ([context isEqualToString:@"ALL"]) {
		[self.collectionView addInfiniteScrollingWithActionHandler: ^{
		    [giffyService getNext];
		    NSLog(@"infinite - load next page");
		}];
	}
}

- (void)setTitleFromContext {
	if ([context isEqualToString:@"TOP"]) {
		self.title = @"Top 99 Gifs";
	}
	else if ([context isEqualToString:@"MINE"]) {
		self.title = @"My Gifs";
	}
	else if ([context isEqualToString:@"ALL"]) {
		self.title = @"All Gifs";
	}
}

- (void)fetchGifs {
	NSLog(@"Fetching");
	[self showProgress];
	[giffyService getGifs];
}

- (void)clearGifs {
	gifArray = [[NSArray alloc] init];
	for (id object in gifArray) {
		[loadedImages addObject:[NSNull null]];
	}
	[self.collectionView reloadData];
	[self clearGifs];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)setContext:(NSString *)value {
	context = value;
}

- (IBAction)refresh:(id)sender {
	NSLog(@"Clicked refresh");
	if (gifArray.count > 0) {
		[self.collectionView
		 scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
         atScrollPosition:UICollectionViewScrollPositionTop
         animated:YES];
	}
	[self.refreshBtn setEnabled:NO];
	[self showProgress];
	[LVDebounce fireAfter:.25 target:self selector:@selector(fetchGifs) userInfo:nil];
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
	return [gifArray count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (GiffyGifCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"GiffyCell";
	GiffyGifCell *cell = (GiffyGifCell *)[cv dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
	if (cell == nil) {
		CGRect rect = CGRectMake(0.0, 0.0, 93, 93);
		cell = [[GiffyGifCell alloc] initWithFrame:rect];
	}
	Gif *vo = [gifArray objectAtIndex:indexPath.row];
	cell.index = indexPath.row;
	cell.gif = vo;
	cell.contentMode = UIViewContentModeScaleAspectFill;
    
	[cell.imageView setImageWithURL:[NSURL URLWithString:vo.thumb]
	               placeholderImage:[UIImage imageNamed:@"placeholder"]];
	[cell setUserInteractionEnabled:YES];
    
    
	return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	GiffyGifCell *cell = (GiffyGifCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
	[self performSegueWithIdentifier:@"ViewGif" sender:cell];
}

- (CGSize)  collectionView:(UICollectionView *)cv
                    layout:(UICollectionViewLayout *)cvLayout
    sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	if ([gifArray count] && indexPath.row == [gifArray count]) {
		return CGSizeMake(300.0, 40.0);
	}
	return CGSizeMake(102.5, 102.5);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"ViewGif"]) {
		GiffyGifCell *cell = (GiffyGifCell *)sender;
		Gif *gif = (Gif *)cell.gif;
		SWRevealViewController *rcv = segue.destinationViewController;
		[rcv loadView];
		UINavigationController *viewController = (UINavigationController *)rcv.frontViewController;
        
		GifViewController *gifViewController = (GifViewController *)[[viewController viewControllers] firstObject];
        
		gifViewController.gif = gif;
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		[self.refreshBtn setEnabled:YES];
	}
	if (buttonIndex == 1) {
		NSString *username = [alertView textFieldAtIndex:0].text;
		NSString *password = [alertView textFieldAtIndex:1].text;
		[self showProgress];
		[giffyService login:username password:password];
	}
}

- (void)showProgress {
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)clearProgress {
	[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

#pragma mark -
#pragma mark Giffy service delegate
- (void)requestCompletedWithData:(NSArray *)data {
	if (data.count == 0 && [context isEqualToString:@"MINE"]) {
		[giffyService setContext:@"MINE"];
		[self fetchGifs];
	}
}

- (void)requestCompletedWithData:(NSArray *)data
                         isPaged:(BOOL)paged {
	if (paged) {
		newGifArray = [[NSArray alloc] initWithArray:data];
		[self.collectionView performBatchUpdates: ^{
		    int startIndex = gifArray.count;
            
		    [self updateGifs];
		    [self updateNewGifs];
            
		    NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
		    for (int i = startIndex; i < gifArray.count; i++)
				[arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
		    [self.collectionView insertItemsAtIndexPaths:arrayWithIndexPaths];
		} completion: ^(BOOL finished) {}];
	}
	else {
		gifArray = [[NSArray alloc] initWithArray:data];
		for (id object in gifArray) {
			[loadedImages addObject:[NSNull null]];
		}
	}
	[self.refreshBtn setEnabled:YES];
	[self.collectionView reloadData];
	[self clearProgress];
	[self.collectionView.infiniteScrollingView stopAnimating];
}

- (void)requestFailedWithError:(NSError *)error {
	[self clearProgress];
	NSInteger code = [error code];
	if (code == -1011) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Giffy Login" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
        
		alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        
		[alertView show];
	}
}

- (void)updateGifs {
	NSMutableArray *data = [gifArray mutableCopy];
    
	for (int i = 0; i < newGifArray.count; i++) {
		[data addObject:[newGifArray objectAtIndex:i]];
	}
	gifArray = [NSArray arrayWithArray:data];
}

- (void)updateNewGifs {
	NSMutableArray *data = [newGifArray mutableCopy];
	for (int i = 0; i < newGifArray.count; i++) {
		[data removeObjectAtIndex:0];
	}
    
	newGifArray = [NSArray arrayWithArray:data];
}

@end
