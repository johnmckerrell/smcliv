//
//  smclivViewController.m
//  smcliv
//
//  Created by John McKerrell on 01/02/2011.
//  Copyright 2011 MKE Computing Ltd. All rights reserved.
//

#import "smclivViewController.h"

#import "smclivAppDelegate.h"
#import "HTTPTask.h"

const CGFloat MAX_TIME_INTERVAL = 1800.00;

@implementation smclivViewController

@synthesize appdata = _appdata;
@synthesize filtersdata = _filtersdata;
@synthesize maindata = _maindata;
@synthesize updateTask = _updateTask;
@synthesize backgroundImage = _backgroundImage;
@synthesize loadingLabel = _loadingLabel;
@synthesize loadingActivity = _loadingActivity;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)updateTaskFinished:(HTTPTask*)task {
    smclivAppDelegate *appDelegate = (smclivAppDelegate*)[[UIApplication sharedApplication] delegate];

    if (task == self.updateTask) {
        if (!task.failed && [task.httpData length]) {
            id httpMainData = [NSPropertyListSerialization propertyListWithData:task.httpData options:NSPropertyListImmutable format:nil error:nil];
            if (httpMainData && [httpMainData isKindOfClass:[NSArray class]]) {
                self.maindata = httpMainData;
                NSString *maindataDocumentsPath = [[appDelegate applicationDocumentsDirectory] stringByAppendingPathComponent:@"maindata.plist"];
                [task.httpData writeToFile:maindataDocumentsPath atomically:YES];
            }
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        self.updateTask = nil;
        [self showHierarchyViewController];
    }
}

- (void)showHierarchyViewController {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.loadingLabel.alpha = 0.0;
    self.loadingActivity.alpha = 0.0;
    self.backgroundImage.alpha = 0.0;
    [UIView commitAnimations];
    
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    smclivAppDelegate *appDelegate = (smclivAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL loadingData = NO;
    if (!self.appdata) {
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        self.appdata = [NSDictionary dictionaryWithContentsOfFile:[bundlePath stringByAppendingPathComponent:@"appdata.plist"]];
        self.filtersdata = [NSDictionary dictionaryWithContentsOfFile:[bundlePath stringByAppendingPathComponent:@"filtersdata.plist"]];
        self.maindata = [NSArray arrayWithContentsOfFile:[bundlePath stringByAppendingPathComponent:@"maindata.plist"]];
        
        NSString *maindataDocumentsPath = [[appDelegate applicationDocumentsDirectory] stringByAppendingPathComponent:@"maindata.plist"];
        NSArray *documentsMaindata = nil;
        if ([fileManager fileExistsAtPath:maindataDocumentsPath]) {
            documentsMaindata = [NSArray arrayWithContentsOfFile:maindataDocumentsPath];
            if (documentsMaindata) {
                self.maindata = documentsMaindata;
            }
        }
        
        NSDate *lastRun = [userDefaults objectForKey:@"lastRun"];
        if (appDelegate.currentNetworkStatus != NotReachable &&
            ( ! lastRun || [lastRun timeIntervalSinceNow] < - MAX_TIME_INTERVAL ) ) {
            HTTPTask *task = [[HTTPTask alloc] initWithURL:[NSURL URLWithString:@"http://johnmckerrell.com/files/smcliv-maindata.plist"] target:self action:@selector(updateTaskFinished:)];
            self.updateTask = task;
            if (documentsMaindata) {
                task.lastModifiedDate = [[fileManager attributesOfItemAtPath:maindataDocumentsPath error:nil] fileModificationDate];
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            loadingData = YES;
            [task start];
            [task release]; task = nil;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            self.loadingLabel.text = NSLocalizedString(@"UPDATING_CONTENT",@"");
            self.loadingLabel.alpha = 1.0;
            self.loadingActivity.alpha = 1.0;
            [UIView commitAnimations];
        }
    }

    if (!loadingData) {
        [self showHierarchyViewController];
    }
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    self.appdata = nil;
    self.maindata = nil;
    self.filtersdata = nil;
    self.updateTask = nil;
    
    self.backgroundImage = nil;
    self.loadingLabel = nil;
    self.loadingActivity = nil;
    
    [super dealloc];
}

@end
