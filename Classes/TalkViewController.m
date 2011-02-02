//
//  TalkViewController.m
//  smcliv
//
//  Created by John McKerrell on 02/02/2011.
//  Copyright 2011 MKE Computing Ltd. All rights reserved.
//

#import "TalkViewController.h"

#import "HierarchyViewController.h"


@implementation TalkViewController

@synthesize itemData = _itemData;
@synthesize numSections = _numSections;
@synthesize talkOverview = _talkOverview;
@synthesize talkBio = _talkBio;
@synthesize talkActions = _talkActions;
@synthesize hierarchyController = _hierarchyController;

#pragma mark -
#pragma mark Initialization

-(id) initWithItem:(NSDictionary*)itemData {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.itemData = itemData;
        NSInteger sections = 0;
        self.talkOverview = [self.itemData objectForKey:@"overview"];
        if (self.talkOverview) {
            ++sections;
        }
        self.talkBio = [self.itemData objectForKey:@"bio"];
        if (self.talkBio) {
            ++sections;
        }
        self.talkActions = [self.itemData objectForKey:@"actions"];
        if (self.talkActions) {
            ++sections;
        }
        self.numSections = sections;
    }
    return self;
}
/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = [self.itemData objectForKey:@"title"];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.numSections;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.talkActions && section == (self.numSections - 1)) {
        return [self.talkActions count];
    }
    return 1;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.talkActions && section == (self.numSections - 1)) {
        return NSLocalizedString(@"TALK_ACTIONS",@"");
    }
    if (self.talkOverview && section == 0) {
        return NSLocalizedString(@"TALK_OVERVIEW",@"");
    }
    if (self.talkBio) {
        return NSLocalizedString(@"TALK_BIO",@"");
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = nil;
    if (self.talkActions && indexPath.section == (self.numSections - 1)) {
        return 44;
    }
    if (self.talkOverview && indexPath.section == 0) {
        text = self.talkOverview;
    }
    if (!text && self.talkBio) {
        text = self.talkBio;
    }
    if (text) {
        UIFont *font = [UIFont systemFontOfSize:18];
        CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(280, FLT_MAX) lineBreakMode:UILineBreakModeWordWrap];
        size.height += 10.0;
        if (size.height > 44.0) {
            NSLog(@"indexPath=%@ height=%f", indexPath, size.height);
            return size.height;
        }
    }
    
    return 44;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    static NSString *BigCellIdentifier = @"BigCell";

    UITableViewCell *cell = nil;
    if (self.talkActions && indexPath.section == (self.numSections - 1)) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.indentationLevel = 1;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        NSDictionary *action = [self.talkActions objectAtIndex:indexPath.row];
        cell.textLabel.text = [action objectForKey:@"title"];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:BigCellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BigCellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.textLabel.font = [UIFont systemFontOfSize:18];
        }
        
        if (indexPath.section == 0 && self.talkOverview) {
            cell.textLabel.text = self.talkOverview;
        } else {
            cell.textLabel.text = self.talkBio;
        }
    }

    
    
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
    if (self.talkActions && indexPath.section == (self.numSections - 1)) {
        NSDictionary *action = [self.talkActions objectAtIndex:indexPath.row];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[action objectForKey:@"url"]]];
        
        [self.hierarchyController loadURLRequestInLocalBrowser:request];
        
        [request release]; request = nil;
        
    }        
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"cell.frame=%@", NSStringFromCGRect(cell.frame));
    NSLog(@"cell.textLabel.frame=%@", NSStringFromCGRect(cell.textLabel.frame));
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

