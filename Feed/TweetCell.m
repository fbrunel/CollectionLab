//
//  TweetCell.m
//  Feed
//
//  Created by Fred Brunel on 2014-08-07.
//  Copyright (c) 2014 FBL. All rights reserved.
//

#import "TweetCell.h"

@implementation TweetCell

- (void)awakeFromNib {
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.profileImageView.layer.borderWidth = 0.5f;
    return;
}

- (void)prepareForReuse {
    [self.profileImageView cancelImageRequestOperation];
}

@end
