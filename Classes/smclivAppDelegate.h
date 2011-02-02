//
//  smclivAppDelegate.h
//  smcliv
//
//  Created by John McKerrell on 01/02/2011.
//  Copyright 2011 MKE Computing Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@class smclivViewController;

@interface smclivAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *_window;
    smclivViewController *_viewController;
    Reachability *_internetReach;
    NetworkStatus _currentNetworkStatus;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet smclivViewController *viewController;
@property (nonatomic, retain) Reachability *internetReach;
@property (nonatomic, assign) NetworkStatus currentNetworkStatus;

- (NSString *)applicationDocumentsDirectory;

@end

