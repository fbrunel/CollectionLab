//
//  Twitter.h
//  FeedSource
//
//  Created by Fred Brunel on 2014-07-01.
//  Copyright (c) 2014 FBL. All rights reserved.
//

#import "FBFeedSource.h"

@interface Tweet : NSObject

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *userName;

- (instancetype)initWithJSONObject:(NSDictionary *)JSONObject;

@end

//

@interface Twitter : NSObject

- (FBFeedSource *)sourceForHomeTimeline;

@end
