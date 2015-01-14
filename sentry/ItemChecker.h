//
//  ItemChecker.h
//  sentry
//
//  Created by Charlie Jacobson on 1/13/15.
//  Copyright (c) 2015 Cover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <opencv.hpp>

@interface ItemChecker : NSObject 

- (instancetype)initWithImage: (UIImage*) image;

// key point info
- (int) numberOfKeypointsInItem;
- (UIImage*) imageWithKeypoints;

// compare with another image
- (int) numberOfMatchesWithImage: (UIImage*) compareTo;
- (float) ratioOfMatchesWithImage: (UIImage*) compareTo;

@end
