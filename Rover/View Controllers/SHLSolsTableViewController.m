//
//  SHLSolsTableViewController.m
//  Rover
//
//  Created by Steve Lederer on 12/19/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

#import "SHLSolsTableViewController.h"
#import "SHLSolDescription.h"
#import "SHLMarsRover.h"
#import "SHLPhotosCollectionViewController.h"

@interface SHLSolsTableViewController ()

@end

@implementation SHLSolsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title = [NSString stringWithFormat:@"%@%@", _rover.name, @" sols"];
    [self setTitle: title];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rover.solDescriptions.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"solCell" forIndexPath:indexPath];
    SHLSolDescription *solDescription = self.rover.solDescriptions[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"sol %ld", (long)solDescription.solNumber];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld Photos", (long)solDescription.totalPhotos];
    NSLog(@"sol %ld, Photos %lu",solDescription.solNumber, solDescription.totalPhotos);
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"toPhotoCollectionView"]) {
        SHLPhotosCollectionViewController *destinationVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SHLSolDescription *sol = self.rover.solDescriptions[indexPath.row];
        destinationVC.solDescription = sol;
        destinationVC.rover = self.rover;
    }
}

// MARK: - Custom Setter
- (void)setRover:(SHLMarsRover *)rover
{
    if (rover != _rover) {
        _rover = rover;
        [self.tableView reloadData];
    }
}

@end
