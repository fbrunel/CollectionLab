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
#import "FBFeedSource+Promise.h"

@interface TimelineViewController ()

@property (strong, nonatomic) Twitter *twitter;
@property (strong, nonatomic) FBFeedSource *feedSource;
@property (strong, nonatomic) NSMutableArray *tweets;
@property (assign, nonatomic) NSUInteger page;
@property (assign, nonatomic) NSUInteger length;
@property (strong, nonatomic) TweetCell *prototypeCell;

@end

@implementation TimelineViewController

- (void)awakeFromNib {
    self.tweets = [NSMutableArray array];
    self.page = 1;
    self.length = 20;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"TweetCell"];
    self.prototypeCell = [[cellNib instantiateWithOwner:nil options:nil] objectAtIndex:0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.twitter = [[Twitter alloc] init];
    self.feedSource = [self.twitter sourceForHomeTimeline];
    
    [self fetchNext];
}

- (void)fetchNext {
    [self.feedSource promiseFetchRange:NSMakeRange(self.page, self.length)].then(^(NSArray *items) {
        [self.tweets addObjectsFromArray:items];
        [self.collectionView reloadData];
        [self updateTitle];
        self.page++;
    }).catch(^(NSError *error) {
        return;
    });
}

- (void)updateTitle {
    self.title = [NSString stringWithFormat:@"Tweets (%@)", @(self.tweets.count)];
}

//

- (TweetCell *)configureCell:(TweetCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    Tweet *tweet = self.tweets[indexPath.item];
    cell.textLabel.text = tweet.text;
    cell.usernameLabel.text = tweet.userName;
    cell.dateLabel.text = [tweet dateRepresentation];
    
    // FIXME: this is not ideal, I would have preferred another method to trigger the image
    // loading without introducing a dependency on the type of cell being configured.
    if (cell != self.prototypeCell) {
        [cell.profileImageView setImageWithURL:tweet.profileImageURL];
    }
    
    return cell;
}

//

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > self.tweets.count - 5)
        [self fetchNext];
    
    TweetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TweetCell" forIndexPath:indexPath];
    return [self configureCell:cell forItemAtIndexPath:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [[self configureCell:self.prototypeCell forItemAtIndexPath:indexPath] systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    return;
}

//

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}


@end
