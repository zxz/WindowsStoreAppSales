//
//  WebBrowser.h
//  DisneyMap
//
//  Created by Xi Zhong Zou on 12/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebBrowser : UIViewController
@property ( weak, nonatomic) IBOutlet UIWebView *webBrowser;
-(IBAction)backClick:(id)sender;
-(IBAction)forwardClick:(id)sender;
-(IBAction)refreshClick:(id)sender;
- (IBAction)homeClick:(id)sender;
@end
