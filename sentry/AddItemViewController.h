//
//  AddItemViewController.h
//  sentry
//
//  Created by Charlie Jacobson on 1/13/15.
//  Copyright (c) 2015 Cover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@protocol AddItemViewControllerDelegate;

@interface AddItemViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property id<AddItemViewControllerDelegate> delegate;

@property Item *item;
@property UITextField *nameField;
@property UIButton *addImageButton;
@property UIImageView *imageView;

@end

@protocol AddItemViewControllerDelegate

- (void) didCreateItem: (Item*) newItem;

@end
