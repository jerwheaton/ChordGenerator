//
//  TimeSignature.m
//  MusicGenerator
//
//  Created by Jeremy Wheaton on 2016-10-03.
//  Copyright © 2016 Jeremy Wheaton. All rights reserved.
//

#import "SongSettings.h"

@implementation SongSettings


# pragma mark Init

-(id)initWithSeed:(NSString *)seed andProcedure:(uint8_t)procedure {
    self->_procedure = procedure;
    self->_seed = seed;
    self->_source = [[GKARC4RandomSource alloc] initWithSeed:[self->_seed dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Must be before beats per measure
    self->_noteSingleBeat = [self getRandomSingleBeat];
    
    // Must be after single beat
    self->_beatsPerMeasure = [self getRandomBeatsPerMeasure];
    
    self->_beatsPerMinute = [self getRandomBeatsPerMinute];
    
    self->_measuresPerProgression = 0;
    
    self->_key = [self getRandomKey];
    [self setScale];
    
    self->_beatsPerMeasurePossibilities = @[@6, @3, @2, @4, @9, @12];
    
    return self;
}


# pragma mark Getters

-(uint8_t)getNoteSingleBeat {
    return self->_noteSingleBeat;
}

-(uint8_t)getBeatsPerMeasure {
    return self->_beatsPerMeasure;
}

-(uint8_t)getBeatsPerProgression {
    return self->_beatsPerMeasure * (self->_measuresPerProgression + 1);
}

-(uint16_t)getBeatsPerMinute {
    return self->_beatsPerMinute;
}

-(uint8_t)getKey {
    return self->_key;
}

-(NSArray *)getScale {
    return self->_scale;
}

-(uint8_t)getProcedure {
    return self->_procedure;
}

-(void)setProcedure:(uint8_t)newProcedure {
    self->_procedure = newProcedure;
}

-(GKARC4RandomSource *)getSource {
    return self->_source;
}

// TODO: Fix these to use seed.
-(uint8_t)randomEightBitWithLower:(uint8_t)lower andUpper:(uint8_t)upper {
    return lower + (arc4random() % (upper - lower + 1));
}

-(uint32_t)randomNormalDistributedWithLower:(uint32_t)lower andUpper:(uint32_t)upper {
    // Box-Muller Transform:
    double u1 = ark4randomdouble();
    double u2 = ark4randomdouble();
    double f1 = sqrt(-2 * log(u1));
    double f2 = 2 * M_PI * u2;
    double g1 = f1 * cos(f2); // gaussian distribution
    
    g1 = (g1 + 3) / 6;
    if (g1 < 0) {
        g1 = 0.0;
    }
    if (g1 > 1.0) {
        g1 = 1.0;
    }
    
    return floor(g1 * (upper - lower)) + lower;
}

-(uint8_t)getRandomSingleBeat {
    if (self->_procedure == 0) {
        return 1 << [self randomEightBitWithLower:0 andUpper:4];
    } else if (self->_procedure <= 3) {
        return 2 << [self randomEightBitWithLower:0 andUpper:2];
    } else {
        return 2 << [self randomEightBitWithLower:0 andUpper:1];
    }
}

-(uint8_t)getRandomBeatsPerMeasure {
    if (!self->_noteSingleBeat) {
        [NSException raise:@"No single beat value" format:@"Must have single beat value before generating beats per measure"];
    }
    
    if (self->_procedure == 0) {
        return [self randomEightBitWithLower:1 andUpper:12];
    } else {
        uint8_t val = [self randomEightBitWithLower:0 andUpper:2];
        if (self->_noteSingleBeat == 2) {
            return 2;
        } else if (self->_noteSingleBeat == 4) {
            // Exclude 3/4 for the more common 4/4
            if (self->_procedure == 4 && val == 1) {
                val++;
            }
            return 2 + val;
        } else {
            if (self->_procedure < 2) {
                return 6 + (3 * val);
            } else {
                return 4;
            }
        }
    }
}

-(uint8_t)getRandomBeatsPerMinute {
    if (self->_procedure == 0) {
        return [self randomEightBitWithLower:25 andUpper:200];
    } else {
        return (uint8_t)[self randomNormalDistributedWithLower:BPM_MIN andUpper:BPM_MAX];
    }
}

-(uint8_t)getRandomKey {
    return [self randomEightBitWithLower:24 andUpper:35];
}

-(void)setScale {
    uint8_t scale = [self randomEightBitWithLower:0 andUpper:1];
    NSArray *notes = [NSArray alloc];
    //NSArray *chords = [NSArray alloc];
    
    // TODO: Add more scales
    if (scale == 0) {
        // Major ( W  W  H  W  W  W  H )
        self->_scale = [notes initWithObjects:@0, @2, @4, @5, @7, @9, @11, nil];
        
        NSMutableArray *tmp = [[NSMutableArray alloc] initWithObjects:
                               @[@0, @5, @3, @4],
                               @[@0, @5, @1, @4],
                               @[@0, @4, @5, @3],
                               @[@0, @3, @5, @4],
                               @[@0, @2, @3, @4],
                               @[@0, @3, @0, @4],
                               @[@0, @3, @1, @4], nil];
        if (self->_procedure < 4) {
            [tmp addObject:@[@0, @3, @4]];
            [tmp addObject:@[@1, @4, @0]];
        }
        self->_progressions = [tmp copy];
        self->major = true;
    } else {
        // Natural Minor ( W  H  W  W  H  W  W )
        self->_scale = [notes initWithObjects:@0, @2, @3, @5, @7, @8, @10, nil];
        NSMutableArray *tmp = [[NSMutableArray alloc] initWithObjects:
                               @[@0, @5, @2, @6],
                               @[@0, @3, @4, @0],
                               @[@5, @6, @0, @0],
                               @[@0, @6, @5, @6], nil];
        if (self->_procedure < 4) {
            [tmp addObject:@[@0, @5, @6]];
            [tmp addObject:@[@0, @3, @6]];
            [tmp addObject:@[@0, @3, @4]];
            [tmp addObject:@[@1, @4, @0]];
            [tmp addObject:@[@0, @3, @0]];
        }

        self->_progressions = [tmp copy];
        self->major = false;
    }
}

-(NSArray *)getRandomProgression {
    return [self->_progressions objectAtIndex:[self randomEightBitWithLower:0 andUpper:[self->_progressions count]-1]];
}

-(bool)getIsMajor {
    return self->major;
}

@end
