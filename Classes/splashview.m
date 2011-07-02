//
//  splashView.m
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

#import "splashView.h"

@implementation splashView
@synthesize image;
@synthesize delay;
@synthesize touchAllowed;
@synthesize animation;
@synthesize isFinishing;
@synthesize animationDelay;
@synthesize del;
@synthesize parent;

- (id)initWithImage:(UIImage *)screenImage onFinish: (SEL)_del paren: (NSObject *)_parent
{
	if (self = [super initWithFrame:CGRectMake(0,0,320,480)]) {
		self.image = screenImage;
		self.delay = 2;
		self.touchAllowed = NO;
		self.animation = SplashViewAnimationNone;
		self.animationDelay = 1;
		self.isFinishing = NO;
		self.del = _del;
		self.parent = _parent;
	}
	return self;
}

- (void)startSplash {

	splashImage = [[UIImageView alloc] initWithImage:self.image];
	[self addSubview:splashImage];
	[self performSelector:@selector(dismissSplash) withObject:self afterDelay:self.delay];
}

- (void)dismissSplash {
	if (self.isFinishing)
	{
		[self dismissSplashFinish];
		return;
	}
	
	if (self.animation == SplashViewAnimationNone) {
		[self dismissSplashFinish];
	} else if (self.animation == SplashViewAnimationSlideLeft) {
		CABasicAnimation *animSplash = [CABasicAnimation animationWithKeyPath:@"transform"];
		animSplash.duration = self.animationDelay;
		animSplash.removedOnCompletion = NO;
		animSplash.fillMode = kCAFillModeForwards;
		animSplash.toValue = [NSValue valueWithCATransform3D:
							  CATransform3DMakeAffineTransform
							  (CGAffineTransformMakeTranslation(-320, 0))];
		animSplash.delegate = self;
		[self.layer addAnimation:animSplash forKey:@"animateTransform"];
	} else if (self.animation == SplashViewAnimationFade) {
		CABasicAnimation *animSplash = [CABasicAnimation animationWithKeyPath:@"opacity"];
		animSplash.duration = self.animationDelay;
		animSplash.removedOnCompletion = NO;
		animSplash.fillMode = kCAFillModeForwards;
		animSplash.toValue = [NSNumber numberWithFloat:0];
		animSplash.delegate = self;
		[self.layer addAnimation:animSplash forKey:@"animateOpacity"];
	}
	self.isFinishing = YES;
	[self.parent performSelector:del];

}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {

	[self dismissSplashFinish];
}

- (void)dismissSplashFinish {

	if (splashImage) {
		[splashImage removeFromSuperview];
		[self removeFromSuperview];
		[image release];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

	if (self.touchAllowed) {
		[self dismissSplash];
	}
}

- (void)dealloc {
    [super dealloc];
}


@end
