//
//  UINavigationBar+FixedSpace.swift
//  CocoaChinaPlus
//
//  Created by user on 15/10/27.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation
import UIKit

public extension UINavigationItem {
    
    /**
     添加一组与屏幕右边对其的rightBarButtonItems
     
     - parameter items: rightBarButtonItem数组
     */
    public func rightBarButtonItemsFixedSpace(items:[UIBarButtonItem]?) {
        guard items != nil else {
            return;
        }
        
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        negativeSpacer.width = -15;
        
        var rightBarButtonItems = items!
        rightBarButtonItems.insert(negativeSpacer, atIndex: 0);
        self.rightBarButtonItems = rightBarButtonItems
    }
    
    /**
     添加一个与屏幕右边对其的rightBarButtonItem
     
     - parameter item: UIBarButtonItem
     */
    public func rightBarButtonItemFixedSpace(item:UIBarButtonItem) {
        self.rightBarButtonItemsFixedSpace([item])
    }
}