//
//  ItemsViewController.m
//  sentry
//
//  Created by Charlie Jacobson on 1/13/15.
//  Copyright (c) 2015 Cover. All rights reserved.
//

#import "ItemsViewController.h"
#import "Item.h"
#import "AddItemViewController.h"
#import "ItemManager.h"

@implementation ItemsViewController

- (instancetype)init
{
	self = [super init];
	if (self){
		
		self.title = @"Items";
		
		self.navigationItem.title = @"Items";
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(tappedAddItem)];
		
		self.tabBarItem.title = @"Items";
		
		self.items = [ItemManager sharedManager].allItems;
		
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// table
	self.itemsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49) style:UITableViewStylePlain];
	self.itemsTable.dataSource = self;
	self.itemsTable.delegate = self;
	[self.view addSubview:self.itemsTable];
}

- (void) tappedAddItem
{
	AddItemViewController* addItemVC = [[AddItemViewController alloc] init];
	addItemVC.delegate = self;
	[self.navigationController pushViewController:addItemVC animated:YES];
}

- (void)didCreateItem:(Item *)newItem
{
	[[ItemManager sharedManager] addItem:newItem];
	[self.itemsTable reloadData];
}

# pragma mark - Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[ItemManager sharedManager].allItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* identifier = @"cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	
	if (cell == nil){
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	}
	
	Item *item = [[ItemManager sharedManager].allItems objectAtIndex:indexPath.row];
	cell.textLabel.text = item.name;
	
	return cell;
}

@end
