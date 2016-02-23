//
//  TweetCell.h
//
//  Created by Fred Brunel on 2014-08-07.
//  Copyright (c) 2014 FBL. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>

@interface TweetCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

- (void)updateConstraintsForWidth:(CGFloat)width;

@end
