//
//  smclivViewController.h
//  smcliv
//
//  Created by John McKerrell on 01/02/2011.
//  Copyright 2011 MKE Computing Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTTPTask;

@interface smclivViewController : UIViewController {
    NSArray *_maindata;
    NSDictionary *_appdata, *_filtersdata;
    HTTPTask *_updateTask;
    
    UIImageView *_backgroundImage;
    UILabel *_loadingLabel;
    UIActivityIndicatorView *_loadingActivity;
}

@property (nonatomic, retain) NSArray *maindata;
@property (nonatomic, retain) NSDictionary *appdata;
@property (nonatomic, retain) NSDictionary *filtersdata;
@property (nonatomic, retain) HTTPTask *updateTask;

@property (nonatomic, retain) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, retain) IBOutlet UILabel *loadingLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingActivity;

- (void)updateTaskFinished:(HTTPTask*)task;
- (void)showHierarchyViewController;

@end

