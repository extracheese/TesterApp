//
//  TableViewCell.m
//  TesterApp
//
//  Created by Ogishi on 8/2/13.
//  Copyright (c) 2013 Ogishi. All rights reserved.
//
#import "helper.h"
#import "TableViewCell.h"

#define kViewTag_ArtistName 4
#define kViewTag_ImageView 20
#define kViewTag_Spinner 2
#define kViewTag_TrackName 3

#define kCellHeight 80
#define kPadding 5

@implementation TableViewCell


+(NSString*) cellIdentifier{
    return @"TrackCell";
}

+(int) height{
    return kCellHeight;
}

-(void) refreshLayoutWithTrack:(Track*)track atIndex:(NSInteger) row{
    self.row = row;
    self.track = track;
    
    // artist name label
    UILabel* artistName = (UILabel*)[self viewWithTag:kViewTag_ArtistName];
    if(!artistName){
        artistName = [[UILabel alloc] init];
        artistName.tag = kViewTag_ArtistName;
        
        
        artistName.font = [UIFont fontWithName:@"Helvetica-Bold" size:10.0];
        artistName.textColor = [UIColor darkGrayColor];
        [self addSubview:artistName];
    }
    [artistName setText:track.artistName ];
    artistName.frame = CGRectMake(kCellHeight + kPadding,
                                  kCellHeight - [track.artistName sizeWithFont:artistName.font].height - 4,
                                  [track.artistName sizeWithFont:artistName.font].width,
                                  [track.artistName sizeWithFont:artistName.font].height);
    
    // Setup imageview
    UIImageView* imageView = (UIImageView*)[self viewWithTag:kViewTag_ImageView];
    if(!imageView){
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, kCellHeight-10, kCellHeight-10)];
        imageView.tag = kViewTag_ImageView;
        [self addSubview:imageView];
    }
    imageView.image = nil;
    
    // Put spinner in
    UIActivityIndicatorView* spinner = (UIActivityIndicatorView*)[self viewWithTag:kViewTag_Spinner];
    if(!spinner){
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.tag = kViewTag_Spinner;
        spinner.frame = CGRectMake(0, 0, kCellHeight, kCellHeight);
        [self addSubview:spinner];
    }
    [spinner startAnimating];
    
    // Track name label
    UILabel* trackName = (UILabel*)[self viewWithTag:kViewTag_TrackName];
    if(!trackName){
        trackName = [[UILabel alloc] init];
        trackName.tag = kViewTag_TrackName;
        trackName.font = [UIFont fontWithName:@"Helvetica-Light" size:14.0];
         [self addSubview:trackName];
    }
    [trackName setText:track.trackName];
    trackName.frame = CGRectMake(kCellHeight + kPadding,
                                 artistName.frame.origin.y - ([track.artistName sizeWithFont:artistName.font].height + 3),
                                 [track.trackName sizeWithFont:trackName.font].width,
                                 [track.trackName sizeWithFont:trackName.font].height);

    // Init image load
    if(track.artworkImageURL){
            dispatch_async(kBgQueue, ^{
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:track.artworkImageURL]];
                [self performSelectorOnMainThread:@selector(notifyTable:) withObject:image waitUntilDone:YES];
                
        });
    }
    if(self.track.previewURL){
        [self setStyle:kEnabled];
    }
    else{
        [self setStyle:kDisabled];
    }

}

-(void) setStyle:(CellStyleType) styleType{
    if(styleType == kEnabled){
       UILabel* trackName = (UILabel*)[self viewWithTag:kViewTag_TrackName];
        trackName.textColor = [UIColor blackColor];
        UILabel* artistName = (UILabel*)[self viewWithTag:kViewTag_ArtistName];
        artistName.textColor = [UIColor darkGrayColor];
    }else{
        UILabel* trackName = (UILabel*)[self viewWithTag:kViewTag_TrackName];
        trackName.textColor = [UIColor lightGrayColor];
        UILabel* artistName = (UILabel*)[self viewWithTag:kViewTag_ArtistName];
        artistName.textColor = [UIColor lightGrayColor];
    }
}

-(void) notifyTable: (NSObject*)object {
    UIImageView* imageView1 = (UIImageView*)[self viewWithTag:kViewTag_ImageView];
    imageView1.image = (UIImage*) object;

    [self stopLoadingIndicator];
    //[self setNeedsLayout];
}

-(void) stopLoadingIndicator{
    UIActivityIndicatorView* spinner = (UIActivityIndicatorView*)[self viewWithTag:kViewTag_Spinner];
    if(spinner){
       [spinner stopAnimating];
    }
}


@end
