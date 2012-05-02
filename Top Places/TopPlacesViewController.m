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

@interface TopPlacesViewController() 

@property (strong, nonatomic) NSDictionary *placesByCountry;
@property (strong, nonatomic) NSArray *sectionHeaders;

@end

@implementation TopPlacesViewController

@synthesize topPlaces = _topPlaces;

@synthesize placesByCountry = _placesByCountry;
@synthesize sectionHeaders = _sectionHeaders;


#define CONTENT_KEY @"_content"


#pragma mark - Setup methods

- (NSString *)parseForCountry: (NSDictionary *) topPlace {
	
	// Get the place information from the given topPlace
	NSString *placeInformation = [topPlace objectForKey:CONTENT_KEY];
	
	// Search the place information for the last comma. 
	NSRange lastComma = [placeInformation rangeOfString:@"," options:NSBackwardsSearch];
	
	// Return the text that comes after the last comma
	if (lastComma.location != NSNotFound) {
		return [placeInformation substringFromIndex:lastComma.location + 2];
	} else return @"";
}

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
	

	// We want to divide the places up by country, so we can use a dictionary with the country
	// names as key as the places as values
	NSMutableDictionary *placesByCountry = [NSMutableDictionary dictionary];
	
	// For each place
	for (NSDictionary *place in self.topPlaces) {
		// extract the country name
		NSString *country = [self parseForCountry:place];	
		// If the country isn't already in the dictionary, add it with a new array
		if (![placesByCountry objectForKey:country]) {
			[placesByCountry setObject:[NSMutableArray array] forKey:country];
		}
		// Add the place to the countries' value array
		[(NSMutableArray *)[placesByCountry objectForKey:country] addObject:place];		
	}
	
	// Set the place by country
	self.placesByCountry = [NSDictionary dictionaryWithDictionary:placesByCountry];
	
	// Set up the section headers in alphabetical order	
	self.sectionHeaders = [[placesByCountry allKeys] sortedArrayUsingSelector: 
								  @selector(caseInsensitiveCompare:)];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}



#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

	// Return the number of sections
	return self.sectionHeaders.count;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	// Return the header at the given index
	return [self.sectionHeaders objectAtIndex:section];	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
	// Return the number of rows for the given the section
	return [[self.placesByCountry objectForKey:
				[self.sectionHeaders objectAtIndex:section]] count];

}



- (UITableViewCell *)tableView:(UITableView *)tableView 
			cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
	static NSString *CellIdentifier = @"Top Place Descriptions";
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];


	// Get a handle the dictionary that contains the selected top place information
	NSDictionary *topPlaceDictionary = 
	[[self.placesByCountry objectForKey:[self.sectionHeaders objectAtIndex:indexPath.section]] 
	 objectAtIndex:indexPath.row];

	// Extract the place name information for the cell
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





























@end
