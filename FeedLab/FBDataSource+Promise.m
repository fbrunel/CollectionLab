//
//  FBDataSource+Promise.m
//
//  Created by Fred Brunel on 2014-07-23.
//  Copyright (c) 2014 FBL. All rights reserved.
//

#import "FBDataSource+Promise.h"

@implementation FBDataSource (Promise)

- (PMKPromise *)promiseFetchRange:(NSRange)range {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        [self fetchRange:range completionBlock:^(NSArray *items, NSError *error) {
            if (error) {
                rejecter(error);
            } else {
                fulfiller(items);
            }
        }];
    }];
}

@end
