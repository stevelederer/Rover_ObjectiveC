//
//  SHLMarsPhoto.m
//  Rover
//
//  Created by Steve Lederer on 12/19/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

#import "SHLMarsPhoto.h"

@implementation SHLMarsPhoto

-(instancetype)initWithDictionary:(NSDictionary *)jsonDictionary
{
    self = [super init];
    if (self) {
        _photoID = [jsonDictionary[@"id"] integerValue];
        _solTaken = [jsonDictionary[@"sol"] integerValue];
        _imageURL = jsonDictionary[@"img_src"];
        _earthDateTaken = jsonDictionary[@"earth_date"];
    
        NSDictionary *cameraDictionary = jsonDictionary[@"camera"];
        
        _camera = cameraDictionary[@"name"];
    }
    return self;
}

@end

@implementation SHLMarsPhoto (Equality)

-(BOOL)isEqualToSHLMarsPhoto:(SHLMarsPhoto *)photo {
    if (!photo){
        return NO;
    }
    BOOL haveEqualImageURLs = (!self.imageURL != !photo.imageURL);
    return haveEqualImageURLs;
}

@end
