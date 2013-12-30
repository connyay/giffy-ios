//
//  MenuCell.m
//  Giffy
//
//  Created by Conn on 12/27/13.
//  Copyright (c) 2013 Conn. All rights reserved.
//

#import "AccountMenuCell.h"

@implementation AccountMenuCell

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self
		                                         selector:@selector(receiveNotification:)
		                                             name:@"LoggedIn"
		                                           object:nil];
        
		[[NSNotificationCenter defaultCenter] addObserver:self
		                                         selector:@selector(receiveNotification:)
		                                             name:@"LoggedOut"
		                                           object:nil];
	}
	return self;
}

- (void)awakeFromNib {
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	BOOL loggedIn = [standardUserDefaults boolForKey:@"loggedin"];
	[self updateLabel:loggedIn];
}

- (void)receiveNotification:(NSNotification *)notification {
	if ([[notification name] isEqualToString:@"LoggedIn"]) {
		NSLog(@"Successfully received the logged in notification!");
		[self updateLabel:YES];
	}
	else if ([[notification name] isEqualToString:@"LoggedOut"]) {
		NSLog(@"Successfully received the logged out notification!");
		[self updateLabel:NO];
	}
}

- (void)updateLabel:(BOOL)loggedIn {
	if (loggedIn) {
		NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
		[self.label setText:[NSString stringWithFormat:@"Hi, %@!", username]];
	}
	else {
		[self.label setText:@"Login"];
	}
}

@end
