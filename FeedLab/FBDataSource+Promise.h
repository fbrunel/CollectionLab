//
//  FBDataSource+Promise.h
//
//  Created by Fred Brunel on 2014-07-23.
//  Copyright (c) 2014 FBL. All rights reserved.
//

#import "FBDataSource.h"
#import "PromiseKit/Promise.h"

@interface FBDataSource (Promise)

- (PMKPromise *)promiseFetchRange:(NSRange)range;

@end
