//
//  smclivAppDelegate.m
//  smcliv
//
//  Created by John McKerrell on 01/02/2011.
//  Copyright 2011 MKE Computing Ltd. All rights reserved.
//

#import "smclivAppDelegate.h"
#import "smclivViewController.h"

@implementation smclivAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize internetReach = _internetReach;
@synthesize currentNetworkStatus = _currentNetworkStatus;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    self.internetReach = [Reachability reachabilityForInternetConnection];
    [self.internetReach startNotifier];
    self.currentNetworkStatus = [self.internetReach currentReachabilityStatus];
    
	// Set the view controller as the window's root view controller and display.
    if ([self.window respondsToSelector:@selector(setRootViewController:)]) {
        self.window.rootViewController = self.viewController;
    } else {
        // Support < iOS 4.0
        [self.window addSubview:self.viewController.view];
    }

    [self.window makeKeyAndVisible];

    return YES;
}

- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    self.currentNetworkStatus = [curReach currentReachabilityStatus];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSDate date] forKey:@"lastRun"];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSDate date] forKey:@"lastRun"];
}

#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths lastObject];
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    self.viewController = nil;
    self.window = nil;
    self.internetReach = nil;
    
    [super dealloc];
}


@end
