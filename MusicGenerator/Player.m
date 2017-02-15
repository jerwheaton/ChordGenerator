//
//  Player.m
//  MusicGenerator
//
//  Created by Jeremy Wheaton on 2016-10-03.
//  Copyright © 2016 Jeremy Wheaton. All rights reserved.
//

#import "Player.h"

@implementation Player

- (id)init {
    
    _soundBankPlayer = [[SoundBankPlayer alloc] init];
    [_soundBankPlayer setSoundBank:@"Piano"];
    
    // TODO: Replace this with a user inputted value from the view controller...
    
    //DebugLog(@"RANDOM NUMBER: %ld", (long)[_randDist nextInt]);
    
    //[playThread cancel]; // Ensure this is not running
    
    self->currentState = [[State alloc] init];
    
    return self;
}

-(void)playWithProcedure:(uint8_t)procedure {
    
    _settings = [[SongSettings alloc] initWithSeed:@"test" andProcedure:procedure];
    
    //[_settings setProcedure:procedure];
    if ([playThread isExecuting]) {
        return;
    }
    
    playThread = [[NSThread alloc] initWithTarget:self selector:@selector(startPlaying) object:nil];
    [playThread start];
    //[self startPlaying];
}

-(void)stop {
    [playThread cancel];
}

-(void)startPlaying {
    while (![[NSThread currentThread] isCancelled]) {
        [self chooseNotes];
    }
    DebugLog(@"Cancel 1");
    [NSThread exit];
}

-(double)randomNoteLength {
    return (double)1 / (1 << ([_settings randomEightBitWithLower:0 andUpper:SHORTEST_NOTE]));
}

-(uint8_t)randomMidiNoteWithOctave:(uint8_t)octave andLastNote:(int)lastNote {
    if ([_settings getProcedure] == 0) {
        return [_settings randomEightBitWithLower:MIDI_MIN andUpper:MIDI_MAX];
    } else {
        uint8_t noteInScale = [_settings randomEightBitWithLower:SCALE_MIN andUpper:SCALE_MAX];
        DebugLog(@"Random Note: %hhu, (%hhu)", noteInScale, octave);
        return [_settings getKey] + [[_settings getScale][noteInScale] integerValue] + (octave * NOTES_IN_OCTAVE);
    }
}

-(uint8_t)randomNoteCount {
    if ([_settings getProcedure] < 3) {
        return [_settings randomEightBitWithLower:1 andUpper:4];
    } else {
        return [_settings randomEightBitWithLower:1 andUpper:3];
    }
    
}

-(double)randomGain {
    return (double)[_settings randomEightBitWithLower:MIN_GAIN andUpper:MAX_GAIN] / 10;
}

-(uint8_t)randomOctave {
    if ([_settings getProcedure] < 4) {
        return [_settings randomEightBitWithLower:OCTAVE_MIN andUpper:OCTAVE_MAX];
    } else {
        return [_settings randomEightBitWithLower:OCTAVE_MIN+1 andUpper:OCTAVE_MAX-1];
    }
}

-(void)chooseNotes {
    double totalBeats = 0.0f;
    DebugLog(@"Starting loop...");
    while ((int)totalBeats < [self->_settings getBeatsPerMeasure]) {
        if ([[NSThread currentThread] isCancelled]) {
            break;
        }
        
        [currentState setProgressionIfEmptyWith:[_settings getRandomProgression]];
        
        Chord *chord = [self generateChordWithLastChord:[[currentState getChords] lastObject] andPosition:[currentState getProgression][0]];
        [currentState removeFirstProgression];
        
        if ([_settings getProcedure] == 4 && [[currentState getProgression] count] != 0) {
            double expectedDuration = (double)1 / [_settings getNoteSingleBeat];
            DebugLog(@"Going to check to insert a spacer note");
            if ([chord getDuration] < expectedDuration) {
                double tmpBeatsSoFar = [self->_settings getNoteSingleBeat] * [chord getDuration];
                totalBeats += tmpBeatsSoFar;
                NSTimeInterval sleepFor = (tmpBeatsSoFar / ((double)[_settings getBeatsPerMinute] / 60));
                [NSThread sleepForTimeInterval:sleepFor];
                
                uint8_t note = [self randomMidiNoteWithOctave:[chord getOctave] andLastNote:(int)[chord getNotes][0]];
                [_soundBankPlayer queueNote:note gain:[chord getGain]];
                [_soundBankPlayer playQueuedNotes];
                [NSThread sleepForTimeInterval:sleepFor];
            }
        }
        
        double beatCheck = [self->_settings getNoteSingleBeat] * [chord getDuration];
        if (totalBeats + beatCheck > [self->_settings getBeatsPerMeasure]) {
            [chord setDuration:((double)([self->_settings getBeatsPerMeasure] - totalBeats) / [self->_settings getNoteSingleBeat])];
            DebugLog(@"Changed: %f",  [chord getDuration]);
        }
        
        double beatsThisIteration = [self->_settings getNoteSingleBeat] * [chord getDuration];
        
        totalBeats += beatsThisIteration;
        DebugLog(@"Beats this measure so far: %f", totalBeats);
        
        NSTimeInterval sleepFor = (beatsThisIteration / ((double)[_settings getBeatsPerMinute] / 60));
        DebugLog(@"Sleeping For: %f", sleepFor);
        
        [currentState addChord:chord];
        [NSThread sleepForTimeInterval:sleepFor];
    }
    
    DebugLog(@"Finishing loop...");
}


