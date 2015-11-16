//
//  UIScrollView+Capture.swift
//  CocoaChinaPlus
//
//  Created by zixun on 15/9/19.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation
import UIKit

public extension UIScrollView {
    
    public func capture()->UIImage{
        var image = UIImage();
        
        UIGraphicsBeginImageContextWithOptions(self.contentSize, false, UIScreen.mainScreen().scale)
        
        // save initial values
        let savedContentOffset = self.contentOffset;
        let savedFrame = self.frame;
        let savedBackgroundColor = self.backgroundColor
        
        // reset offset to top left point
        self.contentOffset = CGPointZero;
        // set frame to content size
        self.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
        // remove background
        self.backgroundColor = UIColor.clearColor()
        
        // make temp view with scroll view content size
        // a workaround for issue when image on ipad was drawn incorrectly
        let tempView = UIView(frame: CGRectMake(0, 0, self.contentSize.width, self.contentSize.height))
        
        // save superview
        let tempSuperView = self.superview
        // remove scrollView from old superview
        self.removeFromSuperview()
        // and add to tempView
        tempView.addSubview(self)
        
        // render view
        // drawViewHierarchyInRect not working correctly
        tempView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        // and get image
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        // and return everything back
        tempView.subviews[0].removeFromSuperview()
        tempSuperView?.addSubview(self)
        
        // restore saved settings
        self.contentOffset = savedContentOffset;
        self.frame = savedFrame;
        self.backgroundColor = savedBackgroundColor
        
        UIGraphicsEndImageContext();
        
        return image
    }
    
}