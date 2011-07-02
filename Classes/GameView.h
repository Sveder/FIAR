#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "GameLogic.h"
#import "GameContorllerDelegate.h"

@interface GameView : UIView {
	GameContorllerDelegate *parent;
	NSMutableArray *locations;
	CALayer *cur_coin;
	Win *win_info;
}

@property(nonatomic, retain) GameContorllerDelegate *parent;
@property(nonatomic, retain) NSMutableArray *locations;
@property(nonatomic, retain) CALayer *cur_coin;
@property(nonatomic, retain) Win *win_info;

- (void) newParent: (GameContorllerDelegate *)_parent;
- (void) animateMove: (int) _row col:(int) _col;
- (void) emphasize_winner: (Win *)winner_info;
- (void) continue_game;

@end