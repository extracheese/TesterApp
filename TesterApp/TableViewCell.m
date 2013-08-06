//
//  TableViewCell.m
//  TesterApp
//
//  Created by Ogishi on 8/2/13.
//  Copyright (c) 2013 Ogishi. All rights reserved.
//

#import "TableViewCell.h"
#import "helper.h"

#define kViewTag_ArtistName 4
#define kViewTag_ImageView 1
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
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kCellHeight, kCellHeight)];
        imageView.tag = kViewTag_ImageView;
        [self addSubview:imageView];
        
        //[imageView setBackgroundColor: [UIColor greenColor]];
    }
    
    // put spinner in
    UIActivityIndicatorView* spinner = (UIActivityIndicatorView*)[self viewWithTag:kViewTag_Spinner];
    if(!spinner){
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.tag = kViewTag_Spinner;
        spinner.frame = CGRectMake(0, 0, kCellHeight, kCellHeight);
        //[spinner setBackgroundColor:[UIColor darkGrayColor]];
        [self addSubview:spinner];
    }
    [spinner startAnimating];
    
    // track name label
    UILabel* trackName = (UILabel*)[self viewWithTag:kViewTag_TrackName];
    if(!trackName){
        trackName = [[UILabel alloc] init];
        trackName.tag = kViewTag_TrackName;
              [self addSubview:trackName];
    }
    [trackName setText:track.trackName];
    trackName.frame = CGRectMake(kCellHeight + kPadding,
                                 artistName.frame.origin.y - [track.artistName sizeWithFont:artistName.font].height + 2,
                                 [track.trackName sizeWithFont:trackName.font].width,
                                 [track.trackName sizeWithFont:trackName.font].height);

    trackName.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:0.5 alpha:0.8];
    


    // init image load
    if(track.artworkImageURL){
            dispatch_async(kBgQueue, ^{
                UIImageView* imageView1 = (UIImageView*)[self viewWithTag:kViewTag_ImageView];
                imageView1.image = [UIImage imageNamed:[track.artworkImageURL absoluteString]];
                [self performSelectorOnMainThread:@selector(notifyTable:)
                                       withObject:self waitUntilDone:NO];

        });
    }
  
    //[self setNeedsLayout];
}

-(void) notifyTable: (NSObject*)object {
    UIImageView* imageView1 = (UIImageView*)[self viewWithTag:kViewTag_ImageView];
    [imageView1 setNeedsDisplay];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CellImageLoad" object:object];
}

-(void) stopLoadingIndicator{
    UIActivityIndicatorView* spinner = (UIActivityIndicatorView*)[self viewWithTag:kViewTag_Spinner];
    if(spinner){
       [spinner stopAnimating];
    }
}
@end
