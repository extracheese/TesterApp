//
//  PlayerViewController.h
//  TesterApp
//
//  Created by Ogishi on 8/6/13.
//  Copyright (c) 2013 Ogishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Track.h"

@interface PlayerViewController : UIViewController
- (id)initWithNibName:(NSString *)nibNameOrNil track:(Track*) track;

@property (weak,nonatomic) Track* track;
@end
