//
//  GiffyService.h
//  Giffy
//
//  Created by Conn on 12/23/13.
//  Copyright (c) 2013 Conn. All rights reserved.
//

#import "AFNetworking.h"
#import "Gif.h"

@protocol GiffyServiceDelegate
@optional
- (void)requestCompletedWithData:(NSArray *)data;
- (void)requestCompletedWithData:(NSArray *)data isPaged:(BOOL)paged;
@required
- (void)requestFailedWithError:(NSError *)error;
@end

@interface GiffyService : NSObject {
	NSString *context;
	NSString *next_page;
}

@property (strong) id <GiffyServiceDelegate> delegate;

- (void)getGifs;
- (void)getNext;

- (void)getTopGifs;
- (void)getAllGifs;
- (void)getMyGifs;

- (void)getAllGifs:(BOOL)paged;
- (void)getMyGifs:(BOOL)paged;

- (void)parseTopGifs:(NSDictionary *)request;
- (void)parseAllGifs:(NSDictionary *)request isPaged:(BOOL)paged;
- (void)parseMyGifs:(NSDictionary *)request isPaged:(BOOL)paged;
- (void)parseLogin:(NSDictionary *)request;

- (void)login:(NSString *)username password:(NSString *)password;
- (void)logout;

- (NSString *)getContext;
- (void)setContext:(NSString *)value;

@end
