//
//  SHLMarsRoverClient.h
//  Rover
//
//  Created by Steve Lederer on 12/19/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHLMarsRover.h"
#import "SHLMarsPhoto.h"


@interface SHLMarsRoverClient : NSObject

-(void)fetchAllMarsRoversWithCompletion:(void (^) (NSArray *roverNames, NSError *error)) completion;

-(void)fetchMissionManifestForRoverNamed:(NSString *)roverName
                              completion:(void (^) (SHLMarsRover *rover, NSError *error))completion;

-(void)fetchPhotosFromRover:(SHLMarsRover *)rover
                   solTaken:(NSInteger)solTaken
                 completion:(void (^) (NSArray *photos, NSError *error))completion;

-(void)fetchImageDataForPhoto:(SHLMarsPhoto *)photo
                   completion:(void (^) (NSData *imageData))completion;

@end

