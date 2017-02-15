//
//  TimeSignature.h
//  MusicGenerator
//
//  Created by Jeremy Wheaton on 2016-10-03.
//  Copyright © 2016 Jeremy Wheaton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#include "common.h"

@interface SongSettings : NSObject {
    NSString *_seed;
    GKARC4RandomSource *_source;
    
    uint8_t _noteSingleBeat;
    uint8_t _beatsPerMeasure;
    uint16_t _beatsPerMinute;
    
    uint8_t _measuresPerProgression;
    
    uint8_t _key;
    NSArray *_scale;
    NSArray *_progressions;
    
    uint8_t _procedure;
    
    NSArray *_beatsPerMeasurePossibilities;
    
    bool major;
}


#pragma mark init

-(id)initWithSeed:(NSString *)seed andProcedure:(uint8_t)procedure;


#pragma mark Getters

-(uint8_t)getNoteSingleBeat;
-(uint8_t)getBeatsPerMeasure;
-(uint8_t)getBeatsPerProgression;
-(uint16_t)getBeatsPerMinute;

-(uint8_t)getKey;
-(NSArray *)getScale;
-(bool)getIsMajor;

-(uint8_t)getProcedure;

-(NSArray *)getRandomProgression;


#pragma mark Setters

-(void)setProcedure:(uint8_t)newProcedure;


#pragma mark Random number function variations

-(uint8_t)randomEightBitWithLower:(uint8_t)lower andUpper:(uint8_t)upper;
-(uint32_t)randomNormalDistributedWithLower:(uint32_t)lower andUpper:(uint32_t)upper;


@end
