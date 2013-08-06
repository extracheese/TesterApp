//
//  ViewController.m
//  TesterApp
//
//  Created by Ogishi on 7/24/13.
//  Copyright (c) 2013 Ogishi. All rights reserved.
//

#import "ViewController.h"
#import "Track.h"
#import "helper.h"
#import "TableViewCell.h"


#define kItunesSearchUrl [NSURL URLWithString:@"https://itunes.apple.com/search?term=jack+johnson&limit=25"] //2




@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    _tracks = nil;
    CGRect rect = CGRectMake(0, 0, 360, 400);
    
    _table = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _table.dataSource = self;
    _table.delegate = self;
    [self.view addSubview:_table];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveCellImageLoad:)
                                                 name:@"CellImageLoad"
                                               object:nil];

    // start loading data from URL
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        kItunesSearchUrl];
        [self performSelectorOnMainThread:@selector(parseItunesResponse:)
                               withObject:data waitUntilDone:YES];
    });
}


- (void)parseItunesResponse:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    NSString* temp = [json objectForKey:@"resultCount"];
    int numItems = [temp intValue];
    NSLog(@"num results: %d", numItems);
    
    NSArray* results = [json objectForKey:@"results"];
    _tracks = [[NSMutableArray alloc] initWithCapacity:numItems];

    if ([results isKindOfClass:[NSArray class]]){
        NSEnumerator* enumerator = [results objectEnumerator];
        NSDictionary* result = nil;
        NSString* element = nil;
        
        while(result = [enumerator nextObject]){
            if((element = [result objectForKey:@"wrapperType"])){
                if([element isEqual:@"track"]){
                    [self->_tracks addObject: [[Track alloc] initWithDictionary:result]];
                }
            }
        }
    }
    else if ([results isKindOfClass:[NSDictionary class]]){
        NSLog(@"I am Dictionary");
    }
    else {
        NSLog(@"I am NOTHING :(");
    }
    
    [_table reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Table View Data Source Stuff

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_tracks){
        return [TableViewCell height];
    }
    return 0;
}


    
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if(section == 0 && _tracks){
        return [_tracks count];
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     TableViewCell* cell = (TableViewCell*)[tableView dequeueReusableCellWithIdentifier: [TableViewCell cellIdentifier]];
    
    
    if (cell == nil){
        cell = (TableViewCell*)[[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[TableViewCell cellIdentifier]];
        cell.backgroundColor = [UIColor yellowColor];
        
        NSLog(@"cell4row NEW: %d ",[indexPath row]);
    } else {
        
        NSLog(@"cell4row reuse: %d ",[indexPath row]);
    }
    
    if(!_tracks){
        return cell;
    }
    
    Track* track = [_tracks objectAtIndex:[indexPath row]];
    if(cell.track != track){
        [cell refreshLayoutWithTrack: track atIndex: [indexPath row]];
    }
    return cell;
}


-(void) receiveCellImageLoad: (NSNotification*) notification{
    if(!_table){
        return;
    }
    TableViewCell* cell = (TableViewCell*) [notification object];
    
    if([[notification name] isEqualToString:@"CellImageLoad"]){
        NSIndexPath* indexPath = [_table indexPathForCell: cell];
        if(indexPath){
            if(indexPath.row != cell.row){
                NSLog(@"OH NO cell changed!! :( was %d, now is %d",cell.row,indexPath.row);
                return;
            }
            NSArray* array = [NSArray arrayWithObject:indexPath];
            [cell stopLoadingIndicator];
            [_table reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
            NSLog(@"img load row: %d ",cell.row);
        }
        else{
            NSLog(@"nil index path in receiveCellImageLoad %d", cell.row);
            
        }
    }
}



@end
