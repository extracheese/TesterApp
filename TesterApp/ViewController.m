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

#import "PlayerViewController.h"


#define kItunesSearchUrl [NSURL URLWithString:@"https://itunes.apple.com/search?term=jack+johnson&limit=25"] //2




@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    _tracks = nil;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    CGRect rect = CGRectMake(0, 0, (NSInteger)screenRect.size.width, (NSInteger)screenRect.size.height);
    
    _table = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _table.dataSource = self;
    _table.delegate = self;
    [_table setSeparatorColor:[UIColor clearColor]];
    [self.view addSubview:_table];
   
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

// Tap on table Row
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
    TableViewCell* cell = (TableViewCell*)[_table cellForRowAtIndexPath:indexPath];
    if(cell.track.previewURL){
        PlayerViewController* playerViewController = [[PlayerViewController alloc] initWithNibName:@"PlayerViewController" track:cell.track];

        [self.navigationController pushViewController: playerViewController animated:YES];
    }
}



@end
