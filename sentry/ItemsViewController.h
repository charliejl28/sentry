//
//  ItemsViewController.h
//  sentry
//
//  Created by Charlie Jacobson on 1/13/15.
//  Copyright (c) 2015 Cover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddItemViewController.h"

@interface ItemsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, AddItemViewControllerDelegate>

@property UITableView *itemsTable;
@property NSMutableArray *items;

@end
