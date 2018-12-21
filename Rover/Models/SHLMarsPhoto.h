//
//  SHLMarsPhoto.h
//  Rover
//
//  Created by Steve Lederer on 12/19/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SHLMarsPhoto : NSObject


@property (nonatomic, readonly) NSInteger photoID;
@property (nonatomic, readonly) NSInteger solTaken;
@property (nonatomic, readonly) NSString *camera;
@property (nonatomic, readonly) NSString *imageURL;
@property (nonatomic, readonly) NSString *earthDateTaken;
@property (nonatomic, readonly) NSString *formattedEarthDateTaken;

-(instancetype)initWithDictionary:(NSDictionary *)jsonDictionary;

@end

