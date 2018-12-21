//
//  SHLMarsRoverClient.m
//  Rover
//
//  Created by Steve Lederer on 12/19/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

#import "SHLMarsRoverClient.h"
#import "SHLMarsRover.h"
#import "SHLMarsPhoto.h"

@implementation SHLMarsRoverClient

// MARK: - Fetch Functions

- (void)fetchAllMarsRoversWithCompletion:(void (^)(NSArray *roverNames, NSError *error))completion
{
    // URL
    NSURL *roverURL = [[self class] roversEndpoint];
    
    // DataTask + RESUME
    [[[NSURLSession sharedSession] dataTaskWithURL:roverURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"There was an error with the datatask %@", error.localizedDescription);
            completion(nil, error);
            return;
        }
        if (!data) {
            NSLog(@"no rovers data to decode: %@", error.localizedDescription);
            completion(nil, error);
            return;
        }
        
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (error) {
            NSLog(@"Error serializing JSON %@", error.localizedDescription);
            completion(nil, error);
            return;
        }
        NSArray *roversArray = jsonDictionary[@"rovers"];
        NSMutableArray *roverNames = [NSMutableArray array];
        for (NSDictionary *roverDictionary in roversArray) {
            NSString *name = roverDictionary[@"name"];
            if (name) { [roverNames addObject:name]; }
        }
        NSLog(@"%@", roverNames);
        completion(roverNames, nil);
    }] resume];
}

- (void)fetchMissionManifestForRoverNamed:(NSString *)roverName completion:(void (^)(SHLMarsRover *, NSError *))completion
{
    //URL
    NSURL *url = [[self class] URLForInfoForRover:roverName];
    
    //DataTask
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"There was an error with the datatask %@", error.localizedDescription);
            completion(nil, error);
            return;
        }
        if (!data) {
            NSLog(@"no manifests data to decode: %@", error.localizedDescription);
            completion(nil, error);
            return;
        }
        
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (error) {
            NSLog(@"Error serializing JSON %@", error.localizedDescription);
            completion(nil, error);
            return;
        }
        NSDictionary *roverManifest = jsonDictionary[@"photo_manifest"];
        SHLMarsRover *rover = [[SHLMarsRover alloc] initWithDictionary:roverManifest];
        completion(rover, nil);
    }] resume];
}

- (void)fetchPhotosFromRover:(SHLMarsRover *)rover solTaken:(NSInteger)solTaken completion:(void (^)(NSArray * photos, NSError *))completion
{
    //URL
    NSLog(@"2");

    NSURL *url = [[self class] URLForPhotosFromRover:rover.name forSol:solTaken];
    
    //DataTask
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"There was an error with the datatask %@", error.localizedDescription);
            completion(nil, error);
            return;
        }
        if (!data) {
            NSLog(@"no photos data to decode: %@", error.localizedDescription);
            completion(nil, error);
            return;
        }
        
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (error) {
            NSLog(@"error serializing JSON %@", error.localizedDescription);
            completion(nil, error);
            return;
        }
        NSArray *photosArray = jsonDictionary[@"photos"];
        NSMutableArray *photos = [NSMutableArray array];
        for (NSDictionary *photoDictionary in photosArray) {
            SHLMarsPhoto *photo = [[SHLMarsPhoto alloc] initWithDictionary:photoDictionary];
            [photos addObject:photo];
        }
        completion(photos, error);
    }] resume];
}
- (void)fetchImageDataForPhoto:(SHLMarsPhoto *)photo completion:(void (^)(NSData *imageData))completion
{
    //URL
    NSURL *photoImageURL = [NSURL URLWithString:photo.imageURL];
    NSLog(@"📷 %@", photoImageURL.absoluteString);
    
    //DataTask
    [[[NSURLSession sharedSession] dataTaskWithURL:photoImageURL completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        if (error) {
            NSLog(@"There was an error with the datatask %@", error.localizedDescription);
            completion(nil);
            return;
        }
        if (!data) {
            NSLog(@"no image data to decode %@", error.localizedDescription);
            completion(nil);
            return;
        }
        
        completion(data);
    }] resume];
    
}




// MARK: - API Key Function

+ (NSString *)apiKey
{
    static NSString *apiKey = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *apiKeysURL = [[NSBundle mainBundle] URLForResource:@"APIKeys" withExtension:@"plist"];
        if (!apiKeysURL) {
            NSLog(@"Error! APIKeys file not found!");
            return;
        }
        NSDictionary *apiKeys = [[NSDictionary alloc] initWithContentsOfURL:apiKeysURL];
        apiKey = apiKeys[@"APIKey"];
    });
    return apiKey;
}

// MARK: - URL Endpoint Functions

+ (NSURL *)baseURL
{
    return [NSURL URLWithString:@"https://api.nasa.gov/mars-photos/api/v1"];
}

//Rovers
+ (NSURL *)roversEndpoint
{
    NSURL *url = [[self baseURL] URLByAppendingPathComponent:@"rovers"];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
    urlComponents.queryItems = @[[NSURLQueryItem queryItemWithName:@"api_key" value:[self apiKey]]];
    return urlComponents.URL;
}

//Photos from Rover
+ (NSURL *)URLForPhotosFromRover:(NSString *)roverName forSol:(NSInteger)sol
{
    NSURL *url = [self baseURL];
    url = [url URLByAppendingPathComponent:@"rovers"];
    url = [url URLByAppendingPathComponent:roverName];
    url = [url URLByAppendingPathComponent:@"photos"];
    
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
    NSString *solString = [@(sol)stringValue];
    urlComponents.queryItems = @[[NSURLQueryItem queryItemWithName:@"sol" value:solString], [NSURLQueryItem queryItemWithName:@"api_key" value:[self apiKey]]];
    NSURL *photosUrl = urlComponents.URL;
    NSLog(@"%@", photosUrl.absoluteString);
    return photosUrl;
}

//Info For Rover
+ (NSURL *)URLForInfoForRover:(NSString *)roverName
{
    NSURL *url = [self baseURL];
    url = [url URLByAppendingPathComponent:@"manifests"];
    url = [url URLByAppendingPathComponent:roverName];
    
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
    urlComponents.queryItems = @[[NSURLQueryItem queryItemWithName:@"api_key" value:[self apiKey]]];
    return urlComponents.URL;
}

@end
