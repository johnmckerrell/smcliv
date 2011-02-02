//
//  TalkViewController.h
//  smcliv
//
//  Created by John McKerrell on 02/02/2011.
//  Copyright 2011 MKE Computing Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HierarchyViewController;

@interface TalkViewController : UITableViewController {
    NSDictionary *_itemData;
    NSInteger _numSections;
    NSString *_talkOverview;
    NSString *_talkBio;
    NSArray *_talkActions;
    HierarchyViewController *_hierarchyController;
}

@property (nonatomic, retain) NSDictionary *itemData;
@property (nonatomic) NSInteger numSections;
@property (nonatomic, retain) NSString *talkOverview;
@property (nonatomic, retain) NSString *talkBio;
@property (nonatomic, retain) NSArray *talkActions;
@property (nonatomic, retain) HierarchyViewController *hierarchyController;

-(id) initWithItem:(NSDictionary*)itemData;

@end
