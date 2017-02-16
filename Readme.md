## iOS Chord Generator
An iOS application that is able to generate increasingly procedurally generated
music. The slider values use the following rules:

```
0: Fully random, key and time signatures mean nothing. Between 1 and 4 notes are
selected at and played for random durations.
1: Notes are selected from the randomly selected key signature. Octave will change
randomly.
2: Chosen notes/chords are recognized to compliment each other. Timing of notes is
less random, but still chaotic. Octave changes will occur more slowly and less
frequent. Notes/chords are fit into measures corresponding to the generated time
signature.
3: Chords/notes played follow recognized chord progressions. 1-3 notes are played
and mutations in octave are even less frequent. Chord progressions can be either
3 or 4 chords long.
4: Chords/Notes are played with some rhythm. Rhythm will match the number of
chords in the current progression, which is now only 4. Ocatave changes are less
frequent still.
```

This was composed as a solo entry in a Hackathon, so the source is somewhat
messy in places. Many corners were cut in order for the procedure level 4 to be
completed, but if I ever come back to continue development I would like to have
the app have some ability to plan out the song being generated, remember melodys
that it has used, and have more dynamic rhythms. I would also like to add an
input so that the random generation could be seeded and songs could be revisited.
