//
//  splashView.h
//  version 1.0
//
//  Created by Shannon Appelcline on 3/13/09.
//  Copyright 2009 Skotos Tech Inc.
//
//  Licensed Under Creative Commons Attribution 3.0:
//  http://creativecommons.org/licenses/by/3.0/
//  You may freely use this class, provided that you maintain these attribute comments
//
//  Visit our iPhone blog: http://iphoneinaction.manning.com
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
	SplashViewAnimationNone,
	SplashViewAnimationSlideLeft,
	SplashViewAnimationFade,
} SplashViewAnimation;
	
@interface splashView : UIView {

	UIImageView *splashImage;
	
	UIImage *image;
	NSTimeInterval delay;
	BOOL touchAllowed;
	SplashViewAnimation animation;
	NSTimeInterval animationDelay;
	
	BOOL isFinishing;
	SEL del;
	NSObject *parent;
	
}

@property (retain) UIImage *image;
@property NSTimeInterval delay;
@property BOOL touchAllowed;
@property SplashViewAnimation animation;
@property NSTimeInterval animationDelay;
@property BOOL isFinishing;
@property SEL del;
@property (retain) NSObject *parent;

- (id)initWithImage:(UIImage *)screenImage onFinish: (SEL)_del paren: (NSObject *)_parent;
- (void)startSplash;
- (void)dismissSplash;
- (void)dismissSplashFinish;

@end
