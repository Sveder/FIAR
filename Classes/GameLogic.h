#import <UIKit/UIKit.h>

@interface Win : NSObject
{
	@public NSString *winner_name;
	@public int where_x;
	@public int where_y;
	@public int direction;
}

@property(nonatomic, retain)  NSString *winner_name;
@property(nonatomic) int where_x;
@property(nonatomic) int where_y;
@property(nonatomic) int direction;

@end


@interface Side : NSObject <NSCoding, NSCopying>
{
	NSString *side_name;
}

@property(nonatomic, retain) NSString *side_name;

-(id) initWithName: (NSString *) _name;

@end



@interface GameLogic : NSObject <NSCoding>
{
	NSMutableArray *sides;
	NSMutableArray *board;
	
	@public int height;
	@public int width;
	@public int cur_side;
	@public Side *empty_side;
	int board_count;
	
}

@property(nonatomic, retain) NSMutableArray *sides;
@property(nonatomic, retain) NSMutableArray *board;
@property(nonatomic, retain) Side *empty_side;

@property(nonatomic) int height;
@property(nonatomic) int board_count;
@property(nonatomic) int width;
@property(nonatomic) int cur_side;

-(id) initWithGroups: (int)_height width:(int)_width group1:(NSString *)_g1 group2:(NSString *)_g2;
-(int) moveTo:(int)_where;
-(Win*) whoWon;

-(void) startGame;
-(BOOL) isBoardFull;

@end