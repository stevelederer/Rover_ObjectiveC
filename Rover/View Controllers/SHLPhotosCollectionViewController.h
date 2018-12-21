//
//  SHLPhotosCollectionViewController.h
//  Rover
//
//  Created by Steve Lederer on 12/19/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHLMarsRover.h"
#import "SHLSolDescription.h"


@interface SHLPhotosCollectionViewController : UICollectionViewController

@property (nonatomic, strong) SHLMarsRover *rover;
@property (nonatomic, strong) SHLSolDescription *solDescription;

@end

