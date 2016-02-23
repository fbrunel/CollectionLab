//
//  CollectionPresenter.swift
//  FeedLab
//
//  Created by Fred Brunel on 2016-02-19.
//  Copyright © 2016 FBL. All rights reserved.
//

import UIKit

protocol CollectionPresenter: class {
    var collectionView: UICollectionView { get } // FIXME: a generic type should be used
    func addItemPresenter(item: ItemPresenter)
}

protocol ItemPresenter {
    weak var collectionPresenter: CollectionPresenter? { get set } // FIXME: not sure it's necessary to expose this
    var identifier: String { get }
    func configureCell(cell: UICollectionViewCell, forSizing: Bool)
    func cleanupCell(cell: UICollectionViewCell)
    func highlightDidChange(cell: UICollectionViewCell, highlighted: Bool)
}

//

class CollectionViewPresenter : NSObject, CollectionPresenter, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    let collectionView: UICollectionView
    var presenters = [NSIndexPath: ItemPresenter]()
    var prototypeCells = [String: UICollectionViewCell]()
    
    init(view: UICollectionView) {
        self.collectionView = view
        super.init()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    func addItemPresenter(var item: ItemPresenter) {
        registerCell(item.identifier)
        item.collectionPresenter = self
        presenters[NSIndexPath(forItem: presenters.count, inSection: 0)] = item
    }
    
    //
    
    func registerCell(identifier: String) {
        let nib = UINib(nibName: identifier, bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: identifier)
        let prototypeCell = nib.instantiateWithOwner(nil, options: nil).first as! UICollectionViewCell
        prototypeCells[identifier] = prototypeCell
    }
    
    //
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenters.count // does not support sections
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let presenter = presenters[indexPath]!
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(presenter.identifier, forIndexPath: indexPath)
        presenter.configureCell(cell, forSizing: false)
        cell.updateConstraintsIfNeeded()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let presenter = presenters[indexPath]!
        let prototypeCell = prototypeCells[presenter.identifier]!
        presenter.configureCell(prototypeCell, forSizing: true)
        prototypeCell.setNeedsUpdateConstraints()
        prototypeCell.setNeedsLayout()
        return prototypeCell.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        presenters[indexPath]!.cleanupCell(cell)
    }
    
    //
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        presenters[indexPath]!.highlightDidChange(collectionView.cellForItemAtIndexPath(indexPath)!, highlighted: true)
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        presenters[indexPath]!.highlightDidChange(collectionView.cellForItemAtIndexPath(indexPath)!, highlighted: false)
    }
}
