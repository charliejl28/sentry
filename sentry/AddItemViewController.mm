//
//  AddItemViewController.m
//  sentry
//
//  Created by Charlie Jacobson on 1/13/15.
//  Copyright (c) 2015 Cover. All rights reserved.
//

#import "AddItemViewController.h"
#import "Constants.h"
//#import <opencv2/opencv.hpp>
#import "ItemChecker.h"

@implementation AddItemViewController

- (instancetype)init
{
	self = [super init];
	if (self){
		
		self.item = [[Item alloc] init];
		self.view.backgroundColor = cloudsColor;
		self.title = @"New Item";
		
		// name text field
		self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(20, 65, self.view.frame.size.width-40, 40)];
		[self.nameField addTarget:self action:@selector(nameFieldDidReturn) forControlEvents: UIControlEventEditingDidEnd];
		[self.nameField addTarget:self action:@selector(nameFieldDidReturn) forControlEvents: UIControlEventEditingDidEndOnExit];

		self.nameField.textAlignment = NSTextAlignmentCenter;
		self.nameField.placeholder = @"Tap to add name";
		[self.view addSubview:self.nameField];
		
		self.addImageButton = [UIButton buttonWithType:UIButtonTypeSystem];
		self.addImageButton.frame = CGRectMake(20, (self.view.frame.size.height-150)/2.0, self.view.frame.size.width-40, 40);
		[self.addImageButton setTitle:@"Add image" forState:UIControlStateNormal];
		[self.addImageButton addTarget:self action:@selector(tappedAddImage) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:self.addImageButton];
		
		
		// save button
		UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height-109, self.view.frame.size.width-40, 50)];
		[saveButton addTarget:self action:@selector(tappedSave) forControlEvents:UIControlEventTouchUpInside];
		saveButton.backgroundColor = emerlandColor;
		[saveButton setTitleColor:cloudsColor forState:UIControlStateNormal];
		[saveButton setTitle:@"Save" forState:UIControlStateNormal];
		[self.view addSubview:saveButton];
		
		// image view
		self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.nameField.frame.origin.y + self.nameField.frame.size.height, self.view.frame.size.width, saveButton.frame.origin.y - self.nameField.frame.origin.y - self.nameField.frame.size.height - 10)];
		self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		

		
	}
	return self;
}

- (void) nameFieldDidReturn
{
	[self.nameField resignFirstResponder];
}

- (void) tappedAddImage
{
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.allowsEditing = YES;
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	
	[self presentViewController:picker animated:YES completion:^{	}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
	
	NSLog(@"image is [%f x %f]", chosenImage.size.width, chosenImage.size.height);
	
	self.imageView.image = chosenImage;
	[self.addImageButton removeFromSuperview];
	[self.view addSubview:self.imageView];
	
	[self dismissViewControllerAnimated:YES completion:^{
		
	}];
	
	self.item.image = chosenImage;
	self.imageView.image = [self.item.checker imageWithKeypoints];
}



- (void) tappedSave
{
	self.item.name = self.nameField.text;
	[self.delegate didCreateItem:self.item];
	[self.navigationController popViewControllerAnimated:YES];
}

@end