-(Chord *)chordForPosition:(NSNumber *)pos andNoteCount:(uint8_t)noteCount andGain:(double)gain andDuration:(double)duration andOctave:(uint8_t)octave {
    Chord *newChord = [[Chord alloc] initWithGain:gain andDuration:duration andOctave:octave];
    int second = (int)[pos integerValue] + 2;
    int third = (int)[pos integerValue] + 4;
    int fourth = (int)[pos integerValue] + 6;
    int modSecond = 0;
    int modThird = 0;
    int modFourth = 0;
    if (second > [[_settings getScale] count] - 1) {
        second = (second % [[_settings getScale] count]);
        modSecond = 12;
    }
    
    if (third > [[_settings getScale] count] - 1) {
        third = (third % [[_settings getScale] count]);
        modThird = 12;
    }
    
    if (fourth > [[_settings getScale] count] - 1) {
        fourth = (fourth % [[_settings getScale] count]);
        modFourth = 12;
    }
    
    uint8_t note1 = [_settings getKey] + [[_settings getScale][[pos integerValue]] integerValue] + (octave * NOTES_IN_OCTAVE);
    uint8_t note2 = [_settings getKey] + [[_settings getScale][second] integerValue] + modSecond + (octave * NOTES_IN_OCTAVE);
    uint8_t note3 = [_settings getKey] + [[_settings getScale][third] integerValue] + modThird + (octave * NOTES_IN_OCTAVE);
    uint8_t note4 = note1 + NOTES_IN_OCTAVE;
    DebugLog(@"============= NOTE DEBUG =============");
    DebugLog(@"key: %hhu", [_settings getKey]);
    DebugLog(@"scale: %@", [_settings getScale]);
    DebugLog(@"notes: %ld, %d, %d, %d", (long)[pos integerValue], second, third, fourth);
    DebugLog(@"mods: %d, %d, %d", modSecond, modThird, modFourth);
    DebugLog(@"octave: %hhu", octave);
    DebugLog(@"NOTE VALUES: %d, %d, %d, %d", note1, note2, note3, note4);
    DebugLog(@"============= NOTE DEBUG =============");
    
    [newChord addNote:note1];
    if (noteCount == 2) {
        uint8_t test = [_settings randomEightBitWithLower:0 andUpper:1];
        if (test == 0) {
            [newChord addNote:note2];
        } else {
            [newChord addNote:note3];
        }
    } else if (noteCount == 3) {
        [newChord addNote:note2];
        [newChord addNote:note3];
    } else {
        [newChord addNote:note2];
        [newChord addNote:note3];
        [newChord addNote:note4];
    }

    return newChord;
}

-(void)queueChord:(Chord *)chord {
    NSArray *notes = [chord getNotes];
    for (int i = 0; i < [notes count]; i++) {
        [_soundBankPlayer queueNote:(int)[notes[i] integerValue] gain:[chord getGain]];
    }
}

-(Chord *)generateChordWithLastChord:(Chord *)lastChord andPosition:(NSNumber *)pos {
    Chord *chord;
    uint8_t noteCount = [self randomNoteCount];
    double notesLength = [self randomNoteLength];
    double gain = [self randomGain];
    uint8_t octave = [self randomOctave];
    
    DebugLog(@"Last Chord: %@", lastChord);
    
    if (lastChord && [_settings getProcedure] > 0) {
        if ([_settings randomEightBitWithLower:0 andUpper:[_settings getProcedure] + 5] == 0 || [lastChord getOctave] == OCTAVE_MIN || [lastChord getOctave] == OCTAVE_MAX) {
            octave = [self newOctaveFrom:[lastChord getOctave]];
        } else {
            octave = [lastChord getOctave];
        }
    }

    if ([_settings getProcedure] <= 1) {
        chord = [[Chord alloc] initWithGain:gain andDuration:notesLength andOctave:octave];
        int lastNote = -1;
        for (int i = 0; i < noteCount; i++) {
            uint8_t note = [self randomMidiNoteWithOctave:[chord getOctave] andLastNote:(int)lastNote];
            [_soundBankPlayer queueNote:note gain:gain];
            DebugLog(@"Queueing single note: %hhu for 1/%.0f (Gain: %f)", note, (double)1 / notesLength, gain);
            [chord addNote:note];
            
            // Chance to change octave in this chord. 25% at p lvl1
            // (meaningless at p lvl0.)
            if ([_settings randomEightBitWithLower:0 andUpper:[_settings getProcedure] + 2] == 0) {
                [chord setOctave:[self newOctaveFrom:[chord getOctave]]];
            }
            lastNote = (int)note;
        }
    } else {
        if ([_settings getProcedure] >= 2) {
            notesLength = (double)1 / [_settings getNoteSingleBeat];
            
            uint8_t test = [_settings randomEightBitWithLower:0 andUpper:1];
            uint8_t coinFlip = [_settings randomEightBitWithLower:0 andUpper:1];
            
            if (test == 0) {
                if ([_settings getProcedure] == 4) {
                    notesLength /= 2;
                } else {
                    if (coinFlip == 0) {
                        notesLength *= 2;
                    } else {
                        notesLength /= 2;
                    }
                }
            }
        }

        chord = [self chordForPosition:pos andNoteCount:noteCount andGain:gain andDuration:notesLength andOctave:octave];
        [self queueChord:chord];
    }
    
    [_soundBankPlayer playQueuedNotes];
    
    return chord;
}

-(uint8_t)newOctaveFrom:(uint8_t)octave {
    uint8_t newOctave = [self randomOctave];
    if ([_settings getProcedure] < 2) {
        return newOctave;
    }

    if (newOctave > octave && octave < OCTAVE_MAX) {
        return ++octave;
    }
    if (newOctave < octave && octave > OCTAVE_MIN) {
        return --octave;
    }
    return octave;
}


-(SongSettings *)getSettings {
    return self->_settings;
}

@end
