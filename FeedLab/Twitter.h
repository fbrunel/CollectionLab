//
//  Twitter.h
//  FeedSource
//
//  Created by Fred Brunel on 2014-07-01.
//  Copyright (c) 2014 FBL. All rights reserved.
//

#import "FBDataSource.h"

@interface Tweet : NSObject

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSURL *profileImageURL;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *dateRepresentation;

- (instancetype)initWithJSONObject:(NSDictionary *)JSONObject;

@end

//

@interface Twitter : NSObject

- (FBDataSource *)dataSourceForHomeTimeline;

@end
