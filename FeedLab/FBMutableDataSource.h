//
//  FBMutableDataSource.h
//
//  Created by Fred Brunel on 2014-06-30.
//  Copyright (c) 2014 FBL. All rights reserved.
//

#import "FBDataSource.h"

@class FBMutableDataSource;

typedef id   (^FBDataSourceFetchBlock)(NSRange range);
typedef void (^FBDataSourceCancelBlock)(id fetchObject);

/**
 */
@interface FBMutableDataSource : FBDataSource

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
@property (nonatomic, copy) FBDataSourceFetchBlock fetchBlock;

/**
 */
@property (nonatomic, copy) FBDataSourceCancelBlock cancelBlock;

/**
 */
- (BOOL)fetchRange:(NSRange)range completionBlock:(FBDataSourceFetchCompletionBlock)completionBlock;

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