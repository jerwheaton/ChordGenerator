//
//  Player.h
//  MusicGenerator
//
//  Created by Jeremy Wheaton on 2016-10-03.
//  Copyright © 2016 Jeremy Wheaton. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdlib.h>
#include <GameKit/GameKit.h>
#import "SoundBankPlayer.h"
#import "SongSettings.h"
#import "Chord.h"
#import "State.h"

#include "common.h"

@interface Player : NSObject {
    NSTimer *_runTimer;
    SoundBankPlayer *_soundBankPlayer;
    SongSettings *_settings;
    GKGaussianDistribution *_randDist;
    
    NSThread *playThread;
    
    State *currentState;
}


#pragma mark init

- (id)init;


#pragma mark Player controls

-(void)playWithProcedure:(uint8_t)procedure;
-(void)stop;


#pragma mark Getter (only for settings)

-(SongSettings *)getSettings;

@end
