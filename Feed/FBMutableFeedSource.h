//
//  FBMutableFeedSource.h
//
//  Created by Fred Brunel on 2014-06-30.
//  Copyright (c) 2014 FBL. All rights reserved.
//

#import "FBFeedSource.h"

@class FBMutableFeedSource;

typedef id   (^CKFeedSourceFetchBlock)(NSRange range);
typedef void (^CKFeedSourceCancelBlock)(id fetchObject);

/**
 */
@interface FBMutableFeedSource : FBFeedSource

///-----------------------------------
/// @name Creating a feed source object
///-----------------------------------

/**
 */
+ (instancetype)feedSource;

///-----------------------------------
/// @name Executing the Request
///-----------------------------------

/**
 */
@property (nonatomic, copy) CKFeedSourceFetchBlock fetchBlock;

/**
 */
@property (nonatomic, copy) CKFeedSourceCancelBlock cancelBlock;

/**
 */
- (BOOL)fetchRange:(NSRange)range completionBlock:(CKFeedSourceFetchCompletionBlock)completionBlock;

/**
 */
- (void)cancel;

/** Notifying of new fetched items.
 */
- (void)completeFetchWithItems:(NSArray *)items;

/** Notification of an error that occured during the fetching of items.
 */
- (void)completeFetchWithError:(NSError *)error;

@end