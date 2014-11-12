//
//  FBDataSource.h
//
//  Created by Fred Brunel on 2014-06-30.
//  Copyright (c) 2014 FBL. All rights reserved.
//

typedef void (^FBDataSourceFetchCompletionBlock)(NSArray *items, NSError *error);

@protocol FBDataSource <NSObject>

@property (nonatomic, readonly, assign) BOOL hasMore;
@property (nonatomic, readonly) BOOL isFetching; // FIXME: use a getter named "isFetching"; name the property "fetching"

- (BOOL)fetchRange:(NSRange)range completionBlock:(FBDataSourceFetchCompletionBlock)completionBlock;
- (void)cancel;

@end

//

@interface FBDataSource : NSObject <FBDataSource>
@end
