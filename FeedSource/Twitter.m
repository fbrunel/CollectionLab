//
//  Twitter.m
//  FeedSource
//
//  Created by Fred Brunel on 2014-07-01.
//  Copyright (c) 2014 FBL. All rights reserved.
//

#import "Twitter.h"
#import "FBMutableFeedSource.h"
#import "NSArray+Map.h"

#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>

@interface Tweet ()
@property (strong, nonatomic) NSDictionary *JSONObject;
@end

@implementation Tweet

- (instancetype)initWithJSONObject:(NSDictionary *)JSONObject {
    if (self = [super init]) {
        self.JSONObject = JSONObject;
    }
    return self;
}

- (NSString *)text {
    return [self.JSONObject valueForKey:@"text"];
}

- (NSString *)userName {
    return [NSString stringWithFormat:@"@%@", [self.JSONObject valueForKeyPath:@"user.screen_name"]];
}

- (NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    NSDate *date = [formatter dateFromString:[self.JSONObject valueForKey:@"created_at"]];
    return date;
}

- (NSString *)dateRepresentation {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm"]; // was @"eee MMM dd hh:mm"; FIXME: should display date for after the next day
    return [formatter stringFromDate:self.date];
}

@end

//

@implementation Twitter

- (FBFeedSource *)sourceForHomeTimeline {
    FBMutableFeedSource *feedSource = [FBMutableFeedSource feedSource];
    
    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    ACAccount *twitterAccount = [[store accountsWithAccountType:twitterAccountType] firstObject];
    
    FBMutableFeedSource *__weak feedSourceRef = feedSource; // breaks the retain cycle between the feedSource and the fetchBlock
    feedSource.fetchBlock = (id)^(NSRange range) {
        [store requestAccessToAccountsWithType:twitterAccountType options:nil completion:^(BOOL granted, NSError *error) {
            NSURL *URL = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/home_timeline.json"];
            NSDictionary *params = @{ @"page": @(range.location).stringValue, @"count" : @(range.length).stringValue };
            
            // see https://dev.twitter.com/docs/working-with-timelines
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                    requestMethod:SLRequestMethodGET
                                                              URL:URL
                                                       parameters:params];
            request.account = twitterAccount;
            
            [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *httpResponse, NSError *error) {
                NSArray *items = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
                NSArray *tweets = [items mapObjectsUsingBlock:^id(id object, NSUInteger index) {
                    return [[Tweet alloc] initWithJSONObject:object];
                }];
                
                if (error) {
                    [feedSourceRef completeFetchWithError:error];
                } else {
                    [feedSourceRef completeFetchWithItems:tweets];
                }
            }];
        }];
    };
    
    return feedSource;
}

@end
