//
//  TimelineViewController.m
//  FeedSource
//
//  Created by Fred Brunel on 2014-07-16.
//  Copyright (c) 2014 FBL. All rights reserved.
//

#import "TimelineViewController.h"
#import "TweetCell.h"
#import "Twitter.h"

@interface TimelineViewController ()

@property (strong, nonatomic) Twitter *twitter;
@property (strong, nonatomic) FBFeedSource *feedSource;
@property (strong, nonatomic) NSMutableArray *tweets;
@property (assign, nonatomic) NSUInteger page;
@property (assign, nonatomic) NSUInteger length;

@end

@implementation TimelineViewController

- (void)awakeFromNib {
    self.tweets = [NSMutableArray array];
    self.page = 1;
    self.length = 20;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.twitter = [[Twitter alloc] init];
    self.feedSource = [self.twitter sourceForHomeTimeline];
    
    [self fetchNext];
}

- (void)fetchNext {
    TimelineViewController *__weak welf = self;
    [self.feedSource fetchRange:NSMakeRange(self.page, self.length) completionBlock:^(NSArray *items, NSError *error) {
        [welf.tweets addObjectsFromArray:items];
        [welf.collectionView reloadData];
        [welf updateTitle];
        welf.page++;
    }];
}

- (void)updateTitle {
    self.title = [NSString stringWithFormat:@"Tweets (%d)", self.tweets.count];
}

//

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row > self.tweets.count - 5)
        [self fetchNext];
    
    TweetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TweetCell" forIndexPath:indexPath];
    Tweet *tweet = self.tweets[indexPath.item];
    
    cell.textLabel.text = tweet.text;
    cell.usernameLabel.text = tweet.userName;
    cell.dateLabel.text = tweet.dateRepresentation;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}

@end
