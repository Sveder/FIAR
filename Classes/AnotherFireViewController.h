//
//  AnotherFireViewController.h
//  AnotherFire
//
//  Created by pcwiz on 23/06/09.
//  Copyright leowiz 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "splashview.h"
#import "GameLogic.h"
#import "GameView.h"

@interface AnotherFireViewController : GameContorllerDelegate <UITextFieldDelegate>
{
	GameView *gv;
	
	IBOutlet UIButton *btnPlay;
	IBOutlet UITextField *tbFirstName;
	IBOutlet UITextField *tbSecondName;
	IBOutlet UIImageView *imgNameBG;
	IBOutlet UIButton *btnPromo;
	UIButton *btnBG;
	UISwitch *swtSound;
	UIButton *btnQuit;
	UILabel *lblSound;
	UIButton *btnAbout;
	UIButton *btnHelp;
	
	splashView *splash;
	NSTimer *timer;
	BOOL ingame;
	NSKeyedUnarchiver *unar;
	BOOL sound;
}

@property(nonatomic) BOOL sound;
@property(nonatomic, retain) UILabel *lblSound;
@property(nonatomic, retain) UIButton *btnQuit;
@property(nonatomic, retain) UIButton *btnBG;
@property(nonatomic, retain) NSKeyedUnarchiver *unar;
@property(nonatomic) BOOL ingame;
@property(nonatomic, retain) GameView *gv;
@property(nonatomic, retain) NSTimer *timer;
@property(nonatomic, retain) splashView *splash;
@property(nonatomic, retain) IBOutlet UIButton *btnPlay;
@property(nonatomic, retain) IBOutlet UIButton *btnPromo;
@property(nonatomic, retain) IBOutlet UITextField *tbFirstName;
@property(nonatomic, retain) IBOutlet UITextField *tbSecondName;
@property(nonatomic, retain) IBOutlet UIImageView *imgNameBG;
@property(nonatomic, retain) UISwitch *swtSound;
@property(nonatomic, retain) UIButton *btnHelp;
@property(nonatomic, retain) UIButton *btnAbout;

-(void) saveGame;
-(void) startGame;
- (void) backgroundClick;
- (void) post_promo;
-(void) show_menu;
-(void) quit;
-(void) play_sound: (NSString *)name;
- (void) about;

@end

