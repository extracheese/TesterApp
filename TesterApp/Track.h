//
//  Track.h
//  TesterApp
//
//  Created by Ogishi on 7/29/13.
//  Copyright (c) 2013 Ogishi. All rights reserved.
//

#import <Foundation/Foundation.h>

/* response example
 {
 wrapperType: "track",
 kind: "music-video",
 artistId: 909253,
 trackId: 171852806,
 artistName: "Jack Johnson",
 trackName: "Taylor",
 trackCensoredName: "Taylor",
 artistViewUrl: "...",
 trackViewUrl: "...",
 previewUrl: "...",
 artworkUrl30: "...",
 artworkUrl60: "...",
 artworkUrl100: "...",
 collectionPrice: 1.99,
 trackPrice: 1.99,
 releaseDate: "2010-09-09T07:00:00Z",
 collectionExplicitness: "notExplicit",
 trackExplicitness: "notExplicit",
 trackTimeMillis: 331395,
 country: "USA",
 currency: "USD",
 primaryGenreName: "Rock"
 }
 */


@interface Track : NSObject

    - (id) initWithDictionary: (NSDictionary*) dictionary;

    @property NSString* artistName;
@property NSString* trackName;
    @property NSURL* artworkImageURL;
@end
