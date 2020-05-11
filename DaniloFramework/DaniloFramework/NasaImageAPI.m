//
//  NasaImageAPI.m
//  DaniloFramework
//
//  Created by Danilo Silveira on 2020-05-09.
//  Copyright © 2020 Danilo Silveira. All rights reserved.
//

#import "NasaImageAPI.h"

@implementation NasaImageAPI

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.apiKey = @"No Name";
    }
    return self;
}
 
- (instancetype)initWithApiKey:(NSString*) apiKey
{
    self = [super init];
    if (self) {
        self.apiKey = apiKey;
    }
    return self;
}
 
-(void)getImageUrl:(void (^)(NSString * imageString))completion{
    NSString *queryString = [NSString stringWithFormat:@"https://api.nasa.gov/planetary/apod?api_key=%@", self.apiKey];
    NSURL *url = [NSURL URLWithString:queryString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL: url];

    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL: url
              completionHandler:^(NSData *data,
                                  NSURLResponse *response,
                                  NSError *error) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        completion(json[@"url"]);
      }] resume];
}

-(void)getImageWithHandler:(void (^)(NSData * imageData))completion{
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            [self getImageUrl:^(NSString * _Nonnull imageString) {
                NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageString]];
                if ( data == nil )
                    return;
                    completion(data);
            }];
            
        });
}

@end
