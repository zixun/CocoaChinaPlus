//
//  RxTableViewDataSource.swift
//  RxCocoa
//
//  Created by Krunoslav Zaher on 6/15/15.
//  Copyright (c) 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation
import UIKit
#if !RX_NO_MODULE
import RxSwift
import RxCocoa
#endif

// objc monkey business
open class _RxTableViewSectionedDataSource : NSObject
                                             , UITableViewDataSource {
    
    func _numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return _numberOfSectionsInTableView(tableView)
    }

    func _tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _tableView(tableView, numberOfRowsInSection: section)
    }

    func _tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        return (nil as UITableViewCell?)!
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return _tableView(tableView, cellForRowAtIndexPath: indexPath)
    }

    func _tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return _tableView(tableView, titleForHeaderInSection: section)
    }

    func _tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
    
    open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return _tableView(tableView, titleForFooterInSection: section)
    }
    
    //NOTE: add by CHEN YILONG
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

open class RxTableViewSectionedDataSource<S: SectionModelType> : _RxTableViewSectionedDataSource {
    
    public typealias I = S.Item
    public typealias Section = S
    public typealias CellFactory = (UITableView, IndexPath, I) -> UITableViewCell
    
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
    
    open var titleForHeaderInSection: ((_ section: Int) -> String)?
    open var titleForFooterInSection: ((_ section: Int) -> String)?
    
    open var rowAnimation: UITableViewRowAnimation = .automatic
    
    public override init() {
        super.init()
        self.cellFactory = { [weak self] _ in
            if let strongSelf = self {
                precondition(false, "There is a minor problem. `cellFactory` property on \(strongSelf) was not set. Please set it manually, or use one of the `rx_bindTo` methods.")
            }
            
            return (nil as UITableViewCell!)!
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
    
    override func _numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return sectionModels.count
    }
    
    override func _tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionModels[section].items.count
    }
    
    override func _tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        precondition(indexPath.item < sectionModels[indexPath.section].items.count)
        
        return cellFactory(tableView, indexPath, itemAtIndexPath(indexPath))
    }
    
    override func _tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForHeaderInSection?(section)
    }
    
    override func _tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return titleForFooterInSection?(section)
    }
    
}
