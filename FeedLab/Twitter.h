//
//  Twitter.h
//
//  Created by Fred Brunel on 2014-07-01.
//  Copyright (c) 2014 FBL. All rights reserved.
//

#import "FBDataSource.h"

@interface Tweet : NSObject

@property (strong, readonly, nonatomic) NSString *text;
@property (strong, readonly, nonatomic) NSString *userName;
@property (strong, readonly, nonatomic) NSURL *profileImageURL;
@property (strong, readonly, nonatomic) NSDate *date;
@property (strong, readonly, nonatomic) NSString *dateRepresentation;

- (instancetype)initWithJSONObject:(NSDictionary *)JSONObject;

@end

//

@interface Twitter : NSObject

- (FBDataSource *)dataSourceForHomeTimeline;

@end
