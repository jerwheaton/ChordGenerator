//
//  Chord.m
//  MusicGenerator
//
//  Created by Jeremy Wheaton on 2016-10-04.
//  Copyright © 2016 Jeremy Wheaton. All rights reserved.
//

#import "Chord.h"

@implementation Chord

-(id)initWithGain:(double)newGain andDuration:(double)newDuration andOctave:(uint8_t)newOctave {
    self->notes = [[NSMutableArray alloc] init];
    self->gain = newGain;
    self->duration = newDuration;
    self->octave = newOctave;
    
    return self;
}

-(void)addNote:(uint8_t)note {
    [self->notes addObject:[NSNumber numberWithInt:(int)note]];
}

-(NSMutableArray *)getNotes {
    return self->notes;
}

-(double)getDuration {
    return self->duration;
}

-(uint8_t)getOctave {
    return self->octave;
}

-(double)getGain {
    return self->gain;
}

-(void)setDuration:(double)newDuration {
    self->duration = newDuration;
}

-(void)setOctave:(uint8_t)newOctave {
    self->octave = newOctave;
}

@end
