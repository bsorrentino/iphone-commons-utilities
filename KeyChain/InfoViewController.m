//
//  InfoViewController.m
//  KeyChain
//
//  Created by softphone on 29/03/12.
//  Copyright (c) 2012 SOFTPHONE. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (IBAction)showVideo:(id)sender {

#define YOUTUBE_1 @"http://www.youtube.com/watch?v=KsNFdkibU44&context=C407c249ADvjVQa1PpcFNS8ap2Q6YqkUIjLRK-kiKU_Q1k0KgzSdc=A"
    
#define YOUTUBE @"http://www.youtube.com/watch?v=0B-nxrle8CY&feature=g-upl"
    
    
    NSURL *url = 
        [[NSURL alloc] 
         initWithString:YOUTUBE ];
                  
    [[UIApplication sharedApplication] openURL:url ];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
