//
//  State.h
//  MusicGenerator
//
//  Created by Jeremy Wheaton on 2016-10-06.
//  Copyright © 2016 Jeremy Wheaton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Chord.h"


@interface State : NSObject {
    NSMutableArray *chords;
    NSMutableArray *progression;
}

#pragma mark Getters

-(NSMutableArray *)getChords;
-(NSMutableArray *)getProgression;

#pragma mark Setters

-(void)setProgressionIfEmptyWith:(NSArray *)newProgression;

#pragma mark Utils
-(void)addChord:(Chord *)chord;
-(void)removeFirstProgression;

@end
