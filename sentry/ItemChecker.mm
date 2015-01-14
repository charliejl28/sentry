//
//  ItemChecker.m
//  sentry
//
//  Created by Charlie Jacobson on 1/13/15.
//  Copyright (c) 2015 Cover. All rights reserved.
//

#import "ItemChecker.h"
#import "UIImage+OpenCV.h"

@interface ItemChecker () {
	cv::Mat baseImage;
	cv::Mat baseImageGray;
	std::vector<cv::KeyPoint> keypoints;
}


@end

@implementation ItemChecker

- (instancetype) init
{
	self = [super init];
	if (self){
		
	}
	return self;
}

- (instancetype)initWithImage: (UIImage*) image
{
	self = [self init];
	if (self){
		
		// create base image
//		UIImage *scaledImaged = [self imageWithImage:image scaledToSize:CGSizeMake(image.size.width/4, image.size.width/4)];
//		self->baseImage = [UIImage toCVMat:scaledImaged];
		self->baseImage = [UIImage toCVMat:image];
		self->baseImageGray = [self grayImage:self->baseImage];
		
		// extract keypoints to use later
		self->keypoints = [self keypointsForImage:self->baseImage];
	}
	return self;
}

- (UIImage*) imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
	//UIGraphicsBeginImageContext(newSize);
	// In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
	// Pass 1.0 to force exact pixel size.
	UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
	[image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

- (std::vector<cv::KeyPoint>) keypointsForImage: (cv::Mat) image
{
	NSLog(@"creating keypoints for image: %d", self->baseImage.empty());
	cv::SURF detector(400);
	std::vector<cv::KeyPoint> someKeypoints;
	detector.detect(image, someKeypoints);
	NSLog(@"found %ld keypoints", someKeypoints.size());
	return someKeypoints;
}

- (cv::Mat) grayImage: (cv::Mat&) image
{
	cv::Mat tempImage;
	cv::cvtColor(self->baseImage, tempImage, CV_BGR2GRAY);
	return tempImage;
}

- (int) numberOfKeypointsInItem
{
	return int(self->keypoints.size());
}

- (UIImage*) imageWithKeypoints
{
	NSLog(@"drawing %d image keypoints", int(self->keypoints.size()));
	cv::Mat img_keypoints;
	
	cv::Mat tempGray;
	cv::cvtColor(self->baseImage, tempGray, CV_BGR2GRAY);
	
	drawKeypoints(tempGray, self->keypoints, img_keypoints, cv::Scalar::all(-1), cv::DrawMatchesFlags::DEFAULT );
	return [UIImage fromCVMat:img_keypoints];
}

- (int) numberOfMatchesWithImage: (UIImage*) compareTo
{
	float height = compareTo.size.height;
	float width = compareTo.size.width;
	
	int searchNumber = 1;
	float searchHeight = height/searchNumber;
	float searchWidth = width/searchNumber;
	
	int maxMatches = 0;
	
	for (int x = 0; x < searchNumber; x++) {
		for (int y = 0; y < searchNumber; y++) {
			CGRect crop = CGRectMake(x*searchWidth, y*searchHeight, searchWidth, searchHeight);
			UIImage *subImage = [self cropImage:compareTo withRect:crop];
			int currentMatches = [self numberOfMatchesInSubImage:subImage];
			
			NSLog(@"Search at (%f, %f) \tResult: %d", x*searchWidth, y*searchHeight, currentMatches);
			
			if (currentMatches > maxMatches){
				maxMatches = currentMatches;
			}
		}
	}
	return maxMatches;
}

- (int) numberOfMatchesInSubImage: (UIImage*) compareTo
{
	NSLog(@"comparing with sub image: [%f x %f]", compareTo.size.width, compareTo.size.height );
	
	cv::Mat newImage = [UIImage toCVMat:compareTo];
	cv::Mat newImageGray;
	
	NSLog(@"created new image");
	
	cv::cvtColor(newImage, newImageGray, CV_BGR2GRAY);
	cv::SURF detector(400);
	
	NSLog(@"converted to gray color");
	
	
	std::vector<cv::KeyPoint> newKeypoints;
	detector.detect(newImage, newKeypoints);
	
	
	NSLog(@"%ld keypoints for new image", newKeypoints.size());
	
	// computing descriptors
	cv::SURF extractor;
	cv::Mat descriptors1, descriptors2;
	extractor.compute(self->baseImage, self->keypoints, descriptors1);
	extractor.compute(newImage, newKeypoints, descriptors2);
	
	//-- Step 3: Matching descriptor vectors using FLANN matcher
	cv::FlannBasedMatcher matcher;
	std::vector< cv::DMatch > matches;
	matcher.match( descriptors1, descriptors2, matches );
	
	double max_dist = 0; double min_dist = 100;
	
	
	//-- Quick calculation of max and min distances between keypoints
	for( int i = 0; i < descriptors1.rows; i++ )
  { double dist = matches[i].distance;
	  if( dist < min_dist ) min_dist = dist;
	  if( dist > max_dist ) max_dist = dist;
  }
	
	printf("-- Max dist : %f \n", max_dist );
	printf("-- Min dist : %f \n", min_dist );
	
	//-- Draw only "good" matches (i.e. whose distance is less than 2*min_dist,
	//-- or a small arbitary value ( 0.02 ) in the event that min_dist is very
	//-- small)
	//-- PS.- radiusMatch can also be used here.
	std::vector< cv::DMatch > good_matches;
	
	for( int i = 0; i < descriptors1.rows; i++ )
  { if( matches[i].distance <= MAX(2*min_dist, 0.02) )
	  { good_matches.push_back( matches[i]); }
  }
	
	return (int)good_matches.size();
}

- (UIImage*) cropImage: (UIImage*) largeImage withRect:(CGRect) cropRect
{
	CGImageRef imageRef = CGImageCreateWithImageInRect([largeImage CGImage], cropRect);
	UIImage* image = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	return image;
}

- (float) ratioOfMatchesWithImage: (UIImage*) compareTo
{
	return 0;
}


@end
