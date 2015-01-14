//
//  MonitoringViewController.h
//  sentry
//
//  Created by Charlie Jacobson on 1/12/15.
//  Copyright (c) 2015 Cover. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonitoringViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property UILabel *statusLabel;

@property UIImagePickerController *imagePickerVC;

@property UIButton *monitoringButton;
@property BOOL isMonitoring;

@end
