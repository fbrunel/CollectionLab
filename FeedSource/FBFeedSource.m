//
//  FBFeedSource.m
//
//  Created by Fred Brunel on 2014-06-30.
//  Copyright (c) 2014 FBL. All rights reserved.
//

#import "FBFeedSource.h"

@implementation FBFeedSource

@synthesize hasMore = _hasMore;
@synthesize isFetching = _isFetching;
@synthesize position = _position;
@synthesize count = _count;

- (BOOL)fetchRange:(NSRange)range completionBlock:(CKFeedSourceFetchCompletionBlock)completionBlock {
    return NO;
}

- (void)cancel {
    return;
}

@end
