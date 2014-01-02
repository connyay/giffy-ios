//
//  GiffyService.m
//  Giffy
//
//  Created by Conn on 12/23/13.
//  Copyright (c) 2013 Conn. All rights reserved.
//

#import "GiffyService.h"

@implementation GiffyService

@synthesize delegate;

#define kGiffyEndPoint      @"http://api.giffy.co/"
//#define kGiffyEndPoint      @"http://api.giffy.dev/"
#define kTopMethodName      @"gifs/99"
#define kAllMethodName      @"gifs/all"
#define kMineMethodName     @"gifs/mine"
#define kLoginMethodName    @"login"
#define kLogoutMethodName   @"logout"
#define kGifLimit           99

- (void)getGifs {
	if ([context isEqualToString:@"TOP"]) {
		[self getTopGifs];
	}
	else if ([context isEqualToString:@"MINE"]) {
		[self getMyGifs];
	}
	else if ([context isEqualToString:@"ALL"]) {
		[self getAllGifs];
	}
	else {
		[self setContext:@"TOP"];
		[self getTopGifs];
	}
}

- (void)getNext {
	if ([context isEqualToString:@"MINE"]) {
		[self getMyGifs:YES];
	}
	else if ([context isEqualToString:@"ALL"]) {
		[self getAllGifs:YES];
	}
	else {
		[self setContext:@"ALL"];
		[self getAllGifs];
	}
}

- (void)getTopGifs {
	NSString *url = [NSString stringWithFormat:@"%@%@",
	                 kGiffyEndPoint, kTopMethodName];
    
	[self _doGet:url isPaged:NO params:nil];
}

- (void)getAllGifs {
	[self getAllGifs:NO];
}

- (void)getAllGifs:(BOOL)paged {
	NSString *url = [NSString stringWithFormat:@"%@%@",
	                 kGiffyEndPoint, kAllMethodName];
	if (paged && ![next_page isEqualToString:@""]) {
		url = next_page;
	}
	else if (paged && [next_page isEqualToString:@""]) {
		[delegate requestCompletedWithData:@[]];
		return;
	}
	[self _doGet:url isPaged:paged params:nil];
}

- (void)getMyGifs {
	[self getMyGifs:NO];
}

- (void)getMyGifs:(BOOL)paged {
	NSString *url = [NSString stringWithFormat:@"%@%@",
	                 kGiffyEndPoint, kMineMethodName];
	[self _doGet:url isPaged:paged params:nil];
}

- (void)login:(NSString *)username
     password:(NSString *)password {
	[self setContext:@"LOGIN"];
	NSString *url = [NSString stringWithFormat:@"%@%@",
	                 kGiffyEndPoint, kLoginMethodName];
    
	NSDictionary *params = @{ @"username": username,
		                      @"password": password,
		                      @"remember": @true };
    
	[self _doPost:url isPaged:NO params:params];
}

- (void)logout {
	[self setContext:@"LOGOUT"];
	NSString *url = [NSString stringWithFormat:@"%@%@",
	                 kGiffyEndPoint, kLogoutMethodName];
	[self _doGet:url isPaged:NO params:nil];
}

- (void)_doGet:(NSString *)url isPaged:(BOOL)paged params:(NSDictionary *)params {
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	[manager GET:url parameters:nil success: ^(AFHTTPRequestOperation *operation, id responseObject) {
	    NSLog(@"JSON: %@", responseObject);
	    [self requestFinished:responseObject isPaged:paged];
	} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
	    NSLog(@"Error: %@", error);
	    [self requestFailed:error];
	}];
}

- (void)_doPost:(NSString *)url isPaged:(BOOL)paged params:(NSDictionary *)params {
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	[manager POST:url parameters:params success: ^(AFHTTPRequestOperation *operation, id responseObject) {
	    NSLog(@"JSON: %@", responseObject);
	    [self requestFinished:responseObject isPaged:paged];
	} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
	    NSLog(@"Error: %@", error);
	    [self requestFailed:error];
	}];
}

