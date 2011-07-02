//
//  AnotherFireViewController.m
//  AnotherFire
//
//  Created by pcwiz on 23/06/09.
//  Copyright leowiz 2009. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "splashview.h"
#import "AnotherFireViewController.h"

@implementation AnotherFireViewController
@synthesize gv;

@synthesize tbFirstName;
@synthesize tbSecondName;
@synthesize btnPlay;
@synthesize imgNameBG;
@synthesize btnPromo;
@synthesize splash;
@synthesize timer;
@synthesize ingame;
@synthesize unar;
@synthesize btnBG;
@synthesize btnQuit;
@synthesize swtSound;
@synthesize lblSound;
@synthesize sound;
@synthesize btnAbout;
@synthesize btnHelp;

- (void)dealloc {
	[self.unar finishDecoding];
	[self.unar release];
	[self,gv release];
	[self.view release];
    [super dealloc];
}

-(void) play_sound: (NSString *)name
{
	if (self.sound)
	{
		NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:name ofType:@"mp3"];
		NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
	
		AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error:nil];
		[fileURL release];
		[player prepareToPlay];
		[player play];	
	}
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
	self.sound = YES;
	self.unar = nil;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *doc_dir = [paths objectAtIndex:0];
	
	NSString *file_path = [doc_dir stringByAppendingPathComponent: @"save"];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:file_path])
	{
		NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:file_path];
		self.unar = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		self.ingame = [self.unar decodeBoolForKey:@"ingame"];
		self.sound = [self.unar decodeBoolForKey:@"sound"];
		
		[data release];
		
	}
	else
	{
		self.ingame = NO;
	}
	
	
	[self play_sound: @"intro"];
	
	self.view = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 480)];
	
	self.splash = [[splashView alloc] initWithImage:[UIImage imageNamed:@"intro.png"] onFinish:NSSelectorFromString(@"post_promo") paren:self];
	self.splash.touchAllowed = YES;
	self.splash.delay = 4;	
	[self.splash setBounds:CGRectMake(0, 0, 320, 480)];
	[self.view addSubview:self.splash];
	[self.splash startSplash];	
}


-(void) post_promo
{
	if (self.ingame)
	{
		[self initWithNames:[self.unar decodeObjectForKey:@"fp"] second:[self.unar decodeObjectForKey:@"sp"]];
		self.gl = [self.unar decodeObjectForKey:@"save"];
		[self startGame];
	}
	else
	{
		[self show_menu];
	}
}

-(void) about
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.svedersoft.com/fiar_about.html"]];
}

- (void) help
{
	NSString *msg = @"The rules of Four In a Row are simple - connect four of your coins in a row, column or diagonals. Find a friend and start playing it already!";
	UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"How to Play" message:msg delegate:self cancelButtonTitle:@"Back" otherButtonTitles:nil];
	av.tag = 666;
	[av setDelegate:self];
	[av show];
	[av release];
}

-(void) show_menu
{
	[self.splash removeFromSuperview];
	self.imgNameBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"name.png"]];
	[self.imgNameBG setFrame:CGRectMake(0, 0, 320, 480)];
	[self.view addSubview: self.imgNameBG];
	
	self.tbFirstName = [[UITextField alloc] initWithFrame:CGRectMake(150, 80, 120, 30)];
	self.tbFirstName.text = @"Choose";
	self.tbFirstName.delegate = self;
	[self.view addSubview: self.tbFirstName];
	
	self.tbSecondName = [[UITextField alloc] initWithFrame:CGRectMake(150, 195, 120, 30)];
	self.tbSecondName.text = @"name";
	self.tbSecondName.delegate = self;
	[self.view addSubview: self.tbSecondName];
	
	self.btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.btnPlay setTitle:@"" forState:UIControlStateNormal];
	[self.btnPlay setFrame:CGRectMake(115, 292, 98, 32)];
	[self.btnPlay setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
	[self.btnPlay addTarget:self action:@selector(settingsChanged) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview: self.btnPlay];
	
	
	self.btnAbout = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.btnAbout setImage:[UIImage imageNamed:@"about.png"] forState:UIControlStateNormal];
	[self.btnAbout setFrame:CGRectMake(70, 380, 55, 30)];
	[self.btnAbout addTarget:self action:@selector(about) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.btnAbout];
	
	self.btnHelp = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.btnHelp setImage:[UIImage imageNamed:@"help.png"] forState:UIControlStateNormal];
	[self.btnHelp setFrame:CGRectMake(200, 380, 55, 30)];
	[self.btnHelp addTarget:self action:@selector(help) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.btnHelp];
	
	if (self.gl)
	{
		self.tbFirstName.text = ((Side *)[self.gl.sides objectAtIndex:0]).side_name;
		self.tbSecondName.text = ((Side *)[self.gl.sides objectAtIndex:1]).side_name;
	}
	else if (nil != self.unar)
	{
		self.tbFirstName.text = [self.unar decodeObjectForKey:@"fp"];
		self.tbSecondName.text = [self.unar decodeObjectForKey:@"sp"];
	}
	
	self.btnBG = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.btnBG setFrame:self.view.bounds];
	[self.btnBG addTarget:self action:@selector(backgroundClick) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview: self.btnBG];
	[self.view sendSubviewToBack:self.btnBG];
	
	self.swtSound = [[UISwitch alloc] initWithFrame:CGRectMake(170, 440, 100, 30)];
	[self.swtSound setOn:self.sound];
	[self.view addSubview:self.swtSound];
	
	self.lblSound = [[UILabel alloc] initWithFrame:CGRectMake(70, 438, 50, 30)];
	self.lblSound.text = @"Sound";
	self.lblSound.backgroundColor = [UIColor clearColor];
	[self.view addSubview:self.lblSound];
}

