//
//  ExampleViewController.m
//  Example
//
//  Created by Grzegorz Adam Hankiewicz on 19/06/11.
//  Copyright 2011 Electric Hands Software. All rights reserved.
//

#import "View_controller.h"

#import "ELHASO.h"
#import "NSArray+ELHASO.h"
#import "NSString+ELHASO.h"

@implementation View_controller

@synthesize label;
@synthesize doing;

- (void)dealloc
{
	[label dealloc];
	[doing dealloc];
	[super dealloc];
}

- (void)viewDidLoad
{
	self.label.text = @"";
}

- (void)start_tests
{
	if (is_running)
		return;

	is_running = YES;
	[doing startAnimating];
	self.label.text = @"";
	[self performSelector:@selector(run_tests) withObject:nil afterDelay:0];
}

- (void)run_nsarray_tests
{
	NSArray *t1 = [NSArray arrayWithObject:@"Test"];
	LOG(@"Getting first entry of NSArray '%@'", [t1 get:0]);
	LOG(@"Getting out of bonds entry of NSArray '%@'", [t1 get:1]);
	LOG(@"Repeating with NON_NIL_STRING '%@'",
		NON_NIL_STRING([t1 get:1]));
}

- (void)run_nsstring_tests
{
	NSArray *strings = [NSArray arrayWithObjects:@"http://elhaso.com/blah",
		@"http://elhaso.com/subhunt/index.en.html", @"../i/logo.png", nil];

	for (NSString *url in strings) {
		LOG(@"Url '%@'", url);
		LOG(@"\tbase url: %@", [url stringByRemovingFragment]);
		LOG(@"\tis relative? %@", [url isRelativeURL] ? @"Yes" : @"No");
	}
}

- (void)run_tests
{
	LOG(@"Running the test suite...");

	// Testing some macros.
	DLOG(@"This message only seen if you are on your DEBUG build");
	LOG(@"This message seen always, did you see the previous DEBUG one?");
	LOG(@"Now we show a nil '%@' and a non-nil '%@' string.",
		nil, NON_NIL_STRING(nil));

	[self run_nsarray_tests];
	[self run_nsstring_tests];

	[doing stopAnimating];
	LOG(@"Finished all tests!");
	self.label.text = @"Did run all, check the log!";
	is_running = NO;
}

@end
