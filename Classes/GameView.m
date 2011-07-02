//
//  GameView.m
//  AnotherFire
//
//  Created by pcwiz on 23/06/09.
//  Copyright 2009 leowiz. All rights reserved.
//

#import "GameView.h"
#import <AVFoundation/AVFoundation.h>

@implementation GameView
@synthesize parent;
@synthesize locations;
@synthesize cur_coin;
@synthesize win_info;

- (id)initWithFrame:(CGRect)frame {
	printf("Game view initialized.\n");
    if (self = [super initWithFrame:frame]) {
		self.locations = [[NSMutableArray alloc] init];
    }
	self.win_info = nil;
    return self;
}

- (void) newParent: (GameContorllerDelegate *)_parent
{
	printf("Setting parent...");
	self.parent = _parent;
	printf("Parent set.\n");
}

- (void) continue_game
{
	int columns[8] = {17, 55, 91, 128, 165, 201, 237, 276};
	int row_height = (self.bounds.size.height - 200) / self.parent.gl.height;
	
	CGImageRef firstCoin = [UIImage imageNamed:@"first_coin.png"].CGImage;
	CGImageRef secondCoin = [UIImage imageNamed:@"second_coin.png"].CGImage;
	
	for (int i = 0; i < self.parent.gl.height; ++i)
	{
		NSMutableArray *cur_row = [self.parent.gl.board objectAtIndex: i];
		
		for (int j = 0; j < self.parent.gl.width; ++j) 
		{
			Side *s = [cur_row objectAtIndex: j];
			
			if (self.parent.gl.empty_side != s)
			{
				CGRect r = CGRectMake(columns[j], 15 + row_height * i, 28, 28);
				[self.locations addObject: NSStringFromCGRect(r)];
			
				CALayer *cl = [CALayer layer];
			
				if (0 == [self.parent.gl.sides indexOfObject:s])
				{
					cl.contents = (id)firstCoin;
				}
				else
				{
					cl.contents = (id)secondCoin;
				}
				cl.frame = CGRectMake(r.origin.x, 438 - (row_height * i), 28, 28);
				[self.layer addSublayer:cl];
			
			}
		}
	}
}

- (void) emphasize_winner: (Win *)winner_info
{
	[self.parent announce_win];
	int columns[8] = {17, 55, 91, 128, 165, 201, 237, 276};
	int row_height = (self.bounds.size.height - 200) / self.parent.gl.height;
	
	int start_x = columns[winner_info.where_y] - 5;
	int start_y = row_height * (winner_info.where_x + 1);
	
	int width = 0;
	int height = 0;
	
	self.win_info = winner_info;
	
	CALayer *cl = [CALayer layer];
	UIImage *strike = nil;
	
	if (1 == winner_info.direction)
	{
		start_y = 470 - start_y;
		strike = [UIImage imageNamed:@"horiz_line.png"];
		
		width = columns[winner_info.where_y + 4] - columns[winner_info.where_y];
		if (4 == winner_info.where_y)
		{
			width = 150;
		}
		height = 20;
	}
	
	if (2 == winner_info.direction)
	{
		strike = [UIImage imageNamed:@"verti_line.png"];
		
		start_x += 9;
		start_y = 470 - 120 - (row_height * winner_info.where_x);
		
		width = 20;
		//height = row_height * (self.win_info.where_x + 5) - 7;
		height = 120;
	}
	
	if (3 == winner_info.direction)
	{
		strike = [UIImage imageNamed:@"right_line.png"];
		
		start_x += 0;
		start_y = 470 - 120 - (row_height * winner_info.where_x);
		
		width = 150;
		height = 120;
	}
	
	if (4 == winner_info.direction)
	{
		strike = [UIImage imageNamed:@"left_line.png"];
	
		start_x -= 111;
		start_y = 470 - 120 - (row_height * winner_info.where_x);
		
		width = 150;
		height = 120;
	}
	
	cl.frame = CGRectMake(start_x, start_y, width, height);
	cl.contents = (id)(strike.CGImage);
	[self.layer addSublayer: cl];
	
	[self setNeedsDisplay];
}

