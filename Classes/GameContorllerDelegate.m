#import "GameContorllerDelegate.h"
#import "GameLogic.h"

@implementation GameContorllerDelegate
@synthesize gl;

-(void) dealloc
{
	[self.gl release];
	[super dealloc];
}

-(id) initWithNames: (NSString *)_name1 second:(NSString *)_name2
{
	self.gl = [[GameLogic alloc] initWithGroups: 10 width: 8 group1: _name1 group2: _name2];
	return self;
}

-(id) initWithBoard: (NSArray *)_board first:(NSString *)_name1 second: (NSString *)_name2
{
	[self initWithNames:_name1 second:_name2];
	self.gl.board = _board;
	return self;
}

- (NSMutableArray *) getBoard
{
	return self.gl.board;
}

@end
