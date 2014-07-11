//
//  TweetCell.h
//  FeedSource
//
//  Created by Fred Brunel on 2014-07-11.
//  Copyright (c) 2014 FBL. All rights reserved.
//

@interface TweetCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UILabel *usernameLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

@end
