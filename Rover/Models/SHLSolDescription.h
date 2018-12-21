//
//  SHLSolDescription.h
//  Rover
//
//  Created by Steve Lederer on 12/19/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SHLSolDescription : NSObject

-(instancetype)initWithDictionary:(NSDictionary *)jsonDictionary;

@property (nonatomic, readonly) NSInteger solNumber;
@property (nonatomic, readonly) NSInteger totalPhotos;
@property (nonatomic, readonly) NSArray<NSString*> *cameras;

@end


