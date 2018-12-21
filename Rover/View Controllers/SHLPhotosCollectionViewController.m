//
//  SHLPhotosCollectionViewController.m
//  Rover
//
//  Created by Steve Lederer on 12/19/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

#import "SHLPhotosCollectionViewController.h"
#import "SHLMarsRoverClient.h"
#import "SHLMarsPhoto.h"
#import "SHLPhotoCache.h"
#import "SHLPhotoCollectionViewCell.h"
#import "Rover-Bridging-Header.h"
#import "Rover-Swift.h"


@interface SHLPhotosCollectionViewController ()

@property (nonatomic, copy, readwrite) SHLMarsRoverClient *client;
@property (nonatomic, copy) NSArray *photos;

@end

@implementation SHLPhotosCollectionViewController

-(void)fetchPhotoReferences
{
    [[self client] fetchPhotosFromRover:self.rover solTaken:self.solDescription.solNumber completion:^(NSArray * photos, NSError * error) {
        if (error) {
            NSLog(@"Error fetching photos in Collection View: %@", error.localizedDescription);
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photos = photos;
            [self refresh];
        });
    }];
}

static NSString * const reuseIdentifier = @"photoCell";

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self fetchPhotoReferences];
    [self setClient];
    [self refresh];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fetchPhotoReferences];
    NSString *title = [NSString stringWithFormat:@"%@ - sol %ld", self.rover.name, (long)self.solDescription.solNumber ];
    [self setTitle: title];
}

-(void)refresh
{
    [[self collectionView] reloadData];
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqual:@"toPhotoDetail"]) {
         PhotoDetailViewController *destinationVC = segue.destinationViewController;
         NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
         SHLMarsPhoto *photo = self.photos[indexPath.row];
         destinationVC.photo = photo;
         destinationVC.rover = self.rover;
     }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SHLPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    SHLMarsPhoto *photo = self.photos[indexPath.row];
    
    SHLPhotoCache *cache = [SHLPhotoCache sharedCache];
    NSData *cacheData = [cache imageDataForIdentifier:photo.photoID];
    if (cacheData != nil) {
        UIImage *image = [UIImage imageWithData:cacheData];
        cell.photoImageView.image = image;
    } else {
        cell.photoImageView.image = [UIImage imageNamed:@"MarsPlaceholder"];
    }
    
    [self.client fetchImageDataForPhoto:photo completion:^(NSData * imageData) {
        if  (!imageData){ return; }
        [cache cacheImageData:imageData forIdentifier:photo.photoID];
        UIImage *image = [UIImage imageWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![indexPath isEqual:[collectionView indexPathForCell:cell]]) {
                return;
            }
            cell.photoImageView.image = image;
        });
    }];    
    return cell;
}

- (void) setClient
{
    SHLMarsRoverClient *client = [[SHLMarsRoverClient alloc] init];
    _client = client;
}

- (void)setRover:(SHLMarsRover *)rover{
    if (rover != _rover) {
        _rover = rover;
//        [self fetchPhotoReferences];
        [self.collectionView reloadData];
    }
}
- (void)setSolDescription:(SHLSolDescription *)solDescription
{
    if (solDescription != _solDescription) {
        _solDescription = solDescription;
//        [self fetchPhotoReferences];
        [self.collectionView reloadData];
    }
}

-(void)setPhotos:(NSArray *)photos
{
    if (photos != _photos) {
        _photos = [photos copy];
        [self.collectionView reloadData]; 
    }
}

@end