- (void) touchesEnded:(NSSet *) touches withEvent: (UIEvent *) event
{
	printf("A touch ended!\n");
	UITouch *t = [touches anyObject];
	CGPoint point = [t locationInView: self];
	[self.parent touchOccured: point];
}

- (void) animateMove: (int) _row col:(int) _col;
{
	printf("Animating move.\n");
	int columns[8] = {17, 55, 91, 128, 165, 201, 237, 276};
	int row_height = (self.bounds.size.height - 200) / self.parent.gl.height;
	
	CGRect r = CGRectMake(columns[_row], 15 + row_height * _col, 28, 28);
	[self.locations addObject: NSStringFromCGRect(r)];
	
	CALayer *cl = [CALayer layer];
	
	CGImageRef firstCoin = [UIImage imageNamed:@"first_coin.png"].CGImage;
	CGImageRef secondCoin = [UIImage imageNamed:@"second_coin.png"].CGImage;
	if (1 == self.parent.gl.cur_side)
	{
		cl.contents = (id)firstCoin;
	}
	else if (0 == self.parent.gl.cur_side)
	{
		cl.contents = (id)secondCoin;
	}
	
	[self.layer addSublayer:cl];
	
	cl.frame = CGRectMake(r.origin.x, 438 - (row_height * _col), 28, 28);
	cl.zPosition = -100;
	[self setNeedsDisplay];
	//Moving down animation:
	CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
	anim.duration =  0.7;
	anim.autoreverses = NO;
	anim.removedOnCompletion = YES;

	anim.fromValue = [NSNumber numberWithInt: -80 - row_height * (8 - _col)];
	anim.toValue = [NSNumber numberWithInt: 0];
	
	//Rotation Animation:
	CABasicAnimation *rota = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
	rota.duration = 0.7;
	rota.autoreverses = NO;
	rota.removedOnCompletion = NO;
	rota.fromValue = [NSNumber numberWithFloat: 0];
	rota.toValue = [NSNumber numberWithFloat: (random() % 10) + (random() % 100) / 100];
	rota.fillMode = kCAFillModeForwards;
	[cl addAnimation: rota forKey: @"rotation"];
	
	[cl addAnimation: anim forKey: @"animateFalling"];
	
	
	self.cur_coin = cl;
}


- (void)drawRect:(CGRect)rect {
	printf("Drawing the rect.");
	[super drawRect:rect];
	GameLogic *gl = [self.parent gl];
	
	CGContextRef gc = UIGraphicsGetCurrentContext();	
	
	CGContextTranslateCTM(gc, 0, rect.size.height);
	CGContextScaleCTM(gc, 1.0, -1.0);
	
	CGImageRef boardImg = [UIImage imageNamed:@"right_board.png"].CGImage;
	CGContextDrawImage(gc, self.frame, boardImg);
	
	//CGImageRef quitImg = [UIImage imageNamed:@"quit.png"].CGImage;
	//CGContextDrawImage(gc, CGRectMake(230, 400, 70, 50), quitImg);
	
	CGImageRef firstCoin = [UIImage imageNamed:@"first_coin.png"].CGImage;
	CGImageRef secondCoin = [UIImage imageNamed:@"second_coin.png"].CGImage;
	
	CGContextSetRGBFillColor(gc, 1, 0.75, 0.75, 1);
	
	//Draw current player:
	if (1 == gl.cur_side)
	{
		CGContextDrawImage(gc, CGRectMake(55, 403, 30, 30), secondCoin);
	}
	else if (0 == gl.cur_side)
	{
		CGContextDrawImage(gc, CGRectMake(55, 403, 30, 30), firstCoin);
	}
	

	NSString *cur_player = @"";
	cur_player = [cur_player stringByAppendingString: [[gl.sides objectAtIndex: gl.cur_side] side_name]];
    char text[101];
	[cur_player getCString:text maxLength:100 encoding:NSUTF8StringEncoding];
	
	CGContextSelectFont(gc, "Helvetica", 17, kCGEncodingMacRoman);
	CGContextSetTextDrawingMode(gc, kCGTextFill);
	CGContextSetRGBFillColor(gc, 1, 1, 1, 1);
	CGContextShowTextAtPoint(gc, 95, 412, text, strlen(text));
}




- (void)dealloc {
	[self.parent release];
    [super dealloc];
}


@end
