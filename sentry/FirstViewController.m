//
//  FirstViewController.m
//  sentry
//
//  Created by Charlie Jacobson on 1/12/15.
//  Copyright (c) 2015 Cover. All rights reserved.
//

#import "FirstViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	

	self.imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
	[self.view addSubview:self.imageView];
}

- (void)viewDidAppear:(BOOL)animated{

	[super viewDidAppear:animated];
	
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.allowsEditing = YES;
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	
	[self presentViewController:picker animated:YES completion:^{	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
	self.imageView.image = chosenImage;
	
	[picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
	if (error) {
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle: @"Save failed"
							  message: @"Failed to save image"
							  delegate: nil
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil];
		[alert show];
	}
}

@end
