//
//  NasaImageAPI.h
//  DaniloFramework
//
//  Created by Danilo Silveira on 2020-05-09.
//  Copyright © 2020 Danilo Silveira. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NasaImageAPI : NSObject
@property NSString *apiKey;
 
-(instancetype) initWithApiKey:(NSString*) apiKey;
 
- (void)getImageUrl: (void (^)(NSString * imageString))completion;

- (void) getImageWithHandler: (void (^)(NSData * imageData))completion;
@end

NS_ASSUME_NONNULL_END
