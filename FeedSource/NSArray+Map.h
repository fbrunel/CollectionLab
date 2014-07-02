//
//  NSArray+Map.h
//  FeedSource
//
//  Created by Fred Brunel on 2014-07-01.
//  Copyright (c) 2014 FBL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Map)

- (NSArray *)mapObjectsUsingBlock:(id (^)(id object, NSUInteger index))block;

@end
