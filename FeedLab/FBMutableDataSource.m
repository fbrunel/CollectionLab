//
//  FBMutableDataSource.m
//
//  Created by Fred Brunel on 2014-06-30.
//  Copyright (c) 2014 FBL. All rights reserved.
//

#import "FBMutableDataSource.h"

@interface FBMutableDataSource ()

@property (nonatomic, readwrite, assign) BOOL hasMore;
@property (nonatomic, readwrite, assign) BOOL isFetching;

@property (nonatomic, assign) NSRange fetchRange;
@property (nonatomic, strong) id fetchObject;
@property (nonatomic, copy) FBDataSourceFetchCompletionBlock completionBlock;

@end

//

@implementation FBMutableDataSource

@synthesize hasMore = _hasMore;
@synthesize isFetching = _isFetching;

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
    self.fetchObject = nil;
}

#pragma mark Public API

- (BOOL)fetchRange:(NSRange)range completionBlock:(FBDataSourceFetchCompletionBlock)completionBlock {
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
