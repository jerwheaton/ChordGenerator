//
//  State.m
//  MusicGenerator
//
//  Created by Jeremy Wheaton on 2016-10-06.
//  Copyright © 2016 Jeremy Wheaton. All rights reserved.
//

#import "State.h"

@implementation State

-(id)init {
    chords = [[NSMutableArray alloc] init];
    return self;
}

-(void)addChord:(Chord *)chord {
    [self->chords addObject:chord];
}

-(NSMutableArray *)getChords {
    return self->chords;
}

-(NSMutableArray *)getProgression {
    return self->progression;
}

-(void)setProgressionIfEmptyWith:(NSArray *)newProgression {
    if (!self->progression || [self->progression count] == 0) {
        self->progression = [[NSMutableArray alloc] initWithArray:newProgression];
    }
}

-(void)removeFirstProgression {
    [self->progression removeObjectAtIndex:0];
}

@end
