//
//  SHLRoversTableViewController.m
//  Rover
//
//  Created by Steve Lederer on 12/19/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

#import "SHLRoversTableViewController.h"
#import "SHLMarsRoverClient.h"
#import "SHLSolsTableViewController.h"

@interface SHLRoversTableViewController ()

@property (nonatomic, copy) NSArray *rovers;

@end

@implementation SHLRoversTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *rovers = [NSMutableArray array];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    SHLMarsRoverClient *client = [SHLMarsRoverClient new];
    [client fetchAllMarsRoversWithCompletion:^(NSArray * _Nonnull roverNames, NSError * _Nonnull error) {
        if (error){
            NSLog(@"Error fetching rovers in tableViewController: %@", error.localizedDescription);
            return;
        }
        dispatch_queue_t resultsQueue = dispatch_queue_create("com.stevelederer.RoverFetchResultsQueue", 0);
        
        for (NSString *name in roverNames) {
            dispatch_group_enter(group);
            [client fetchMissionManifestForRoverNamed:name completion:^(SHLMarsRover * _Nonnull rover, NSError * _Nonnull error) {
                if (error) {
                    NSLog(@"Error fetching list of mars rovers: %@", error.localizedDescription);
                    dispatch_group_leave(group);
                    return;
                }
                dispatch_async(resultsQueue, ^{
                    [rovers addObject:rover];
                    dispatch_group_leave(group);
                });
            }];
        }
        dispatch_group_leave(group);
    }];
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    self.rovers = rovers;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%lu", (unsigned long)_rovers.count);
    return self.rovers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"roverCell" forIndexPath:indexPath];
    SHLMarsRover *rover = self.rovers[indexPath.row];
    cell.textLabel.text = rover.name;
    NSLog(@"%@", rover);
    return cell;
}

 #pragma mark - Navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqual:@"toSolTableView"]) {
         SHLSolsTableViewController *destinationVC = segue.destinationViewController;
         NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
         destinationVC.rover = self.rovers[indexPath.row];
     }
 }

@end
