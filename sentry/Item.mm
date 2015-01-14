
//
//  Item.m
//  sentry
//
//  Created by Charlie Jacobson on 1/13/15.
//  Copyright (c) 2015 Cover. All rights reserved.
//

#import "Item.h"
#import "ItemChecker.h"
//#import <opencv2/opencv.hpp>

@implementation Item;

@synthesize image;

+ (Item *)itemWithName:(NSString *)name
{
	Item* item = [[Item alloc] init];
	item.name = name;
	return item;
}

- (void)setImage:(UIImage *)image_
{
	image = image_;
	self.checker = [[ItemChecker alloc] initWithImage:self.image];
}

@end
