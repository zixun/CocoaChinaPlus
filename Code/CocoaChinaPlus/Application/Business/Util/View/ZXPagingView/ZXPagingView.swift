//
//  ZXPagingView.swift
//  CocoaChinaPlus
//
//  Created by 子循 on 15/6/21.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation
import UIKit

/// 放内容的Page
open class ZXPage: UICollectionViewCell {
    
    var index:Int?
}

public protocol ZXPagingViewDelegate: NSObjectProtocol {
    
    func numberOfItemsInPagingView(_ pagingView:ZXPagingView) -> Int
    
    func pagingView(_ pagingView:ZXPagingView, cellForPageAtIndex index: Int) -> ZXPage
    
    func pagingView(_ pagingView:ZXPagingView,movingFloatIndex floatIndex:Float)
    
    func pagingView(_ pagingView:ZXPagingView, didMoveToPageAtIndex index:Int)
    
    func pagingView(_ pagingView:ZXPagingView, willMoveToPageAtIndex index:Int)
    
}

open class ZXPagingView: UICollectionView, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UICollectionViewDataSource {
    
    open weak var pagingDelegate:ZXPagingViewDelegate?
    
    open var currentIndex:Int = 0 {
        
        didSet{
            self.moveToIndex(currentIndex)
        }
    }
    
    fileprivate var isDisplay:Bool = false
    
    override open var frame: CGRect {
        didSet {
            let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
            if !layout.itemSize.equalTo(frame.size) {
                
                layout.itemSize = frame.size
                layout.invalidateLayout()
            }
        }
    }
    
    
    public init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = frame.size
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.delegate = self
        self.dataSource = self
        self.isPagingEnabled = true
        self.bounces = false
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        
    }
    public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    open func reloadItemsAtIndex(_ index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        self.reloadItems(at: [indexPath])
    }
    
    open func moveToIndex(_ index:Int) {
        let offset = CGPoint(x: self.frame.size.width * CGFloat(index), y: 0)
        self.setContentOffset(offset, animated: true)
    }
    
    open func pageAtLocation(_ location:CGPoint) -> ZXPage?{
        guard self.bounds.contains(location) else {
            return nil
        }
        
        let index = Int(location.x / self.bounds.size.width)
        
        let pages = self.visibleCells as! [ZXPage]
        
        for page in pages {
            if page.index == index {
                return page
            }
        }
        
        return nil
    }
    
    
    open func dequeueReusablePageWithReuseIdentifier(_ identifier: String, forIndex index: Int) -> ZXPage {
        let page = self.dequeueReusableCell(withReuseIdentifier: identifier, for: IndexPath(row: index, section: 0) ) as! ZXPage
        page.index = index
        
        return page
    }
    
    // MARK: pagingView scroll delegate
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.collectionView(self, numberOfItemsInSection: 0) != 0 else {
            return
        }
        
        _callMovingDelegateIfNeeded(scrollView)
    }
    
    // MARK: pagingView dataSource
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pagingDelegate != nil ? self.pagingDelegate!.numberOfItemsInPagingView(self) : 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard self.pagingDelegate != nil else {
            return ZXPage()
        }
        
        let cell = self.pagingDelegate!.pagingView(self, cellForPageAtIndex: indexPath.row)
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pagingDelegate?.pagingView(self, willMoveToPageAtIndex: indexPath.row)
        
        if indexPath.row == 0 && self.isDisplay == false {
            self.isDisplay = true
            self.pagingDelegate?.pagingView(self, didMoveToPageAtIndex: indexPath.row)
        }
    }
    
    // MARK: pagingView layout delegate
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    // MARK: private method
    fileprivate func _callMovingDelegateIfNeeded(_ scrollView: UIScrollView) {
        
        let itemSize = (self.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        guard itemSize.equalTo(CGSize.zero) == false else {
            return
        }
        let offsetX = scrollView.contentOffset.x
        
        
        let floatIndex = Float(offsetX / itemSize.width)
        
        self.pagingDelegate?.pagingView(self, movingFloatIndex: floatIndex)
        
        if floatIndex - Float(Int(floatIndex)) == 0 {
            self.pagingDelegate?.pagingView(self, didMoveToPageAtIndex: Int(floatIndex))
        }
    }
    
}