- (void)requestFinished:(NSDictionary *)responseObject
                isPaged:(BOOL)paged {
	if ([context isEqualToString:@"TOP"]) {
		[self parseTopGifs:responseObject];
	}
	else if ([context isEqualToString:@"MINE"]) {
		[self parseMyGifs:responseObject isPaged:paged];
	}
	else if ([context isEqualToString:@"ALL"]) {
		[self parseAllGifs:responseObject isPaged:paged];
	}
	else if ([context isEqualToString:@"LOGIN"]) {
		[self parseLogin:responseObject];
	}
	else if ([context isEqualToString:@"LOGOUT"]) {
		NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
		[standardUserDefaults setBool:NO forKey:@"loggedin"];
		[standardUserDefaults setObject:nil forKey:@"username"];
		[standardUserDefaults synchronize];
		[[NSNotificationCenter defaultCenter]
		 postNotificationName:@"LoggedOut"
         object:self];
        
		[delegate requestCompletedWithData:@[]];
	}
}

- (void)parseTopGifs:(NSDictionary *)responseObject {
	NSDictionary *gifs = [responseObject objectForKey:@"gifs"];
	NSMutableArray *gifsArray = [[NSMutableArray alloc] initWithCapacity:kGifLimit];
    
	for (NSDictionary *gif in gifs) {
		Gif *vo = [[Gif alloc] init];
		vo.ID = [[gif valueForKey:@"id"] intValue];
		vo.url = [gif valueForKey:@"url"];
		vo.thumb = [gif valueForKey:@"thumb"];
        
		[gifsArray addObject:vo];
	}
    
	[delegate requestCompletedWithData:gifsArray
	                           isPaged:NO];
}

- (void)parseAllGifs:(NSDictionary *)responseObject isPaged:(BOOL)paged {
	NSDictionary *gifs = [responseObject objectForKey:@"gifs"];
	next_page = [responseObject objectForKey:@"next_page"];
	NSMutableArray *gifsArray = [[NSMutableArray alloc] initWithCapacity:kGifLimit];
    
	for (NSDictionary *gif in gifs) {
		Gif *vo = [[Gif alloc] init];
		vo.ID = [[gif valueForKey:@"id"] intValue];
		vo.url = [gif valueForKey:@"url"];
		vo.thumb = [gif valueForKey:@"thumb"];
        
		[gifsArray addObject:vo];
	}
    
	[delegate requestCompletedWithData:gifsArray
	                           isPaged:paged];
}

- (void)parseMyGifs:(NSDictionary *)responseObject isPaged:(BOOL)paged {
	NSDictionary *gifs = [responseObject objectForKey:@"gifs"];
	NSMutableArray *gifsArray = [[NSMutableArray alloc] initWithCapacity:kGifLimit];
    
	for (NSDictionary *gif in gifs) {
		Gif *vo = [[Gif alloc] init];
		vo.ID = [[gif valueForKey:@"id"] intValue];
		vo.url = [gif valueForKey:@"url"];
		vo.thumb = [gif valueForKey:@"thumb"];
        
		[gifsArray addObject:vo];
	}
    
	[delegate requestCompletedWithData:gifsArray
	                           isPaged:paged];
}

- (void)parseLogin:(NSDictionary *)responseObject {
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSDictionary *user = [responseObject objectForKey:@"user"];
	NSString *username = [user objectForKey:@"username"];
	[standardUserDefaults setBool:YES forKey:@"loggedin"];
	[standardUserDefaults setObject:username forKey:@"username"];
	[standardUserDefaults synchronize];
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:@"LoggedIn"
     object:self];
	[delegate requestCompletedWithData:@[]];
}

- (void)requestFailed:(NSError *)error {
	[delegate requestFailedWithError:error];
}

- (void)setContext:(NSString *)value {
	context = value;
}

- (NSString *)getContext {
	return context;
}

@end
