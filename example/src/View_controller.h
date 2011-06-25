//
//  ExampleViewController.h
//  Example
//
//  Created by Grzegorz Adam Hankiewicz on 19/06/11.
//  Copyright 2011 Electric Hands Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface View_controller : UIViewController
{
	BOOL is_running;
}

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *doing;

- (IBAction)start_tests;

@end

// vim:tabstop=4 shiftwidth=4 syntax=objc