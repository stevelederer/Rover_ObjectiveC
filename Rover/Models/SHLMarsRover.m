//
//  SHLRover.m
//  Rover
//
//  Created by Steve Lederer on 12/19/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

#import "SHLMarsRover.h"
#import "SHLSolDescription.h"

@implementation SHLMarsRover

-(instancetype)initWithDictionary:(NSDictionary *)jsonDictionary
{
    // 1) Pull all the items out of the dictionary
    // 2) If we don't get the necessary information, return nil (if iskindofclass)
    // 3) initialize the objects' properties using the values we got from the dictionary
    
    self = [super init];
    if (self) {
        _name = jsonDictionary[@"name"];
        if (!_name) { return nil; }
        _landingDate = jsonDictionary[@"landing_date"];
        _launchDate = jsonDictionary[@"launch_date"];
        _status = [jsonDictionary[@"status"] isEqualToString:@"active"] ? SHLMarsRoverStatusActive : SHLMarsRoverStatusComplete;
        _maxSol = [jsonDictionary[@"max_sol"] integerValue];
        _maxDate = jsonDictionary[@"max_date"];
        _numberOfPhotos = [jsonDictionary[@"total_photos"] integerValue];
        
        NSArray *solDescriptionDictionaries = jsonDictionary[@"photos"];
        
        NSMutableArray *solDescriptions = [NSMutableArray array];
        
        for (NSDictionary *dict in solDescriptionDictionaries) {
            SHLSolDescription *solDescription = [[SHLSolDescription new] initWithDictionary:dict];
            
            if (!solDescription) { continue; }
            [solDescriptions addObject:solDescription];
        }
        _solDescriptions = [solDescriptions copy];
    }
    return self;
}

@end
