//
//  common.h
//  MusicGenerator
//
//  Created by Jeremy Wheaton on 2016-10-03.
//  Copyright © 2016 Jeremy Wheaton. All rights reserved.
//

#ifndef common_h
#define common_h

/* Do this the easy way for now. */
#define MIN_GAIN 2 // 0.2
#define MAX_GAIN 6 // 0.6

#define BPM_MIN 25
#define BPM_MAX 200

/* Shortest note is 1/(2^n), where n is this value. */
#define SHORTEST_NOTE 5 // 1/32

/* According to MIDI spec: http://www.phys.unsw.edu.au/jw/notes.html */
#define MIDI_MIN 21
#define MIDI_MAX 108

/* 7 Notes in a scale */
#define SCALE_MIN 0
#define SCALE_MAX 6

#define NOTES_IN_OCTAVE 12

/* Scales take up one octave, chords one more, can only allow this to go use 5 total octaves */
#define OCTAVE_MIN 0
#define OCTAVE_MAX 4

#define ark4randomdouble() ((double)arc4random() / UINT32_MAX)

//#define DEV true

#ifdef DEV
#define DebugLog(FORMAT, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define DebugLog(FORMAT, ...) ;
#endif

#endif /* common_h */
