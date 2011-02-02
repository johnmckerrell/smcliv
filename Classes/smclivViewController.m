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
#import "HierarchyViewController.h"

const CGFloat MAX_TIME_INTERVAL = 1800.00;

@implementation smclivViewController

@synthesize appdata = _appdata;
@synthesize filtersdata = _filtersdata;
@synthesize maindata = _maindata;
@synthesize updateTask = _updateTask;
@synthesize backgroundImage = _backgroundImage;
@synthesize loadingLabel = _loadingLabel;
@synthesize loadingActivity = _loadingActivity;
@synthesize hierarchyController = _hierarchyController;

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
            id httpMainData = nil;
            if ([NSPropertyListSerialization respondsToSelector:@selector(propertyListWithData:options:format:error:)]) {
                httpMainData = [NSPropertyListSerialization propertyListWithData:task.httpData options:NSPropertyListImmutable format:nil error:nil];
            } else if ([NSPropertyListSerialization respondsToSelector:@selector(propertyListFromData:mutabilityOption:format:errorDescription:)]) {
                httpMainData = [NSPropertyListSerialization propertyListFromData:task.httpData mutabilityOption:NSPropertyListImmutable format:nil errorDescription:nil];
            }
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
    // For some reason the navigationBar would initially show 20 pixels too low
    // Removing the hierarchy view and re-adding it seems to fix it
    self.hierarchyController = [[[HierarchyViewController alloc] initWithAppData:self.appdata filtersData:self.filtersdata mainData:self.maindata] autorelease];
    [self.view insertSubview:self.hierarchyController.view belowSubview:self.backgroundImage];
    [self.hierarchyController.view removeFromSuperview];
    [self.view insertSubview:self.hierarchyController.view belowSubview:self.backgroundImage];
    
    [self.hierarchyController viewWillAppear:YES];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
    self.loadingLabel.alpha = 0.0;
    self.loadingActivity.alpha = 0.0;
    self.backgroundImage.alpha = 0.0;
    [UIView commitAnimations];
    
}

- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [self.hierarchyController viewDidAppear:YES];
    [self.backgroundImage removeFromSuperview];
    [self.loadingLabel removeFromSuperview];
    [self.loadingActivity stopAnimating];
    [self.loadingActivity removeFromSuperview];
    self.backgroundImage = nil;
    self.loadingLabel = nil;
    self.loadingActivity = nil;
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
        // Using a timer to fix incorrect positioning of navigationBar
        // See showHierarchyViewController for more information
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(showHierarchyViewController) userInfo:nil repeats:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.hierarchyController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.hierarchyController viewDidAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.hierarchyController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.hierarchyController viewDidDisappear:animated];
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
