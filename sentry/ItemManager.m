//
//  ItemManager.m
//  sentry
//
//  Created by Charlie Jacobson on 1/13/15.
//  Copyright (c) 2015 Cover. All rights reserved.
//

#import "ItemManager.h"
#import "Item.h"

@implementation ItemManager

# pragma mark - Singleton Methods

static ItemManager* sharedSingleton = NULL;

@synthesize itemCount;

- (id)init
{
	if (![super init]) {
		return nil;
	}
	[self initializeAllItems];
	
	return self;
}

+ (ItemManager *)sharedManager
{
	@synchronized(self) {
		if (sharedSingleton == NULL) {
			sharedSingleton = [[self alloc] init];
		}
	}
	return sharedSingleton;
}

- (void)initializeAllItems
{
	NSLog(@"Initializing all calls");
	
	self.allItems = [[NSMutableArray alloc] init];
}

- (void)addItem:(id)item
{
	[[ItemManager sharedManager].allItems addObject:item];
	self.itemCount++;
}

@end
