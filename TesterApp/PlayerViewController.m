//
//  PlayerViewController.m
//  TesterApp
//
//  Created by Ogishi on 8/6/13.
//  Copyright (c) 2013 Ogishi. All rights reserved.
//

#import "PlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface PlayerViewController ()

@end

@implementation PlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil track:(Track*) track{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        self.track = track;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    MPMoviePlayerController *player =  [[MPMoviePlayerController alloc] initWithContentURL:self.track.previewURL];
    player.view.frame = CGRectMake(0, 0, 400, 300);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:player];

    [player prepareToPlay];
    [self.view addSubview:player.view];
    [player play];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) playbackDidFinish:(NSNotification*)notification {
    int reason = [[[notification userInfo] valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    if (reason == MPMovieFinishReasonPlaybackEnded) {
        NSLog(@"movie finished playin");
    }else if (reason == MPMovieFinishReasonUserExited) {
        NSLog(@"user hit the done button");
    }else if (reason == MPMovieFinishReasonPlaybackError) {
        //error
        NSLog(@"playback error");
    }
}
@end