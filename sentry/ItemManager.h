//
//  ItemManager.h
//  sentry
//
//  Created by Charlie Jacobson on 1/13/15.
//  Copyright (c) 2015 Cover. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Item;

@interface ItemManager : NSObject

// all calls
@property (nonatomic, strong) NSMutableArray* allItems;

// singleton methods
- (void) initializeAllItems;
+ (ItemManager*) sharedManager;

- (void) addItem: (Item*) item;
@property int itemCount;

@end

