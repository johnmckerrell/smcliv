//
//  smclivAppDelegate.h
//  smcliv
//
//  Created by John McKerrell on 01/02/2011.
//  Copyright 2011 MKE Computing Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class smclivViewController;

@interface smclivAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *_window;
    smclivViewController *_viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet smclivViewController *viewController;

@end

