//
//  AnotherFireAppDelegate.h
//  AnotherFire
//
//  Created by pcwiz on 23/06/09.
//  Copyright leowiz 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnotherFireViewController.h"

@interface AnotherFireAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    AnotherFireViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AnotherFireViewController *viewController;

@end

