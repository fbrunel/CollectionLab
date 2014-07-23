//
//  FBFeedSource+Promise.h
//  Feed
//
//  Created by Fred Brunel on 2014-07-23.
//  Copyright (c) 2014 FBL. All rights reserved.
//

#import "FBFeedSource.h"
#import "PromiseKit/Promise.h"

@interface FBFeedSource (Promise)

- (PMKPromise *)promiseFetchRange:(NSRange)range;

@end
