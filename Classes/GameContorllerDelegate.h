//
//  GameContorllerDelegate.h
//  AnotherFire
//
//  Created by pcwiz on 23/06/09.
//  Copyright 2009 leowiz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GameLogic.h"

@interface GameContorllerDelegate : UIViewController <UIAlertViewDelegate> {
	GameLogic *gl;

}

@property(nonatomic, retain) GameLogic *gl;

-(id) initWithNames: (NSString *)_name1 second:(NSString *)_name2;
-(id) initWithBoard: (NSArray *)board first: (NSString *)_name1 second:(NSString *)_name2;
-(void) touchOccured: (CGPoint) _where;
- (NSMutableArray *) getBoard;
- (void) announce_win;

@end
