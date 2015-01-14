//
//  Item.h
//  sentry
//
//  Created by Charlie Jacobson on 1/13/15.
//  Copyright (c) 2015 Cover. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

//#import "ItemChecker.h"

@class ItemChecker;

@interface Item : NSObject

@property NSString *name;

@property (nonatomic) UIImage *image;
@property ItemChecker *checker;

+ (Item*) itemWithName: (NSString*) name;

@end
