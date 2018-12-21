//
//  SHLRover.h
//  Rover
//
//  Created by Steve Lederer on 12/19/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SHLMarsRover : NSObject

-(instancetype)initWithDictionary:(NSDictionary *)jsonDictionary;

typedef NS_ENUM(NSInteger, SHLMarsRoverStatus) {
    SHLMarsRoverStatusActive,
    SHLMarsRoverStatusComplete,
};

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong, readonly) NSString *landingDate;
@property (nonatomic, strong, readonly) NSString *launchDate;
@property (nonatomic, readonly) SHLMarsRoverStatus status;
@property (nonatomic, readonly) NSInteger maxSol;
@property (nonatomic, strong, readonly) NSString *maxDate;
@property (nonatomic, readonly) NSInteger numberOfPhotos;
@property (nonatomic, readonly) NSArray *solDescriptions;

@end


