//
//  UIImage+Clip.swift
//  CocoaChinaPlus
//
//  Created by user on 15/11/9.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation
import UIKit

// MARK: - clip image
public extension UIImage {
    
    /**
     裁剪出图片指定rect区域的内容
     
     - parameter rect: rect区域
     
     - returns: 裁剪后的图片对象
     */
    public func clipImageByRect(rect:CGRect) -> UIImage {
        let subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect)
        guard subImageRef != nil else {
            return self
        }
        let smallImage = UIImage(CGImage: subImageRef!)
        return smallImage
    }
    
    
    /**
     裁剪出图片指定Edge的内容
     
     - parameter edge: Edge值
     
     - returns: 裁剪后的图片对象
     */
    public func clipImageByEdge(edge:Int) -> UIImage {
        let height = CGImageGetHeight(self.CGImage) - edge * 2
        let width = CGImageGetWidth(self.CGImage) - edge * 2
        let rect = CGRect(x: edge, y: edge, width: width, height: height)
        
        let image = self.clipImageByRect(rect)
        return image
    }
}