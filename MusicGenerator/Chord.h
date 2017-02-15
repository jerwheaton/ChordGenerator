//
//  Chord.h
//  MusicGenerator
//
//  Created by Jeremy Wheaton on 2016-10-04.
//  Copyright © 2016 Jeremy Wheaton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Chord : NSObject {
    NSMutableArray *notes;
    double gain;
    double duration;
    uint8_t octave;
}

#pragma mark init

-(id)initWithGain:(double)newGain andDuration:(double)newDuration andOctave:(uint8_t)newOctave;


#pragma mark Getters

-(NSMutableArray *)getNotes;

-(double)getDuration;
-(uint8_t)getOctave;
-(double)getGain;


#pragma mark Setters

-(void)setDuration:(double)newDuration;
-(void)setOctave:(uint8_t)newOctave;


#pragma mark Util funcs
-(void)addNote:(uint8_t)note;

@end
