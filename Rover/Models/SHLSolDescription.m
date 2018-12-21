//
//  SHLSolDescription.m
//  Rover
//
//  Created by Steve Lederer on 12/19/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

#import "SHLSolDescription.h"

@implementation SHLSolDescription

-(instancetype)initWithDictionary:(NSDictionary *)jsonDictionary
{
    self = [super init];
    if (self) {
        _solNumber = [jsonDictionary[@"sol"] integerValue];
        _totalPhotos = [jsonDictionary[@"total_photos"] integerValue];
        _cameras = jsonDictionary[@"cameras"];
    }
    return self;
}



@end
