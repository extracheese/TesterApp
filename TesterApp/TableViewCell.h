//
//  TableViewCell.h
//  TesterApp
//
//  Created by Ogishi on 8/2/13.
//  Copyright (c) 2013 Ogishi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Track.h"

@interface TableViewCell : UITableViewCell

@property (weak,nonatomic) Track* track;
@property NSInteger row;

+(NSString*) cellIdentifier;
+(int) height;
-(void) refreshLayoutWithTrack:(Track*)track atIndex:(NSInteger) row;
-(void) stopLoadingIndicator;
-(void) notifyTable: (NSObject*) object;


@end
