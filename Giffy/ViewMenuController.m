//
//  ViewMenuController.m
//  Giffy
//
//  Created by Conn on 12/28/13.
//  Copyright (c) 2013 Conn. All rights reserved.
//

#import "ViewMenuController.h"

@interface ViewMenuController ()
@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation ViewMenuController

- (id)initWithStyle:(UITableViewStyle)style {
	self = [super initWithStyle:style];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
	_menuItems = @[@"copyimage", @"copyurl", @"save"];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Return the number of sections.
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Return the number of rows in the section.
	return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *cellIdentifier = [self.menuItems objectAtIndex:indexPath.row];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
	return cell;
}

- (void)tableView:(UITableViewCell *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UIPasteboard *pb = [UIPasteboard generalPasteboard];
	if (indexPath.row == 1 || indexPath.row == 3) {
		MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
		hud.xOffset = 30.f;
	}
	if (indexPath.row == 0) {
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:gif.url]];
		[NSURLConnection sendAsynchronousRequest:request
		                                   queue:[NSOperationQueue mainQueue]
		                       completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error) {
                                   [pb setData:data forPasteboardType:@"com.compuserve.gif"];
                                   [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                                   [self showMessage:@"Image copied to clipboard!"];
                               }];
	}
	if (indexPath.row == 1) {
		[pb setString:gif.url];
		[self showMessage:@"URL copied to clipboard!"];
	}
    
	if (indexPath.row == 2) {
		[[[UIImageView alloc] init] setImageWithURL:[NSURL URLWithString:gif.url]
		                           placeholderImage:[UIImage imageNamed:@"black-placeholder"]
		                                    options:0
		                                  completed: ^(UIImage *image, NSError *error, SDImageCacheType cacheType)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
             UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
             [self showMessage:@"Image saved!"];
         }];
	}
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	// This will create a "invisible" footer
	return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	// To "clear" the footer view
	return [[UIView alloc] init];
}

- (Gif *)getGif {
	return gif;
}

- (void)setGif:(id)value {
	gif = value;
}

- (void)showMessage:(NSString *)message {
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.mode = MBProgressHUDModeText;
	hud.labelText = message;
	hud.margin = 10.f;
	hud.yOffset = 150.f;
	hud.xOffset = 30.f;
	hud.removeFromSuperViewOnHide = YES;
    
	[hud hide:YES afterDelay:2];
}

@end
