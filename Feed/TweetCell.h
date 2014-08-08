//
//  TweetCell.h
//  Feed
//
//  Created by Fred Brunel on 2014-08-07.
//  Copyright (c) 2014 FBL. All rights reserved.
//

@interface TweetCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
