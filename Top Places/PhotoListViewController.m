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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	// Get a handle to the photo dictionary at the currently selected row
	NSDictionary *photoDictionary = 
	[self.photoList objectAtIndex:self.tableView.indexPathForSelectedRow.row];
	
	// Set the retrieved image in the destination controller
	[[segue destinationViewController] setPhoto:photoDictionary];
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
