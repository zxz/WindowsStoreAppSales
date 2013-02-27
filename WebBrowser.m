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
#import "RecordManager.h"
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
        NSArray *urls=[url componentsSeparatedByString:@"/"];
        int count= [urls count];
        if (count<2) {
            return YES;
        }
        savePath=[[Path documentPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.%@",urls[count-2],urls[count-1], @"csv"]];
        NSData *data=[[NSData alloc]initWithContentsOfURL:request.URL];
        
        NSString *contect=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if ([contect rangeOfString:@"doesn't include any transactions"].location!=NSNotFound) {
            UIAlertView *alter=[[UIAlertView alloc]initWithTitle:@"No data avaliable" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil  , nil];
            [alter show];
            return YES;
        }
        
        [data writeToFile:savePath atomically:YES];
        
        
        [[RecordManager sharedInstance]importFile:savePath shouldRemoveOld:YES];
//        [[RecordManager sharedInstance]refreshData];
        UIAlertView *alter=[[UIAlertView alloc]initWithTitle:@"Done" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil  , nil];
        [alter show];
        
    } else {
    }

        return YES;
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
