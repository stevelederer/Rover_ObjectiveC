//
//  SHLPhotoCache.h
//  Rover
//
//  Created by Steve Lederer on 12/19/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SHLPhotoCache : NSObject

@property (nonatomic, readonly, class) SHLPhotoCache *sharedCache;

-(void)cacheImageData:(NSData *)data
        forIdentifier:(NSInteger)identifier;

-(NSData *)imageDataForIdentifier:(NSInteger)identifier;

@end

