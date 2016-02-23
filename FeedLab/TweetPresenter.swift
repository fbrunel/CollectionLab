//
//  TweetPresenter.swift
//  FeedLab
//
//  Created by Fred Brunel on 2016-02-20.
//  Copyright © 2016 FBL. All rights reserved.
//

import UIKit

class TweetPresenter : NSObject, ItemPresenter {
    weak var collectionPresenter: CollectionPresenter?
    let identifier: String = "TweetCell"
    let tweet: Tweet
    
    init(tweet: Tweet) {
        self.tweet = tweet
    }
    
    func configureCell(cell: UICollectionViewCell, forSizing: Bool) {
        let tweetCell: TweetCell = cell as! TweetCell // FIXME: could be avoided by using generics

        // This thing is not ideal but the cell needs to have a width constraint
        tweetCell.preferredMaxLayoutWidth = collectionPresenter!.collectionView.bounds.size.width
        
        tweetCell.textLabel?.text = tweet.text
        tweetCell.usernameLabel?.text = tweet.userName
        tweetCell.dateLabel?.text = tweet.dateRepresentation
        
        if forSizing == false {
            tweetCell.profileImageView?.setImageWithURL(tweet.profileImageURL)
        }
    }
    
    func cleanupCell(cell: UICollectionViewCell) {
        return
    }
    
    func highlightDidChange(cell: UICollectionViewCell, highlighted: Bool) {
        if (highlighted) {
            cell.backgroundColor = UIColor(red: 0.9, green:0.9, blue:0.9, alpha:1.0)
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
    }
}
