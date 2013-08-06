//
//  ViewController.h
//  TesterApp
//
//  Created by Ogishi on 7/24/13.
//  Copyright (c) 2013 Ogishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray * _tracks;
    UITableView *_table;
}
@end


