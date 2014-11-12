//
//  FBDataSource.m
//
//  Created by Fred Brunel on 2014-06-30.
//  Copyright (c) 2014 FBL. All rights reserved.
//

#import "FBDataSource.h"

@implementation FBDataSource

@synthesize hasMore = _hasMore;
@synthesize isFetching = _isFetching;

- (BOOL)fetchRange:(NSRange)range completionBlock:(FBDataSourceFetchCompletionBlock)completionBlock {
    return NO;
}

- (void)cancel {
    return;
}

@end
