#import "GameLogic.h"

@implementation Win

@synthesize winner_name;
@synthesize where_x;
@synthesize where_y;
@synthesize direction;

@end


@implementation Side
@synthesize side_name;

-(id) initWithName: (NSString *) _name {
	[super init];
	printf("Initialized a side with name:%s\n", _name);
	self.side_name = _name;
	return self;
}

- (void)dealloc {
    [self.side_name release];
    [super dealloc];
}

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder * )encoder
{
	[encoder encodeObject:self.side_name forKey:@"side"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if (self = [super init])
	{
		self.side_name = [decoder decodeObjectForKey:@"side"];
	}
	return self;
}
#pragma mark -

- (id) copyWithZone:(NSZone *) z
{
	Side *s = [[[self class] allocWithZone:z] init];
	s.side_name = [self.side_name copy];
	return s;
}

@end


@implementation GameLogic

@synthesize sides;
@synthesize board;
@synthesize height;
@synthesize width;
@synthesize cur_side;
@synthesize empty_side;
@synthesize board_count;

-(void)dealloc
{
	[sides release];
	[board release];
	[empty_side release];
	[super dealloc];
}

//Initialize the class with the board height and width, and the names of the players:
-(id) initWithGroups: (int)_height width:(int)_width group1:(NSString *)_g1 group2:(NSString *)_g2
{
	[super init];
	printf("Initialized a board with size: %d, %d.\n", _width, _height);

	self.height = _height;
	self.width = _width;
	
	self.empty_side = [[Side alloc] initWithName:@""];
	
	self.sides = [[NSMutableArray alloc] init];
	Side *first = [[Side alloc] initWithName: _g1 ];
	[self.sides addObject: first];
	
	Side *second = [[Side alloc] initWithName: _g2 ];
	[self.sides addObject: second];
	[self startGame];


	return self;
}

-(void) startGame;
{
	self.board_count = 0;
	self.cur_side = 0;
	self.board = [[NSMutableArray alloc] init];
	
	//Initialize the array with empty sides for each side:
	for (int i = 0; i < self.height; ++i)
	{
		NSMutableArray *a = [[NSMutableArray alloc] init];
		for (int j = 0; j < self.width; ++j)
		{
			[a insertObject: self.empty_side atIndex: 0];
		}
		[self.board addObject: a];
	}
}

//Perform the move for the current player at the given row. Returns the height of the
//move performed or -1 if no move is possibale on that row :
-(int) moveTo:(NSInteger)_where
{
	printf("A move to %d performed by side %d.\n", _where, self.cur_side);
	//Find the lowest place in the row which isn't notified:
	for (int i = 0; i < self.height; ++i)
	{
		NSMutableArray *cur_row = [self.board objectAtIndex: i];
		Side *s = [cur_row objectAtIndex: _where];
		if (self.empty_side == s)
		{
			[cur_row replaceObjectAtIndex: _where withObject: [self.sides objectAtIndex: self.cur_side]];
			self.cur_side = 1 - self.cur_side;
			self.board_count += 1;
			return i;
		}
	}

	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:self.board forKey:@"board"];
	[prefs synchronize];
	
	
	//The whole row is apparently full:
	return -1;
}

