//
//  LoginViewController.m
//  Giffy
//
//  Created by Conn on 12/25/13.
//  Copyright (c) 2013 Conn. All rights reserved.
//

#import "AccountViewController.h"

@interface AccountViewController ()
@property (nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@property (nonatomic) IBOutlet UILabel *account;
@property (nonatomic) IBOutlet UIView *loggedin;
@property (nonatomic) IBOutlet UIView *login;

@property (nonatomic) IBOutlet UIButton *loginBtn;
@property (nonatomic) IBOutlet UIButton *logoutBtn;
@property (nonatomic) IBOutlet UITextField *username;
@property (nonatomic) IBOutlet UITextField *password;
@end


@implementation AccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad {
	[self.revealButtonItem setTarget:self.revealViewController];
	[self.revealButtonItem setAction:@selector(revealToggle:)];
	[self.revealViewController panGestureRecognizer];
	[self.revealViewController tapGestureRecognizer];
    
	giffyService = [[GiffyService alloc] init];
	giffyService.delegate = self;
    
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	BOOL loggedIn = [standardUserDefaults boolForKey:@"loggedin"];
	if (loggedIn) {
		[self setTitle:@"Account"];
		NSString *username = [standardUserDefaults stringForKey:@"username"];
		[self.account setText:[NSString stringWithFormat:@"Logged in as: %@", username]];
		[self.login setHidden:YES];
		[self.loggedin setHidden:NO];
		[self.loggedin.layer setCornerRadius:5];
	}
	else {
		[self setTitle:@"Login"];
		[self.loggedin setHidden:YES];
		[self.login setHidden:NO];
		[self.login.layer setCornerRadius:5];
        
        
		[self.password setReturnKeyType:UIReturnKeyDone];
		[self.password addTarget:self
		                  action:@selector(doLogin)
		        forControlEvents:UIControlEventEditingDidEndOnExit];
	}
    
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
	[self.logoutBtn addTarget:self action:@selector(doLogout) forControlEvents:UIControlEventTouchUpInside];
	[self.loginBtn addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
    
    
	[super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)doLogout {
	[giffyService logout];
}

- (void)doLogin {
	NSString *un = self.username.text;
	NSString *pw = self.password.text;
    
	if (un.length == 0 || pw.length == 0) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Please fill in username and password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
	}
	else {
		[giffyService login:un password:pw];
		[self.password setText:@""];
		[self.password resignFirstResponder];
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)requestCompletedWithData:(NSArray *)data {
	[self clearProgress];
	[self.username setText:@""];
	[self viewDidLoad];
}

- (void)requestFailedWithError:(NSError *)error {
	[self clearProgress];
	NSLog(@"request failed with error: %@", [error description]);
}

- (void)showProgress {
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)clearProgress {
	[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

@end
