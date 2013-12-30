//
//  MenuViewController.m
//  Giffy
//
//  Created by Conn on 12/25/13.
//  Copyright (c) 2013 Conn. All rights reserved.
//

#import "MenuViewController.h"
#import "GifsViewController.h"

@interface MenuViewController ()
@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation MenuViewController


- (id)initWithStyle:(UITableViewStyle)style {
	self = [super initWithStyle:style];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
	_menuItems = @[@"title", @"account", @"top99", @"all", @"mine"];
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

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	// This will create a "invisible" footer
	return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	// To "clear" the footer view
	return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://giffy.co"]];
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Set the title of navigation bar by using the menu items
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	UINavigationController *destViewController = (UINavigationController *)segue.destinationViewController;
	NSString *destKey = [_menuItems objectAtIndex:indexPath.row];
	destViewController.title = [[_menuItems objectAtIndex:indexPath.row] capitalizedString];
    
	if ([destKey isEqualToString:@"top99"]) {
		[(GifsViewController *)destViewController setContext : @"TOP"];
	}
	else if ([destKey isEqualToString:@"mine"]) {
		[(GifsViewController *)destViewController setContext : @"MINE"];
	}
	else if ([destKey isEqualToString:@"all"]) {
		[(GifsViewController *)destViewController setContext : @"ALL"];
	}
    
	if ([segue isKindOfClass:[SWRevealViewControllerSegue class]]) {
		SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue *)segue;
        
		swSegue.performBlock = ^(SWRevealViewControllerSegue *rvc_segue, UIViewController *svc, UIViewController *dvc) {
			UINavigationController *navController = (UINavigationController *)self.revealViewController.frontViewController;
			[navController setViewControllers:@[dvc] animated:NO];
			[self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
		};
	}
}

@end
