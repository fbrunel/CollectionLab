//
//  TableTimelineViewController.m
//  FeedSource
//
//  Created by Fred Brunel on 2014-06-30.
//  Copyright (c) 2014 FBL. All rights reserved.
//

#import "TableTimelineViewController.h"
#import "TableTweetCell.h"
#import "Twitter.h"

@interface TableTimelineViewController ()
@property (strong, nonatomic) Twitter *twitter;
@property (strong, nonatomic) FBFeedSource *feedSource;
@property (strong, nonatomic) NSMutableArray *tweets;
@property (assign, nonatomic) NSUInteger page;
@property (assign, nonatomic) NSUInteger length;
@end

//

@implementation TableTimelineViewController

- (void)awakeFromNib {
    [self clearData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.twitter = [[Twitter alloc] init];
    self.feedSource = [self.twitter sourceForHomeTimeline];
 
    [self fetchNext];
}

//

- (void)clearData {
    self.tweets = [NSMutableArray array];
    self.page = 1;
    self.length = 20;
}

- (void)fetchNext {
    TableTimelineViewController *__weak welf = self;
    [self.feedSource fetchRange:NSMakeRange(self.page, self.length) completionBlock:^(NSArray *items, NSError *error) {
        [welf.tweets addObjectsFromArray:items];
        [welf.tableView reloadData];
        [welf updateTitle];
        welf.page++;
    }];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    TableTimelineViewController *__weak welf = self;
    BOOL result = [self.feedSource fetchRange:NSMakeRange(1, self.length) completionBlock:^(NSArray *items, NSError *error) {
        [welf clearData];
        [welf.tweets addObjectsFromArray:items];
        [welf.tableView reloadData];
        [welf updateTitle];
        [refreshControl endRefreshing];
        welf.page++;
    }];
    
    if (result == NO)
        [refreshControl endRefreshing];
}

- (void)updateTitle {
    self.title = [NSString stringWithFormat:@"Tweets (%ld)", self.tweets.count];
}

//

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableTweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.tweets[indexPath.row];
    
    cell.contentLabel.text = tweet.text;
    cell.usernameLabel.text = tweet.userName;
    cell.dateLabel.text = tweet.dateRepresentation;
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > self.tweets.count - 5)
        [self fetchNext];
}

@end
