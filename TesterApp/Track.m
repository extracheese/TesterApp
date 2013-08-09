//
//  Track.m
//  TesterApp
//
//  Created by Ogishi on 7/29/13.
//  Copyright (c) 2013 Ogishi. All rights reserved.
//

#import "Track.h"
#import "helper.h"

@implementation Track
- (id) initWithDictionary: (NSDictionary*) dictionary
{
    self = [super init];
    _trackType = kTrackUnknown;
//    NSString* wrapper = [dictionary objectForKey: @"wrapperType"];
    _artistName = [dictionary objectForKey: @"artistName"];
    _artworkImageURL = [[NSURL alloc] initWithString: (NSString*)[dictionary objectForKey: @"artworkUrl100"]];
    _trackName = [dictionary objectForKey: @"trackName"];
    
    NSString* tempString = (NSString*)[dictionary objectForKey: @"previewUrl"];
    if(tempString){
        _previewURL = [[NSURL alloc] initWithString: tempString];

    }
    
    tempString = (NSString*) [dictionary objectForKey: @"kind"];
    if([tempString isEqualToString:@"music-video"] || [tempString isEqualToString:@"feature-movie"]){
        _trackType = kTrackVideo;
    }
    else if([tempString isEqualToString: @"song"] || [tempString isEqualToString: @"podcast"]){
        _trackType = kTrackAudio;
    }
    return self;
}




@end
