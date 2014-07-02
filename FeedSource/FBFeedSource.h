//
//  FBFeedSource.h
//
//  Created by Fred Brunel on 2014-06-30.
//  Copyright (c) 2014 FBL. All rights reserved.
//

typedef void (^CKFeedSourceFetchCompletionBlock)(NSArray *items, NSError *error);

@protocol FBFeedSource <NSObject>

@property (nonatomic, readonly, assign) BOOL hasMore;
@property (nonatomic, readonly) BOOL isFetching; // FIXME: use a getter named "isFetching"; name the property "fetching"

- (BOOL)fetchRange:(NSRange)range completionBlock:(CKFeedSourceFetchCompletionBlock)completionBlock;
- (void)cancel;

@end

//

@interface FBFeedSource : NSObject <FBFeedSource>
@end
