//
//  SHLPhotoCollectionViewCell.m
//  Rover
//
//  Created by Steve Lederer on 12/19/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

#import "SHLPhotoCollectionViewCell.h"

@implementation SHLPhotoCollectionViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.photoImageView.image = [UIImage imageNamed:@"MarsPlaceholder"];
}

@end