//Check if someone won (quite stupidly). Return his name or the empty string:
-(Win*) whoWon
{
	printf("Asking who won.\n");
	Side *winner = self.empty_side;

	Win *win = [[Win alloc] init];
	win.direction = 0;
	
	for (int i = 0; i < self.height; ++i)
	{
		NSMutableArray *cur_row = [self.board objectAtIndex: i];
		
		for (int j = 0; j < self.width; ++j) {
			Side *s = [cur_row objectAtIndex: j];
			
			if (self.empty_side != s)
			{
				@try
				{
					if ( s == [cur_row objectAtIndex:j+1] &&
						 s == [cur_row objectAtIndex:j+2] &&
						 s == [cur_row objectAtIndex:j+3])
					{
						win.where_x = i;
						win.where_y = j;
						win.direction = 1;
						winner = s;
					}
				} @catch (NSException *moo) {}				
				
				@try
				{
					if ( s == [[self.board objectAtIndex:i+1] objectAtIndex:j] &&
						 s == [[self.board objectAtIndex:i+2] objectAtIndex:j] &&
						 s == [[self.board objectAtIndex:i+3] objectAtIndex:j])
					{
						win.where_x = i;
						win.where_y = j;
						win.direction = 2;
						winner = s;						
					}
				} @catch (NSException *moo) {}
				
				@try
				{
					if ( s == [[self.board objectAtIndex:i+1] objectAtIndex:j+1] &&
						 s == [[self.board objectAtIndex:i+2] objectAtIndex:j+2] &&
						 s == [[self.board objectAtIndex:i+3] objectAtIndex:j+3])
					{
						win.where_x = i;
						win.where_y = j;
						win.direction = 3;
						winner = s;						
					}
				} @catch (NSException *moo) {}
				
				@try
				{
					if ( s == [[self.board objectAtIndex:i+1] objectAtIndex:j-1] &&
						 s == [[self.board objectAtIndex:i+2] objectAtIndex:j-2] &&
						 s == [[self.board objectAtIndex:i+3] objectAtIndex:j-3])
					{
						win.where_x = i;
						win.where_y = j;
						win.direction = 4;
						winner = s;
					}
				} @catch (NSException *moo) {}
			}
		}
	}
	
	win.winner_name = winner.side_name;
	printf("Winner is: %s\n", winner.side_name);
	
	return win;
}

-(BOOL) isBoardFull
{
	if (self.height * self.width == self.board_count)
	{
		return TRUE;
	}
	return FALSE;
}

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder * )encoder
{
	[encoder encodeObject:self.sides forKey:@"sides"];
	
	for (int i = 0; i < self.height; ++i)
	{
		NSMutableArray *a = [self.board objectAtIndex:i];
		for (int j = 0; j < self.width; ++j)
		{
			Side *s = [a objectAtIndex:j];
			[encoder encodeObject:s forKey:[NSString stringWithFormat:@"%d%d" , i, j]];
		}
	}
	[encoder encodeInt:self.height forKey:@"height"];
	[encoder encodeInt:self.width forKey:@"width"];
	[encoder encodeInt:self.cur_side forKey:@"cur_side"];
	[encoder encodeObject:self.empty_side forKey:@"empty_side"];
	[encoder encodeInt:self.board_count forKey:@"count"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	@try {
		if (self = [super init])
		{
			self.sides = [decoder decodeObjectForKey:@"sides"];
			
			self.board = [[NSMutableArray alloc] init];
			self.width = [decoder decodeIntForKey:@"width"];
			self.height = [decoder decodeIntForKey:@"height"];
			self.cur_side = [decoder decodeIntForKey:@"cur_side"];
			self.empty_side = [decoder decodeObjectForKey:@"empty_side"];
			self.board_count = [decoder decodeIntForKey:@"count"];
			
			//Initialize the array with empty sides for each side:
			for (int i = 0; i < self.height; ++i)
			{
				NSMutableArray *a = [[NSMutableArray alloc] init];
				for (int j = 0; j < self.width; ++j)
				{
					[a insertObject: self.empty_side atIndex: 0];
				}
				[self.board addObject: a];
			}
			
			for (int i = 0; i < self.height; ++i)
			{
				for (int j = 0; j < self.width; ++j)
				{
					Side *s = [decoder decodeObjectForKey:[NSString stringWithFormat:@"%d%d" , i, j]];
					[[self.board objectAtIndex:i] replaceObjectAtIndex:j withObject:s];
				}
			}
		}
	}
	@catch (NSException * e) {
		[e retain];
	}

	return self;
}
#pragma mark -


@end
