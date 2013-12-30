//
//  LoginViewController.h
//  Giffy
//
//  Created by Conn on 12/25/13.
//  Copyright (c) 2013 Conn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiffyService.h"
#import "MBProgressHUD.h"
#import "SWRevealViewController.h"

@interface AccountViewController : UIViewController <GiffyServiceDelegate>
{
	GiffyService *giffyService;
}

@end
