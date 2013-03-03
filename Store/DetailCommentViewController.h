//
//  DetailCommentViewController.h
//  Store
//
//  Created by 鄒 西中 on 2/27/13.
//  Copyright (c) 2013 鄒 西中. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import "ReviewCell.h"
@interface DetailCommentViewController : UITableViewController
{
    NSArray *reviews;
}
@property (strong,nonatomic)NSString *appid;
@end
