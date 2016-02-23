//
//  TweetPresenter.swift
//  FeedLab
//
//  Created by Fred Brunel on 2016-02-20.
//  Copyright © 2016 FBL. All rights reserved.
//

import UIKit

class TweetPresenter : NSObject, ItemPresenter {
    let identifier: String = "TweetCell"
    let tweet: Tweet
    
    init(tweet: Tweet) {
        self.tweet = tweet
    }
    
    func configureCell(cell: UICollectionViewCell, forSizing: Bool) {
        let tweetCell: TweetCell = cell as! TweetCell // FIXME: should be avoided by using generics
        
        tweetCell.textLabel?.text = tweet.text
        tweetCell.usernameLabel?.text = tweet.userName
        tweetCell.dateLabel?.text = tweet.dateRepresentation
        
        if forSizing == false {
            tweetCell.profileImageView?.setImageWithURL(tweet.profileImageURL)
        }
        
        tweetCell.updateConstraintsForWidth(320) // FIXME
    }
    
    func cleanupCell(cell: UICollectionViewCell) {
        return
    }
}
