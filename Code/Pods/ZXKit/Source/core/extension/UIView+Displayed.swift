//
//  UIView+ZXHelper.swift
//  CocoaChinaPlus
//
//  Created by 子循 on 15/7/30.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
 
    public func isDisplayedInScreen() -> Bool {
        //不在window中
        if self.window == nil {
            return false
        }
        
        //隐藏
        if self.hidden == true {
            return false
        }
        
        //width 或 height 为0 或者为null
        if CGRectIsEmpty(self.bounds) {
            return false
        }
        
        let windowBounds:CGRect = self.window!.bounds
        let rectToWindow = self.convertRect(self.frame, toView: self.window)
        let intersectionRect = CGRectIntersection(rectToWindow, windowBounds);
        // 如果在屏幕外
        if (CGRectIsEmpty(intersectionRect)) {
            return false;
        }
        return true;
    }
}