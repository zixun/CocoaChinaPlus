//
//  RxCollectionViewSectionedDataSource.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 7/2/15.
//  Copyright (c) 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation
import UIKit
#if !RX_NO_MODULE
import RxSwift
import RxCocoa
#endif
    
open class _RxCollectionViewSectionedDataSource : NSObject
                                                  , UICollectionViewDataSource {
    
    func _numberOfSectionsInCollectionView(_ collectionView: UICollectionView) -> Int {
        return 0
    }
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return _numberOfSectionsInCollectionView(collectionView)
    }

    func _collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _collectionView(collectionView, numberOfItemsInSection: section)
    }

    func _collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        return (nil as UICollectionViewCell?)!
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return _collectionView(collectionView, cellForItemAtIndexPath: indexPath)
    }

    func _collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: IndexPath) -> UICollectionReusableView {
        return (nil as UICollectionReusableView?)!
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return _collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)
    }
}

open class RxCollectionViewSectionedDataSource<S: SectionModelType> : _RxCollectionViewSectionedDataSource {
    public typealias I = S.Item
    public typealias Section = S
    public typealias CellFactory = (UICollectionView, IndexPath, I) -> UICollectionViewCell
    public typealias SupplementaryViewFactory = (UICollectionView, String, IndexPath) -> UICollectionReusableView
    
    public typealias IncrementalUpdateObserver = AnyObserver<Changeset<S>>
    
    public typealias IncrementalUpdateDisposeKey = Bag<IncrementalUpdateObserver>.KeyType
    
    // This structure exists because model can be mutable
    // In that case current state value should be preserved.
    // The state that needs to be preserved is ordering of items in section
    // and their relationship with section.
    // If particular item is mutable, that is irrelevant for this logic to function
    // properly.
    public typealias SectionModelSnapshot = SectionModel<S, I>
    
    var sectionModels: [SectionModelSnapshot] = []
    
    open func sectionAtIndex(_ section: Int) -> S {
        return self.sectionModels[section].model
    }

    open func itemAtIndexPath(_ indexPath: IndexPath) -> I {
        return self.sectionModels[indexPath.section].items[indexPath.item]
    }
    
    var incrementalUpdateObservers: Bag<IncrementalUpdateObserver> = Bag()
    
    open func setSections(_ sections: [S]) {
        self.sectionModels = sections.map { SectionModelSnapshot(model: $0, items: $0.items) }
    }
    
    open var cellFactory: CellFactory! = nil
    open var supplementaryViewFactory: SupplementaryViewFactory
    
    public override init() {
        self.cellFactory = { _, _, _ in return (nil as UICollectionViewCell?)! }
        self.supplementaryViewFactory = { _, _, _ in (nil as UICollectionReusableView?)! }
        
        super.init()
        
        self.cellFactory = { [weak self] _ in
            precondition(false, "There is a minor problem. `cellFactory` property on \(self!) was not set. Please set it manually, or use one of the `rx_bindTo` methods.")
            
            return (nil as UICollectionViewCell!)!
        }
        
        self.supplementaryViewFactory = { [weak self] _, _, _ in
            precondition(false, "There is a minor problem. `supplementaryViewFactory` property on \(self!) was not set.")
            return (nil as UICollectionReusableView?)!
        }
    }
    
    // observers
    
    open func addIncrementalUpdatesObserver(_ observer: IncrementalUpdateObserver) -> IncrementalUpdateDisposeKey {
        return incrementalUpdateObservers.insert(observer)
    }
    
    open func removeIncrementalUpdatesObserver(_ key: IncrementalUpdateDisposeKey) {
        let element = incrementalUpdateObservers.removeKey(key)
        precondition(element != nil, "Element removal failed")
    }
    
    // UITableViewDataSource
    
    override func _numberOfSectionsInCollectionView(_ collectionView: UICollectionView) -> Int {
        return sectionModels.count
    }
    
    override func _collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionModels[section].items.count
    }
    
    override func _collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        precondition(indexPath.item < sectionModels[indexPath.section].items.count)
        
        return cellFactory(collectionView, indexPath, itemAtIndexPath(indexPath))
    }
    
    override func _collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: IndexPath) -> UICollectionReusableView {
        return supplementaryViewFactory(collectionView, kind, indexPath)
    }
}
