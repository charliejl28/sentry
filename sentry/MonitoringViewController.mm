
//
//  MonitoringViewController.m
//  sentry
//
//  Created by Charlie Jacobson on 1/12/15.
//  Copyright (c) 2015 Cover. All rights reserved.
//

#import "MonitoringViewController.h"
#import "Constants.h"
#import "ItemManager.h"
#import "Item.h"
#import "ItemChecker.h"

@interface MonitoringViewController ()

@property float buttonHeight;
@property float tabHeight;
@property float statusHeight;

@end

@implementation MonitoringViewController

- (instancetype)init
{
	self = [super init];
	if (self){
		
		[[ItemManager sharedManager] addObserver:self forKeyPath:@"itemCount" options:NSKeyValueObservingOptionNew context:nil];
		
		self.buttonHeight = 70;
		self.tabHeight = 49;
		self.statusHeight = 25;
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.navigationItem.title = @"Home";
	self.tabBarItem.title = @"Home";
	
	// status label
	self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.statusHeight)];
	self.statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
	self.statusLabel.textAlignment = NSTextAlignmentCenter;
	self.statusLabel.backgroundColor = pomegranateColor;
	self.statusLabel.alpha = 0.6;
	self.statusLabel.textColor = cloudsColor;
	[self.view addSubview:self.statusLabel];
	[self updateStatusLabel];
	
	// button background
	UIView* buttonBack = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-self.buttonHeight-self.tabHeight, self.view.frame.size.width, self.buttonHeight)];
	buttonBack.backgroundColor = cloudsColor;
	[self.view addSubview:buttonBack];
	
	// monitoring button
	self.monitoringButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.monitoringButton.frame = CGRectMake(20, 10, buttonBack.frame.size.width-40, self.buttonHeight-20);
	[self.monitoringButton addTarget:self action:@selector(didTapMonitoringButton:) forControlEvents:UIControlEventTouchUpInside];
	[self updateMonitoringButton];
	[buttonBack addSubview:self.monitoringButton];

	
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	// image picker
	self.imagePickerVC = [[UIImagePickerController alloc] init];
	self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
	self.imagePickerVC.showsCameraControls = NO;
	self.imagePickerVC.delegate = self;
	
	[self addChildViewController:self.imagePickerVC];
	self.imagePickerVC.view.frame = CGRectMake(0, 64, 320, 480);
	
	self.imagePickerVC.delegate = self;
	self.imagePickerVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	[self.view insertSubview:self.imagePickerVC.view atIndex:0];
	[self.imagePickerVC didMoveToParentViewController:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	[self.imagePickerVC removeFromParentViewController];
	self.imagePickerVC = nil;
}
- (void) updateStatusLabel
{
	self.statusLabel.text = [NSString stringWithFormat:@"%d out of %ld items in view", 0, [[ItemManager sharedManager].allItems count] ];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	NSLog(@"observed value change!");
	
	if ([keyPath isEqualToString:@"itemCount"]){
		NSLog(@"item count changed!");
		[self updateStatusLabel];
	}
	
	
}


- (void) updateMonitoringButton
{
	if (self.isMonitoring) {
		[self.monitoringButton setTitle:@"Stop monitoring" forState:UIControlStateNormal];
		[self.monitoringButton setTitleColor:cloudsColor forState:UIControlStateNormal];
		[self.monitoringButton setBackgroundColor:alizarinColor];
	}
	else {
		[self.monitoringButton setTitle:@"Start monitoring" forState:UIControlStateNormal];
		[self.monitoringButton setTitleColor:cloudsColor forState:UIControlStateNormal];
		[self.monitoringButton setBackgroundColor:emerlandColor];
	}
}

- (void) didTapMonitoringButton: (id) sender
{
	self.isMonitoring = !self.isMonitoring;
	[self updateMonitoringButton];
	[self.imagePickerVC takePicture];
}

# pragma mark - Image Picker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSLog(@"did finish picking media!");
	UIImage *currentImage = info[UIImagePickerControllerOriginalImage];
	currentImage = [MonitoringViewController imageWithImage:currentImage scaledToSize:CGSizeMake(640, 640)];
	
	NSLog(@"image is [%f x %f]", currentImage.size.width, currentImage.size.height);

	[self checkCurrentScreen:currentImage];
}


+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
	//UIGraphicsBeginImageContext(newSize);
	// In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
	// Pass 1.0 to force exact pixel size.
	UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
	[image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

- (void) checkCurrentScreen: (UIImage*) currentScreen
{
	NSLog(@"-------- CHECKING ROOM ---------");
	for (Item *item in [ItemManager sharedManager].allItems){
		[self checkScreen:currentScreen forItem:item];
	}
}

- (void) checkScreen: (UIImage*) currentScreen forItem: (Item*) item
{
	int result = [item.checker numberOfMatchesWithImage: currentScreen];
	NSLog(@"%@: %d", item.name, result);
}

- (void)didReceiveMemoryWarning
{
	NSLog(@"MEMORY WARNING");
}

@end
