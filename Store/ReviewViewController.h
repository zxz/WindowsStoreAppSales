//
//  ReviewViewController.h
//  Store
//
//  Created by 鄒 西中 on 2/27/13.
//  Copyright (c) 2013 鄒 西中. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ReviewManager.h"

@interface ReviewViewController : UITableViewController<MBProgressHUDDelegate,ReviewManagerDelegate>
{
    NSArray *apps;
    MBProgressHUD *HUD;

}
@end
