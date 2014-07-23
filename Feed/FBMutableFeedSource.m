//
//  FBMutableFeedSource.m
//
//  Created by Fred Brunel on 2014-06-30.
//  Copyright (c) 2014 FBL. All rights reserved.
//

#import "FBMutableFeedSource.h"

@interface FBMutableFeedSource ()

@property (nonatomic, readwrite, assign) BOOL hasMore;
@property (nonatomic, readwrite, assign) BOOL isFetching;
@property (nonatomic, readwrite, assign) NSUInteger position;
@property (nonatomic, readwrite, assign) NSUInteger count;

@property (nonatomic, assign) NSRange fetchRange;
@property (nonatomic, strong) id fetchObject;
@property (nonatomic, copy) CKFeedSourceFetchCompletionBlock completionBlock;

@end

//

@implementation FBMutableFeedSource

@synthesize hasMore = _hasMore;
@synthesize isFetching = _isFetching;
@synthesize position = _position;
@synthesize count = _count;

#pragma mark Initialization

+ (instancetype)feedSource {
    return [[[self class] alloc] init];
}

- (instancetype)init {
	if (self = [super init]) {
		[self reset];
	}
	return self;
}

- (void)reset {
	self.hasMore = YES;
	self.isFetching = NO;
    self.position = 0;
    self.count = NSNotFound;
    self.fetchObject = nil;
}

#pragma mark Public API

- (BOOL)fetchRange:(NSRange)range completionBlock:(CKFeedSourceFetchCompletionBlock)completionBlock {
    if (self.isFetching == YES || self.hasMore == NO)
        return NO;
    
	self.fetchRange = range;
	self.isFetching = YES;
    self.completionBlock = completionBlock;
    
    if (self.fetchBlock) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.fetchObject = self.fetchBlock(self.fetchRange);
        });
    }
    
	return YES;
}

- (void)cancel {
	self.isFetching = NO;
    
    if (self.cancelBlock) {
        self.cancelBlock(self.fetchObject);
    }
    
    self.fetchObject = nil;
}

#pragma mark Completion Callbacks

- (void)completeFetchWithItems:(NSArray *)items {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hasMore = (items.count >= self.fetchRange.length);
        self.isFetching = NO;
        self.position += items.count;
        self.fetchObject = nil;
        
        if (self.completionBlock) {
            self.completionBlock(items, nil);
        }
    });
}

- (void)completeFetchWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isFetching = NO;
        self.fetchObject = nil;
        
        if (self.completionBlock) {
            self.completionBlock(nil, error);
        }
    });
}

@end
