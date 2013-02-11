//
//  WebBrowser.m
//  DisneyMap
//
//  Created by Xi Zhong Zou on 12/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "WebBrowser.h"
#import "Path.h"
#import "NSString+url.h"
@implementation WebBrowser
@synthesize webBrowser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.image = [UIImage imageNamed:@"web"];
        self.title = @"Web"; 

        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


-(IBAction)backClick:(id)sender
{
    [webBrowser goBack];
}
-(IBAction)forwardClick:(id)sender
{
    [webBrowser goForward];
}
-(IBAction)refreshClick:(id)sender
{
    [webBrowser reload];
}

- (IBAction)homeClick:(id)sender {
    [webBrowser loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://appdev.microsoft.com/StorePortals/en-us"]]];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSString *MIME = response.MIMEType;
    //    NSString *appDirectory = [[NSBundle mainBundle] bundlePath];
    //    NSString *pathMIMETYPESplist = [appDirectory stringByAppendingPathComponent:@"MIMETYPES.plist"];
    NSLog(@"response=%@",response.debugDescription);
    NSLog(@"mime=%@",MIME);
    
//    [receivedDataFromConnection setLength:0];
//    waitingForResponse = NO;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    NSString *url=request.URL.absoluteString;
    if ([url rangeOfString:@"00000000-"].location!=NSNotFound) {
        NSString *downloadString=request.URL.absoluteString;
        NSLog(@"down:%@",downloadString);
        NSString *savePath;
        savePath=[[Path documentPath]stringByAppendingPathComponent:[NSString urldecode:[[downloadString lastPathComponent]stringByAppendingPathExtension:@"csv"]]];
        NSData *data=[[NSData alloc]initWithContentsOfURL:request.URL];
        [data writeToFile:savePath atomically:YES];
        UIAlertView *alter=[[UIAlertView alloc]initWithTitle:@"Done" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil  , nil];
        [alter show];
    } else {
    }

//    NSString *MIME=request.;
//    NSLog(MIME);
//    if ([[[downloadString lastPathComponent]pathExtension]isEqualToString:@"mp3"]) {

//
//        //        else{
//        //            NSString *title=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//        //            savePath= [[Util documentPath]stringByAppendingPathComponent:[title stringByAppendingPathExtension:@"mp3"]];
//        //        }
//        [self.delegate myWebViewDownloadAction:request.URL.absoluteString filePath:savePath];
//        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate
//                                                 ];
//        [appDelegate selectTabBarIndex:1];
//        
//        
//        return NO;
//        
//    }
//    else{
        return YES;
//    }
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self homeClick:nil];
    // Do any additional setup after loading the view from its nib.
}



- (void)viewDidUnload
{
    [self setWebBrowser:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
