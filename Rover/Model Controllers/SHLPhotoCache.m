//
//  SHLPhotoCache.m
//  Rover
//
//  Created by Steve Lederer on 12/19/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

#import "SHLPhotoCache.h"

@interface SHLPhotoCache()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation SHLPhotoCache

+ (instancetype)sharedCache
{
    static SHLPhotoCache *sharedCache = nil;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{
        sharedCache = [self new];
    });
    return sharedCache;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        _cache = [NSCache new];
        _cache.name = @"com.stevelederer.Rover.PhotosCache";
    }
    return self;
}

- (void)cacheImageData:(NSData *)data forIdentifier:(NSInteger)identifier
{
    [self.cache setObject:data forKey:@(identifier) cost:[data length]];
}

- (NSData *)imageDataForIdentifier:(NSInteger)identifier
{
    return [self.cache objectForKey:@(identifier)];
}
@end
