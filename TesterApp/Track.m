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
//    NSString* wrapper = [dictionary objectForKey: @"wrapperType"];
    _artistName = [dictionary objectForKey: @"artistName"];
    _artworkImageURL = [[NSURL alloc] initWithString: (NSString*)[dictionary objectForKey: @"artworkUrl100"]];
    _trackName = [dictionary objectForKey: @"trackName"];
    
    return self;
}




@end
