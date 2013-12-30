//
//  MyGif.h
//  Giffy
//
//  Created by Conn on 12/23/13.
//  Copyright (c) 2013 Conn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Gif : NSObject {
	NSInteger ID;
	NSString *url;
	NSString *thumb;
}

@property NSInteger ID;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *thumb;

@end