-(void) saveGame
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *doc_dir = [paths objectAtIndex:0];
	NSString *file_path = [doc_dir stringByAppendingPathComponent: @"save"];
	
	NSMutableData *data = [[NSMutableData alloc] init];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	
	[archiver encodeObject:self.gl forKey:@"save"];
	[archiver encodeBool:self.ingame forKey:@"ingame"];
	[archiver encodeObject:self.tbFirstName.text forKey:@"fp"];
	[archiver encodeObject:self.tbSecondName.text forKey:@"sp"];
	[archiver encodeBool:self.sound forKey:@"sound"];
	
	[archiver finishEncoding];
	[data writeToFile:file_path atomically:YES];
	[archiver release];
	[data release];	
}



- (BOOL) textFieldShouldReturn:(UITextField *) sender
{
	[sender resignFirstResponder];
	return YES;
}

- (void) backgroundClick
{
	[self.tbFirstName resignFirstResponder];
	[self.tbSecondName resignFirstResponder];
}


- (void) touchOccured: (CGPoint) _where;
{
	printf("A touch occured at: %f, %f.\n", _where.x, _where.y);
	
	int where;
	int columns[8] = {55, 91, 128, 165, 201, 237, 276, 500};
	for (int i = 0; i < 8 ; ++i)
	{
		if (_where.x < columns[i])
		{
			where = i;
			break;
		}
	}
	
	int height = [self.gl moveTo:where];
	
	if (-1 != height)
	{
		[self.gv animateMove:where col:height];
	}
	else
	{
		[self play_sound: @"error"];
				
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Bad move!" message:@"You can't put a coin in a full row." delegate:nil cancelButtonTitle:@"Understood!" otherButtonTitles:nil];
		[av show];
		[av release];
	}
	
	Win *winner_info = [gl whoWon];
	
	if (! [winner_info.winner_name isEqual:@""])
	{
		[self play_sound: @"win"];
		[self.gv emphasize_winner: winner_info];
	}
	
	if ([gl isBoardFull])
	{
		[self play_sound: @"error"];
				
		NSString *msg = @"It's a tie. You both lost.";
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Tie" message:msg delegate:self cancelButtonTitle:@"New Game" otherButtonTitles:nil];
		[av setDelegate:self];
		[av show];
		[av release];
	}
	
}

- (void) announce_win
{
	Win *winner_info = [gl whoWon];
	
	NSString *msg = [winner_info.winner_name  stringByAppendingString: @" won. Laugh at the other player."];
	UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"We have a winner!" message:msg delegate:self cancelButtonTitle:@"New Game" otherButtonTitles:nil];
	[av setDelegate:self];
	[av show];
	[av release];
	
	self.gv.win_info = nil;
}

-(void) settingsChanged
{
	[super initWithNames:self.tbFirstName.text second:self.tbSecondName.text];

	[self.btnPlay removeFromSuperview];
	[self.tbFirstName removeFromSuperview];
	[self.tbSecondName removeFromSuperview];
	[self.btnBG removeFromSuperview];
	[self.lblSound removeFromSuperview];
	[self.swtSound removeFromSuperview];
	[self.btnAbout removeFromSuperview];
	[self.btnHelp removeFromSuperview];
	self.sound = [self.swtSound isOn];
	
	[self startGame];
}

//Actually start the game with that number of players:
-(void) startGame
{
	printf("Starting the game.\n");
	self.gv = [[GameView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	[self.gv setNeedsDisplay];
	[self.gv newParent: self];
	
	if (self.ingame)
	{
		[self.gv continue_game];
	}
	
	self.ingame = YES;
	[self.view addSubview: self.gv];
	
	self.btnQuit = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.btnQuit setTitle: @"" forState:UIControlStateNormal];
	[self.btnQuit setImage:[UIImage imageNamed:@"exit_icon.png"] forState:UIControlStateNormal];
	[self.btnQuit setFrame:CGRectMake(240, 45, 70, 35)];
	[self.btnQuit addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview: self.btnQuit];
	
}


-(void) alertView: (UIAlertView *)_alert_view clickedButtonAtIndex:(NSInteger)_button
{
	if (666 == _alert_view.tag)
	{
		return;
	}
	
	printf("A new game is beggining.");
	[self.gl startGame];
	[self.gv removeFromSuperview];
	[self.gv dealloc];
	[self startGame];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void) quit
{
	self.ingame = NO;
	[self.gv removeFromSuperview];
	[self show_menu];
}

@end
