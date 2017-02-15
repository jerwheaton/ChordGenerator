//
//  ViewController.m
//  MusicGenerator
//
//  Created by Jeremy Wheaton on 2016-10-03.
//  Copyright © 2016 Jeremy Wheaton. All rights reserved.
//

#import "ViewController.h"
#include "Player.h"

@interface ViewController () {
    Player *_player;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _player = [[Player alloc] init];
    [self disableButton:_stopButton];
    [self enableButton:_playButton];
    
    [_timeSignatureLabel setText:nil];
    [_bpmLabel setText:nil];
    [_keyLabel setText:nil];
    
    _labelsView.layer.cornerRadius = 5;
    _labelsView.layer.masksToBounds = YES;
    
    // Status bar, force light
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)enableButton:(id)btn {
    [btn setEnabled:true];
    [btn setAlpha:0.6];
}
-(void)disableButton:(id)btn {
    [btn setEnabled:false];
    [btn setAlpha:0.3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)playPressed:(id)sender {
    [_player playWithProcedure:(int)([_slider value] + 0.5)];
    
    [self disableButton:_playButton];
    [self disableButton:_slider];
    [self enableButton:_stopButton];
    
    [NSThread sleepForTimeInterval:0.5];
    
    SongSettings *settings = [_player getSettings];
    
    [_timeSignatureLabel setText:[NSString stringWithFormat:@"%hhu/%hhu", [settings getBeatsPerMeasure], [settings getNoteSingleBeat]]];
    [_bpmLabel setText:[NSString stringWithFormat:@"%d BPM", [settings getBeatsPerMinute]]];
    [_keyLabel setText:[self nameOfKey:[settings getKey] andMajor:[settings getIsMajor]]];
}
- (IBAction)stopPressed:(id)sender {
    [_player stop];
    [self disableButton:_stopButton];
    [self enableButton:_playButton];
    [self enableButton:_slider];
    
}

- (IBAction)sliderChanged:(id)sender {
    [_sliderLabel setText:[NSString stringWithFormat:@"%d", (int)([_slider value] + 0.5)]];
}

-(NSString *)nameOfKey:(uint8_t)key andMajor:(bool)major {
    NSString *keyName = @"";
    if (major) {
        switch (key) {
            case 24:
                keyName = @"C Maj";
                break;
            case 25:
                keyName = @"D♭ Maj";
                break;
            case 26:
                keyName = @"D Maj";
                break;
            case 27:
                keyName = @"E♭ Maj";
                break;
            case 28:
                keyName = @"E Maj";
                break;
            case 29:
                keyName = @"F Maj";
                break;
            case 30:
                keyName = @"F♯ Maj";
                break;
            case 31:
                keyName = @"G Maj";
                break;
            case 32:
                keyName = @"A♭ Maj";
                break;
            case 33:
                keyName = @"A Maj";
                break;
            case 34:
                keyName = @"B♭ Maj";
                break;
            case 35:
                keyName = @"B Maj";
                break;
                
            default:
                keyName = @"NaN";
                break;
        }
    } else {
        
        switch (key) {
            case 24:
                keyName = @"C Min";
                break;
            case 25:
                keyName = @"C♯ Min";
                break;
            case 26:
                keyName = @"D Min";
                break;
            case 27:
                keyName = @"D♯ Min";
                break;
            case 28:
                keyName = @"E Min";
                break;
            case 29:
                keyName = @"F Min";
                break;
            case 30:
                keyName = @"F♯ Min";
                break;
            case 31:
                keyName = @"G Min";
                break;
            case 32:
                keyName = @"G♯ Min";
                break;
            case 33:
                keyName = @"A Min";
                break;
            case 34:
                keyName = @"B♭ Min";
                break;
            case 35:
                keyName = @"B Min";
                break;
                
            default:
                keyName = @"NaN";
                break;
        }
    }
    
    return keyName;
}


@end
