//
//  TopPlacesViewController.m
//  Top Places
//
//  Created by David Barton on 18/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TopPlacesViewController.h"
#import "FlickrFetcher.h"
#import "PhotoListViewController.h"

@implementation TopPlacesViewController

@synthesize topPlaces = _topPlaces;

#define CONTENT_KEY @"_content"


#pragma mark - Setup methods

- (void)loadTopPlaces {
	
	// Only load data if not set up already
	if (self.topPlaces) return;
   
	// Create a sorted array of place descriptions
	NSArray *sortDescriptors = [NSArray arrayWithObject:
										 [NSSortDescriptor sortDescriptorWithKey:CONTENT_KEY 
																				 ascending:YES]];
	
	// Set up the array of top places, organised by place descriptions
	self.topPlaces = [[FlickrFetcher topPlaces] 
							sortedArrayUsingDescriptors:sortDescriptors];
}


- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	// Setup any model data from Flickr
	[self loadTopPlaces];	
	
	// Preserve selection between presentations.
   self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewDidUnload {
	[super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated {
	// Hide the navigation bar for view controllers when this view appears
	[self.navigationController setNavigationBarHidden:YES animated:animated];
	[super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
	// Show the navigation bar for view controllers when this view disappears
	[self.navigationController setNavigationBarHidden:NO animated:animated];
	[super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark - Data extraction


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
	// Return the number of rows in the section.
   return [self.topPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
			cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
	static NSString *CellIdentifier = @"Top Place Descriptions";
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	
	// Extract the place name information for the cell
	NSDictionary *topPlaceDictionary = [self.topPlaces objectAtIndex:indexPath.row];
	NSString *topPlaceDescription = [topPlaceDictionary objectForKey:CONTENT_KEY];
	
	// Format the top place description into the cell's title and subtitle
	// Check to see if place description has a comma
	NSRange firstComma = [topPlaceDescription rangeOfString:@","];
	
	// If no comma, then title is place description and we have no subtitle, otherwise set the 
	// title to everything before the comma and the subtitle to everything after it.
	if (firstComma.location == NSNotFound) {
		cell.textLabel.text = topPlaceDescription;
		cell.detailTextLabel.text = @"";
	} else {
		cell.textLabel.text = [topPlaceDescription substringToIndex:firstComma.location];
		cell.detailTextLabel.text = [topPlaceDescription substringFromIndex:
											  firstComma.location + 1];		
	}
   return cell;
}


#pragma mark - Segueing

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	// Get a pointer to the dictionary at the currently selected row index
	NSDictionary *placeDictionary = 
	[self.topPlaces objectAtIndex:self.tableView.indexPathForSelectedRow.row];
	
	// Set up the photo descriptions in the PhotoDescriptionViewController
	[[segue destinationViewController] setPhotoList:[FlickrFetcher photosInPlace:placeDictionary
																							maxResults:50]
													  withTitle:[[sender textLabel] text]];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // Navigation logic may go here. Create and push another view controller.
   /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    */
}





























@end
