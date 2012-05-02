//
//  PhotoDescriptionViewController.m
//  Top Places
//
//  Created by David Barton on 18/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoListViewController.h"
#import "FlickrFetcher.h"
#import "PhotoViewController.h"

@interface PhotoListViewController()



@end

@implementation PhotoListViewController


@synthesize photoList = _photoList;

#pragma mark - Setup methods


- (void)setPhotoList:(NSArray *)photoList withTitle:(NSString *)title {
	self.photoList = photoList;
	self.title = title;
}


- (void)viewDidLoad {	
	[super viewDidLoad];	
	
	// Preserve selection between presentations.
   self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewWillAppear:(BOOL)animated {
	// Show the navigation bar for view controllers when this view disappears
	[self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    // Return the number of rows in the section.
	return [self.photoList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
			cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
   static NSString *CellIdentifier = @"Photo Descriptions";
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	// Get a pointer to the dictionary that contains the details of photo
	NSDictionary *photosInPlace = [self.photoList objectAtIndex:indexPath.row];
	
	// Get a handle to the photo's title and description
	NSString *photoTitle = [photosInPlace objectForKey:TITLE_KEY]; 
	NSString *photoDescription = [photosInPlace valueForKeyPath:DESCRIPTION_KEY];
	
	// If the photo title is available set the cell's title to photoTitle and the cell's 
	// subtitle to the photo description
	if (photoTitle && ![photoTitle isEqualToString:@""]) {
		cell.textLabel.text = photoTitle;
		cell.detailTextLabel.text = photoDescription;
		// else if the photo description is available set the title equal to it
	} else if (photoDescription && ![photoDescription isEqualToString:@""]) { 
		cell.textLabel.text = photoDescription;
		cell.detailTextLabel.text = @"";
		// else set the title to Unknown
	} else {
		cell.textLabel.text = @"Unknown";
		cell.detailTextLabel.text = @"";
	}
	
	return cell;
}

#pragma mark - Segueing

- (NSDictionary *)photoDictionary {
	// Get a handle to the photo dictionary at the currently selected row
   return [self.photoList objectAtIndex:self.tableView.indexPathForSelectedRow.row];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {	

	// Set the retrieved image in the destination controller
	[[segue destinationViewController] setPhoto:[self photoDictionary]];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// Get a handle to the detail view controller
	PhotoViewController *photoViewController = 
		[[self.splitViewController viewControllers] lastObject];
	
	if (photoViewController) {
		// Set up the photoViewController model and synchronize it's views
		[photoViewController refreshWithPhoto: [self photoDictionary]];
	} // otherwise handled by the segue
	
}








@end
