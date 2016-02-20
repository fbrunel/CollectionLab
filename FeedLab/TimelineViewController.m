//
//  TimelineViewController.m
//
//  Created by Fred Brunel on 2014-07-16.
//  Copyright (c) 2014 FBL. All rights reserved.
//

#import "TimelineViewController.h"
#import "TweetCell.h"
#import "Twitter.h"

@interface TimelineViewController ()

@property (strong, nonatomic) Twitter *twitter;
@property (strong, nonatomic) FBDataSource *tweetsDataSource;
@property (strong, nonatomic) NSMutableArray *tweets;
@property (assign, nonatomic) NSUInteger page;
@property (assign, nonatomic) NSUInteger length;
@property (assign, nonatomic) NSUInteger cellWidth;
@property (strong, nonatomic) TweetCell *prototypeCell;

@end

@implementation TimelineViewController

- (void)awakeFromNib {
    self.tweets = [NSMutableArray array];
    self.page = 1;
    self.length = 20;
    self.cellWidth = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *cellNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"TweetCell"];
    self.prototypeCell = [[cellNib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    //[self.prototypeCell updateConstraintsForSize:self.view.bounds.size];
    return;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.twitter = [[Twitter alloc] init];
    self.tweetsDataSource = [self.twitter dataSourceForHomeTimeline];
    
    [self fetchNext];
}

- (void)fetchNext {
    [self.tweetsDataSource fetchRange:NSMakeRange(self.page, self.length) completionBlock:^(NSArray *items, NSError *error) {
        [self.tweets addObjectsFromArray:items];
        [self.collectionView reloadData];
        [self updateTitle];
        self.page++;
    }];
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
    
    // FIXME: Find a way to do that better
    if (self.cellWidth == 0) {
        [cell updateConstraintsForWidth:self.view.bounds.size.width];
    } else {
        [cell updateConstraintsForWidth:self.cellWidth];
    }
    
    return cell;
}

- (void)cleanupCell:(TweetCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    return;
}

//

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > self.tweets.count - 5)
        [self fetchNext];
    
    TweetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TweetCell" forIndexPath:indexPath];
    [self configureCell:(TweetCell *)cell forItemAtIndexPath:indexPath];
    [cell updateConstraintsIfNeeded];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    [self configureCell:self.prototypeCell forItemAtIndexPath:indexPath];
    [self.prototypeCell setNeedsUpdateConstraints];
    [self.prototypeCell setNeedsLayout];
    return [self.prototypeCell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    return;
}

- (void)collectionView:(UICollectionView *)collectionView
  didEndDisplayingCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self cleanupCell:(TweetCell *)cell forItemAtIndexPath:indexPath];
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

//

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self.collectionViewLayout invalidateLayout];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    UIUserInterfaceSizeClass hc = self.traitCollection.horizontalSizeClass;
    UIUserInterfaceSizeClass vc = self.traitCollection.verticalSizeClass;
    
    if (hc == UIUserInterfaceSizeClassRegular && vc == UIUserInterfaceSizeClassCompact) {
        self.cellWidth = self.view.bounds.size.width / 2.0f;
        return;
    }
    
    if (hc == UIUserInterfaceSizeClassCompact && vc == UIUserInterfaceSizeClassCompact) {
        self.cellWidth = self.view.bounds.size.width / 1.5f;
        return;
    }
    
    self.cellWidth = 0;
}

@end
