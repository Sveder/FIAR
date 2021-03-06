#import "AnotherFireAppDelegate.h"
#import "AnotherFireViewController.h"

@implementation AnotherFireAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}

- (void) applicationWillTerminate: (UIApplication *)application
{
	[self.viewController saveGame];
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
