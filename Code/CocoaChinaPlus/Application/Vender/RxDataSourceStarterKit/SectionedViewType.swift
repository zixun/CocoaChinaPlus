//
//  SectionedViewType.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 6/27/15.
//  Copyright (c) 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation
import UIKit

func indexSet(_ values: [Int]) -> IndexSet {
    let indexSet = NSMutableIndexSet()
    for i in values {
        indexSet.add(i)
    }
    return indexSet as IndexSet
}

extension UITableView : SectionedViewType {
    func insertItemsAtIndexPaths(_ paths: [IndexPath], animationStyle: UITableViewRowAnimation) {
        self.insertRows(at: paths, with: animationStyle)
    }
    
    func deleteItemsAtIndexPaths(_ paths: [IndexPath], animationStyle: UITableViewRowAnimation) {
        self.deleteRows(at: paths, with: animationStyle)
    }
    
    func moveItemAtIndexPath(_ from: IndexPath, to: IndexPath) {
        self.moveRow(at: from, to: to)
    }
    
    func reloadItemsAtIndexPaths(_ paths: [IndexPath], animationStyle: UITableViewRowAnimation) {
        self.reloadRows(at: paths, with: animationStyle)
    }
    
    func insertSections(_ sections: [Int], animationStyle: UITableViewRowAnimation) {
        self.insertSections(indexSet(sections), with: animationStyle)
    }
    
    func deleteSections(_ sections: [Int], animationStyle: UITableViewRowAnimation) {
        self.deleteSections(indexSet(sections), with: animationStyle)
    }
    
    func moveSection(_ from: Int, to: Int) {
        self.moveSection(from, toSection: to)
    }
    
    func reloadSections(_ sections: [Int], animationStyle: UITableViewRowAnimation) {
        self.reloadSections(indexSet(sections), with: animationStyle)
    }

    func performBatchUpdates<S: SectionModelType>(_ changes: Changeset<S>) {
        self.beginUpdates()
        _performBatchUpdates(self, changes: changes)
        self.endUpdates()
    }
}

extension UICollectionView : SectionedViewType {
    func insertItemsAtIndexPaths(_ paths: [IndexPath], animationStyle: UITableViewRowAnimation) {
        self.insertItems(at: paths)
    }
    
    func deleteItemsAtIndexPaths(_ paths: [IndexPath], animationStyle: UITableViewRowAnimation) {
        self.deleteItems(at: paths)
    }

    func moveItemAtIndexPath(_ from: IndexPath, to: IndexPath) {
        self.moveItem(at: from, to: to)
    }
    
    func reloadItemsAtIndexPaths(_ paths: [IndexPath], animationStyle: UITableViewRowAnimation) {
        self.reloadItems(at: paths)
    }
    
    func insertSections(_ sections: [Int], animationStyle: UITableViewRowAnimation) {
        self.insertSections(indexSet(sections))
    }
    
    func deleteSections(_ sections: [Int], animationStyle: UITableViewRowAnimation) {
        self.deleteSections(indexSet(sections))
    }
    
    func moveSection(_ from: Int, to: Int) {
        self.moveSection(from, toSection: to)
    }
    
    func reloadSections(_ sections: [Int], animationStyle: UITableViewRowAnimation) {
        self.reloadSections(indexSet(sections))
    }
    
    func performBatchUpdates<S: SectionModelType>(_ changes: Changeset<S>) {
        self.performBatchUpdates({ () -> Void in
            _performBatchUpdates(self, changes: changes)
        }, completion: { (completed: Bool) -> Void in
        })
    }
}

protocol SectionedViewType {
    func insertItemsAtIndexPaths(_ paths: [IndexPath], animationStyle: UITableViewRowAnimation)
    func deleteItemsAtIndexPaths(_ paths: [IndexPath], animationStyle: UITableViewRowAnimation)
    func moveItemAtIndexPath(_ from: IndexPath, to: IndexPath)
    func reloadItemsAtIndexPaths(_ paths: [IndexPath], animationStyle: UITableViewRowAnimation)
    
    func insertSections(_ sections: [Int], animationStyle: UITableViewRowAnimation)
    func deleteSections(_ sections: [Int], animationStyle: UITableViewRowAnimation)
    func moveSection(_ from: Int, to: Int)
    func reloadSections(_ sections: [Int], animationStyle: UITableViewRowAnimation)

    func performBatchUpdates<S>(_ changes: Changeset<S>)
}

func setFor<E, K>(_ items: [E], transform: (E) -> K) -> [K : K] {
    var res = [K : K]()
    
    for i in items {
        let k = transform(i)
        res[k] = k
    }
    
    return res
}

func _performBatchUpdates<V: SectionedViewType, S: SectionModelType>(_ view: V, changes: Changeset<S>) {
    typealias I = S.Item
    let rowAnimation = UITableViewRowAnimation.automatic
    
    view.deleteSections(changes.deletedSections, animationStyle: rowAnimation)
    view.reloadSections(changes.updatedSections, animationStyle: rowAnimation)
    view.insertSections(changes.insertedSections, animationStyle: rowAnimation)
    for (from, to) in changes.movedSections {
        view.moveSection(from, to: to)
    }
    
    view.deleteItemsAtIndexPaths(
        changes.deletedItems.map { IndexPath(item: $0.itemIndex, section: $0.sectionIndex) },
        animationStyle: rowAnimation
    )
    view.insertItemsAtIndexPaths(
        changes.insertedItems.map { IndexPath(item: $0.itemIndex, section: $0.sectionIndex) },
        animationStyle: rowAnimation
    )
    view.reloadItemsAtIndexPaths(
        changes.updatedItems.map { IndexPath(item: $0.itemIndex, section: $0.sectionIndex) },
        animationStyle: rowAnimation
    )
    
    for (from, to) in changes.movedItems {
        view.moveItemAtIndexPath(
            IndexPath(item: from.itemIndex, section: from.sectionIndex),
            to: IndexPath(item: to.itemIndex, section: to.sectionIndex)
        )
    }
}
