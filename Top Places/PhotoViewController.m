//
//  DisplayPhotoViewController.m
//  Top Places
//
//  Created by David Barton on 19/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoViewController.h"
#import "FlickrFetcher.h"


#define PHOTO_TITLE_KEY  @"title"
#define RECENT_PHOTOS_KEY @"RecentlyViewedPhotos.key"
#define PHOTO_ID_KEY @"id"
#define TOO_MANY_PHOTOS 20



@interface PhotoViewController() <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation PhotoViewController

@synthesize imageView = _photoView;
@synthesize scrollView = _scrollView;
@synthesize photo = _photo;

- (void)viewDidLoad {	
	[super viewDidLoad];	
	
	// Set this instance as the scroll view delegate
	self.scrollView.delegate = self;
	
	// Place the image in the image view
	self.imageView.image = [UIImage imageWithData:
									[NSData dataWithContentsOfURL:
									 [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge]]];

	// Set the title of the image
	self.title = [self.photo objectForKey:PHOTO_TITLE_KEY];
	
	// Setup the size of the scroll view
	self.scrollView.contentSize = self.imageView.image.size;
	
	// Setup the frame of the image
	self.imageView.frame = 
		CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
	
	
}

- (void)viewWillAppear:(BOOL)animated {
	
	
	// We need to store the photo as an NSUserDefault, since it is recently viewed
	// First get a handle to the standard user defaults
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	// Bring out the current list of recently viewed photos
	NSMutableArray *recentlyViewedPhotos = 
	[[defaults objectForKey:RECENT_PHOTOS_KEY] mutableCopy];
	
	// If we don't have any yet, then created an empty collection
	if (!recentlyViewedPhotos) recentlyViewedPhotos = [NSMutableArray array];
	
	// If we have too many photos already in our recently viewed list, then remove the one that 
	// was is first in the list - ie. added the longest time ago.
	if (recentlyViewedPhotos.count > TOO_MANY_PHOTOS) {
		[recentlyViewedPhotos removeObjectAtIndex:0];
	}
	
	// We need to check to see whether or not the photo is already stored in NSUserDefaults
	// So first get a handle to the id of the photo we are viewing
	NSString *photoID = [self.photo objectForKey:PHOTO_ID_KEY];
	
	// Then interate over our recently viewed photos
	for (int i = 0; i < recentlyViewedPhotos.count; i++) {
		NSDictionary *photo = [recentlyViewedPhotos objectAtIndex:i];
		if ([[photo objectForKey:PHOTO_ID_KEY] isEqualToString:photoID]) {
			// And remove the instance of the photo if we should find one
			[recentlyViewedPhotos removeObject:photo];
			continue;
		}
	}

	// Add the photo being to the top of the recently viewed photo list
	[recentlyViewedPhotos addObject:self.photo];
	
	// Add the updated collection back into user defaults
	[defaults setObject:recentlyViewedPhotos forKey:RECENT_PHOTOS_KEY];
	
	// Save the defaults
	[defaults synchronize];
		
}

- (void)viewWillLayoutSubviews { 

	// Width ratio compares the width of the viewing area with the width of the image	
	float widthRatio = self.view.bounds.size.width / self.imageView.image.size.width;
	
	// Height ratio compares the height of the viewing area with the height of the image	
	float heightRatio = self.view.bounds.size.height / self.imageView.image.size.height; 
	
	// Update the zoom scale
	self.scrollView.zoomScale = MAX(widthRatio, heightRatio);	

}

- (void)viewDidUnload {
	[self setImageView:nil];
	[self setScrollView:nil];
	[super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


#pragma mark - Scroll View Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return self.imageView;
}
@end
