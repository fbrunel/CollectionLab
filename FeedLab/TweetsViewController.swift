//
//  TweetsViewController.swift
//  FeedLab
//
//  Created by Fred Brunel on 2016-02-22.
//  Copyright © 2016 FBL. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    var collectionPresenter: CollectionPresenter!
    var twitter: Twitter!
    var tweetsDataSource: FBDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        collectionPresenter = CollectionViewPresenter(view: collectionView)
        twitter = Twitter()
        tweetsDataSource = twitter.dataSourceForHomeTimeline()
        
        self.fetchNextTweets()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //
    
    func fetchNextTweets() {
        // FIXME: add generics to Obj-C code
        tweetsDataSource.fetchRange(NSMakeRange(0, 20)) { (tweets, error) in
            for item in tweets {
                let tweet = item as! Tweet
                self.collectionPresenter.addItemPresenter(TweetPresenter(tweet: tweet))
            }
            self.collectionView.reloadData()
        }
    }
}
